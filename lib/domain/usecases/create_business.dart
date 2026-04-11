import '../entities/business.dart';
import '../repositories/business_repository.dart';

class CreateBusiness {
  final BusinessRepository _repository;

  CreateBusiness(this._repository);

  Future<Business> call(Business business) {
    return _repository.createBusiness(business);
  }
}
