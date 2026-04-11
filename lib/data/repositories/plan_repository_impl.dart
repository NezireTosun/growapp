import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/plan.dart';
import '../../domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<Plan>> getPlans() async {
    final snapshot = await _db
        .collection('plans')
        .where('is_active', isEqualTo: true)
        .orderBy('order')
        .get();

    return snapshot.docs.map(_mapDoc).toList();
  }

  @override
  Future<Plan> getPlanById(String planId) async {
    try {
      final doc = await _db.collection('plans').doc(planId).get();
      if (!doc.exists) {
        return planId == 'pro' ? _defaultProPlan : _defaultFreePlan;
      }
      return _mapDoc(doc);
    } catch (e) {
      // Firestore erişim hatası — varsayılan plan ile devam et
      return planId == 'pro' ? _defaultProPlan : _defaultFreePlan;
    }
  }

  @override
  Future<void> updateUserPlan(String userId, String planId) async {
    await _db.collection('users').doc(userId).update({
      'plan_id': planId,
    });
  }

  static const Plan _defaultProPlan = Plan(
    id: 'pro',
    name: 'Pro',
    price: 19.99,
    maxBusinesses: 5,
    maxMembersPerBusiness: 3,
    maxMessagesPerDay: 999,
    hasWhatsApp: true,
    hasNotifications: true,
    hasAnalytics: true,
    hasAiInsights: true,
    strategicDimensions: 7,
    strategicTasks: 999,
    features: [
      'business_analysis_360',
      'full_task_library',
      'visual_dashboard',
      'whatsapp_coach',
      'updated_content',
      'id_tracking',
    ],
  );

  static const Plan _defaultFreePlan = Plan(
    id: 'free',
    name: 'Free',
    price: 0,
    maxBusinesses: 1,
    maxMembersPerBusiness: 1,
    maxMessagesPerDay: 5,
    hasWhatsApp: true,
    hasNotifications: false,
    hasAnalytics: false,
    hasAiInsights: false,
    strategicDimensions: 7,
    strategicTasks: 30,
    features: [
      'business_analysis_360',
      'top_30_tasks',
      'basic_dashboard',
      'whatsapp',
      'trained_model',
    ],
  );

  Plan _mapDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final name = data['name'];
    return Plan(
      id: doc.id,
      name: name is Map
          ? (name['tr'] ?? name['en'] ?? '') as String
          : (name as String? ?? ''),
      price: (data['price'] as num?)?.toDouble() ?? 0,
      maxBusinesses: data['max_businesses'] as int? ?? 1,
      maxMembersPerBusiness: data['max_members_per_business'] as int? ?? 1,
      maxMessagesPerDay: data['max_messages_per_day'] as int? ?? 5,
      hasWhatsApp: data['has_whatsapp'] as bool? ?? false,
      hasNotifications: data['has_notifications'] as bool? ?? false,
      hasAnalytics: data['has_analytics'] as bool? ?? false,
      hasAiInsights: data['has_ai_insights'] as bool? ?? false,
      strategicDimensions: data['strategic_dimensions'] as int? ?? 7,
      strategicTasks: data['strategic_tasks'] as int? ?? 30,
      features: List<String>.from(data['features'] ?? []),
      isActive: data['is_active'] as bool? ?? true,
    );
  }
}
