import '../entities/business.dart';

abstract class BusinessRepository {
  Future<Business> getBusinessById(String id);
  Future<List<Business>> getUserBusinesses(String userId);
  Future<Business> createBusiness(Business business);
  Future<void> updateBusiness(Business business);
  Future<void> deleteBusiness(String id);
}
