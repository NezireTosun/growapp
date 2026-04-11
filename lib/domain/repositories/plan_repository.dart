import '../entities/plan.dart';

abstract class PlanRepository {
  Future<List<Plan>> getPlans();
  Future<Plan> getPlanById(String planId);
  Future<void> updateUserPlan(String userId, String planId);
}
