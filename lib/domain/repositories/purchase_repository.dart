/// Satın alma servisinin auth tarafında kullanılan arayüzü.
/// AuthProvider bu soyutlamaya bağımlıdır; concrete PurchaseService'e değil (DIP).
abstract class PurchaseRepository {
  Future<void> logout();
}
