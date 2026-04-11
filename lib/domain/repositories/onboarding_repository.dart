import '../entities/business_type_option.dart';
import '../entities/onboarding_step.dart';
import '../entities/pain_point_option.dart';
import '../entities/survey_question.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingStep>> getOnboardingSteps({String locale = 'tr'});
  Future<List<BusinessTypeOption>> getBusinessTypes({String locale = 'tr'});
  Future<List<SurveyQuestion>> getSurveyQuestions(String businessType, {String locale = 'tr'});
  Future<List<PainPointOption>> getPainPointOptions({String locale = 'tr'});
  Future<void> saveOnboardingAnswers(Map<String, dynamic> answers, {String? businessId, String? userId});
}
