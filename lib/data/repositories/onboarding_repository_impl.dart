import 'package:growapp/core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/business_type_option.dart';
import '../../domain/entities/onboarding_step.dart';
import '../../domain/entities/pain_point_option.dart';
import '../../domain/entities/survey_question.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _loc(dynamic field, String locale) {
    if (field is Map) {
      return (field[locale] ?? field['tr'] ?? '') as String;
    }
    if (field is String) return field;
    return '';
  }

  @override
  Future<List<OnboardingStep>> getOnboardingSteps({String locale = 'tr'}) async {
    final snapshot = await _db
        .collection('onboarding_steps')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return OnboardingStep(
        id: doc.id,
        type: _mapStepType(data['type'] as String? ?? ''),
        title: _loc(data['title'], locale),
        subtitle: data['subtitle'] != null ? _loc(data['subtitle'], locale) : null,
        order: data['order'] as int? ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<BusinessTypeOption>> getBusinessTypes({String locale = 'tr'}) async {
    final snapshot = await _db.collection('business_types').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BusinessTypeOption(
        id: doc.id,
        name: _loc(data['name'], locale),
        icon: data['icon'] as String? ?? 'store',
        isAvailable: data['is_available'] as bool? ?? true,
      );
    }).toList();
  }

  @override
  Future<List<SurveyQuestion>> getSurveyQuestions(String businessType, {String locale = 'tr'}) async {
    // ecommerce has its own question set (q1_ecom..q7_ecom, business_type='ecommerce')
    // cafe/rest use legacy questions without a business_type field (doc IDs: q1..q7)
    final Query<Map<String, dynamic>> query;
    if (businessType == 'ecommerce') {
      query = _db.collection('questions')
          .where('business_type', isEqualTo: 'ecommerce')
          .orderBy('order_no');
    } else if (businessType == 'saas') {
      query = _db.collection('questions')
          .where('business_type', isEqualTo: 'saas')
          .orderBy('order_no');
    } else {
      query = _db.collection('questions')
          .where(FieldPath.documentId, whereIn: ['q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7']);
    }
    final snapshot = await query.get();

    final questions = <SurveyQuestion>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();

      final optionsSnapshot = await doc.reference
          .collection('options')
          .get();

      final options = optionsSnapshot.docs.map((o) {
        final optData = o.data();
        final scoreVal = optData['score'] as int? ?? 0;
        return SurveyOption(
          id: o.id,
          label: _loc(optData['label'], locale),
          mood: _mapMood(scoreVal),
          score: scoreVal,
          order: optData['order'] as int? ?? 0,
        );
      }).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      questions.add(SurveyQuestion(
        id: doc.id,
        question: _loc(data['title'], locale),
        order: data['order_no'] as int? ?? 0,
        options: options,
      ));
    }
    return questions;
  }

  @override
  Future<List<PainPointOption>> getPainPointOptions({String locale = 'tr'}) async {
    final snapshot = await _db.collection('pain_points').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PainPointOption(
        id: doc.id,
        label: _loc(data['label'], locale),
        icon: data['icon'] as String? ?? 'help',
      );
    }).toList();
  }

  @override
  Future<void> saveOnboardingAnswers(Map<String, dynamic> answers, {String? businessId, String? userId}) async {
    if (businessId == null) return;

    // Save API-format answers (q1-q7 with scores) to business document FIRST
    // This is critical — without api_answers, tasks won't load on dashboard
    // set+merge instead of update: avoids "document not found" if createBusiness hasn't fully committed yet
    final apiAnswers = answers['apiAnswers'] as Map<String, int>?;
    if (apiAnswers != null && apiAnswers.isNotEmpty) {
      await _db.collection('businesses').doc(businessId).set(
        {'api_answers': apiAnswers},
        SetOptions(merge: true),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => AppLogger.w('[OnboardingRepo]', 'api_answers set timed out — devam ediliyor'),
      );
    }

    // Save each survey answer as a separate document in onboarding_responses
    // Non-critical — if this fails (permission-denied), api_answers is already saved
    try {
      final surveyAnswers = answers['surveyAnswers'] as Map<String, dynamic>?;
      if (surveyAnswers != null && surveyAnswers.isNotEmpty) {
        final batch = _db.batch();
        for (final entry in surveyAnswers.entries) {
          final docRef = _db.collection('onboarding_responses').doc();
          batch.set(docRef, {
            'business_id': businessId,
            'question_id': entry.key,
            'option_id': entry.value.toString(),
            'created_at': FieldValue.serverTimestamp(),
            'user_id': userId,
          });
        }
        await batch.commit().timeout(const Duration(seconds: 8));
      }
    } catch (e) {
      // onboarding_responses write is non-critical — api_answers already saved above
      AppLogger.d('[OnboardingRepo]', 'onboarding_responses write failed (devam ediliyor): $e');
    }
  }

  // --- Mappers ---

  OnboardingStepType _mapStepType(String type) {
    return switch (type) {
      'business_name' => OnboardingStepType.businessName,
      'business_type' => OnboardingStepType.businessType,
      'survey' => OnboardingStepType.survey,
      'pain_points' => OnboardingStepType.painPoints,
      'ai_analysis' => OnboardingStepType.aiAnalysis,
      _ => OnboardingStepType.businessName,
    };
  }

  SurveyMood? _mapMood(int? score) {
    if (score == null) return null;
    if (score >= 3) return SurveyMood.happy;
    if (score == 2) return SurveyMood.neutral;
    return SurveyMood.sad;
  }

}
