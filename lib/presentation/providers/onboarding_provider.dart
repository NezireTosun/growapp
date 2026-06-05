import 'package:flutter/foundation.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_type_option.dart';
import '../../domain/entities/onboarding_step.dart';
import '../../domain/entities/pain_point_option.dart';
import '../../domain/entities/survey_question.dart';
import '../../domain/repositories/business_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingProvider extends ChangeNotifier {
  final OnboardingRepository _repository;
  final BusinessRepository _businessRepository;

  OnboardingProvider(this._repository, this._businessRepository);

  // Onboarding steps
  List<OnboardingStep> _steps = [];
  int _currentStepIndex = 0;

  // Business name
  String _businessName = '';

  // Business type
  List<BusinessTypeOption> _businessTypes = [];
  int? _selectedBusinessTypeIndex;

  // Survey
  List<SurveyQuestion> _surveyQuestions = [];
  int _currentSurveyIndex = 0;
  final Map<String, String> _surveyAnswers = {};

  // Pain points
  List<PainPointOption> _painPoints = [];
  final Set<String> _selectedPainPointIds = {};

  // State
  bool _isLoading = false;
  String? _error;

  // Getters
  List<OnboardingStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  OnboardingStep? get currentStep =>
      _steps.isNotEmpty ? _steps[_currentStepIndex] : null;

  String get businessName => _businessName;

  List<BusinessTypeOption> get businessTypes => _businessTypes;
  int? get selectedBusinessTypeIndex => _selectedBusinessTypeIndex;
  BusinessTypeOption? get selectedBusinessType =>
      _selectedBusinessTypeIndex != null
          ? _businessTypes[_selectedBusinessTypeIndex!]
          : null;

  List<SurveyQuestion> get surveyQuestions => _surveyQuestions;
  int get currentSurveyIndex => _currentSurveyIndex;
  SurveyQuestion? get currentSurveyQuestion =>
      _surveyQuestions.isNotEmpty ? _surveyQuestions[_currentSurveyIndex] : null;
  Map<String, String> get surveyAnswers => _surveyAnswers;
  bool get isSurveyComplete =>
      _currentSurveyIndex >= _surveyQuestions.length - 1 &&
      _surveyAnswers.containsKey(_surveyQuestions.last.id);

  List<PainPointOption> get painPoints => _painPoints;
  Set<String> get selectedPainPointIds => _selectedPainPointIds;
  bool isPainPointSelected(String id) => _selectedPainPointIds.contains(id);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLastStep => _currentStepIndex >= _steps.length - 1;

  String _locale = 'tr';
  String get locale => _locale;

  /// Load onboarding steps + business types
  Future<void> initialize({String locale = 'tr'}) async {
    _locale = locale;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _steps = List.of(await _repository.getOnboardingSteps(locale: locale));
      _steps.sort((a, b) => a.order.compareTo(b.order));

      _businessTypes = List.of(await _repository.getBusinessTypes(locale: locale));
      _painPoints = List.of(await _repository.getPainPointOptions(locale: locale));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set business name and advance
  void setBusinessName(String name) {
    _businessName = name;
    notifyListeners();
  }

  /// Select business type, load survey questions, and advance
  Future<void> selectBusinessType(int index) async {
    _selectedBusinessTypeIndex = index;
    notifyListeners();

    final type = _businessTypes[index];
    _surveyQuestions = List.of(await _repository.getSurveyQuestions(type.id, locale: _locale));
    _surveyQuestions.sort((a, b) => a.order.compareTo(b.order));
    _currentSurveyIndex = 0;
    _surveyAnswers.clear();
  }

  /// Answer a survey question
  void answerSurveyQuestion(String questionId, String optionId) {
    _surveyAnswers[questionId] = optionId;
    notifyListeners();
  }

  /// Advance to next survey question. Returns true if survey is complete.
  bool nextSurveyQuestion() {
    if (_currentSurveyIndex < _surveyQuestions.length - 1) {
      _currentSurveyIndex++;
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Go back to previous survey question. Returns false if at first question.
  bool previousSurveyQuestion() {
    if (_currentSurveyIndex > 0) {
      _currentSurveyIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Get selected option index for a specific question
  int? getSelectedOptionIndex(String questionId) {
    final answerId = _surveyAnswers[questionId];
    if (answerId == null) return null;

    final question = _surveyQuestions.firstWhere((q) => q.id == questionId);
    return question.options.indexWhere((o) => o.id == answerId);
  }

  /// Advance to next onboarding step
  void nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  /// Go back to previous onboarding step
  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  /// Toggle a pain point selection (max 2)
  void togglePainPoint(String id) {
    if (_selectedPainPointIds.contains(id)) {
      _selectedPainPointIds.remove(id);
    } else if (_selectedPainPointIds.length < 2) {
      _selectedPainPointIds.add(id);
    }
    notifyListeners();
  }

  /// Survey cevaplarını API formatına dönüştür: {q1: 8, q2: 5, ...}
  Map<String, int> get apiAnswers {
    final sorted = List<SurveyQuestion>.from(_surveyQuestions)
      ..sort((a, b) => a.order.compareTo(b.order));

    final result = <String, int>{};
    for (var i = 0; i < sorted.length; i++) {
      final question = sorted[i];
      final selectedOptionId = _surveyAnswers[question.id];
      if (selectedOptionId == null) continue;

      final option = question.options.firstWhere(
        (o) => o.id == selectedOptionId,
        orElse: () => const SurveyOption(id: '', label: '', score: 5),
      );
      result['q${i + 1}'] = option.score;
    }
    return result;
  }

  /// business_type ID → API industry kodu
  static const _industryMap = <String, String>{
    '1': 'cafe',
    '2': 'rest',
    '3': 'ecommerce',
    '4': 'saas',
  };

  /// Seçilen business type'ın industry kodu (API için)
  String get industryCode => _industryMap[selectedBusinessType?.id] ?? selectedBusinessType?.id ?? 'rest';

  /// Save all answers and complete onboarding
  Future<void> completeOnboarding(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Create business in Firestore
      final business = await _businessRepository.createBusiness(Business(
        id: '',
        name: _businessName,
        ownerId: userId,
        sector: selectedBusinessType?.id,
        createdAt: DateTime.now(),
      )).timeout(const Duration(seconds: 12));

      // Pass question_id → option_id mapping for onboarding_responses
      // + API format answers for recommendations
      final answers = {
        'surveyAnswers': Map<String, String>.from(_surveyAnswers),
        'painPoints': _selectedPainPointIds.toList(),
        'apiAnswers': apiAnswers,
      };

      await _repository.saveOnboardingAnswers(answers, businessId: business.id, userId: userId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
