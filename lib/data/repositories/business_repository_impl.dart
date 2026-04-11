import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/business.dart';
import '../../domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<Business> getBusinessById(String id) async {
    final doc = await _db.collection('businesses').doc(id).get();
    if (!doc.exists) throw Exception('Business not found');
    return _mapDoc(doc);
  }

  @override
  Future<List<Business>> getUserBusinesses(String userId) async {
    // Query top-level business_members collection by user_id
    final membersSnapshot = await _db
        .collection('business_members')
        .where('user_id', isEqualTo: userId)
        .where('is_active', isEqualTo: true)
        .get();

    if (membersSnapshot.docs.isEmpty) return [];

    final businessIds = membersSnapshot.docs
        .map((d) => d.data()['business_id'] as String)
        .toList();

    // Tüm business'ları paralel olarak çek (N+1 yerine parallel fetch)
    final bizDocs = await Future.wait(
      businessIds.map((id) => _db.collection('businesses').doc(id).get()),
    );

    return bizDocs
        .where((d) => d.exists && (d.data()?['is_active'] as bool? ?? true))
        .map(_mapDoc)
        .toList();
  }

  @override
  Future<Business> createBusiness(Business business) async {
    final docRef = await _db.collection('businesses').add({
      'name': business.name,
      'owner_id': business.ownerId,
      'sector': business.sector ?? '',
      'city': business.city ?? '',
      'instagram': business.instagram ?? '',
      'status': 'active',
      'is_active': true,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Add owner as member in top-level business_members collection
    await _db.collection('business_members').add({
      'business_id': docRef.id,
      'user_id': business.ownerId,
      'role': 'owner',
      'joined_at': FieldValue.serverTimestamp(),
      'is_active': true,
    });

    return Business(
      id: docRef.id,
      name: business.name,
      ownerId: business.ownerId,
      sector: business.sector,
      city: business.city,
      instagram: business.instagram,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> updateBusiness(Business business) async {
    await _db.collection('businesses').doc(business.id).update({
      'name': business.name,
      'sector': business.sector ?? '',
      'city': business.city ?? '',
      'instagram': business.instagram ?? '',
    });
  }

  @override
  Future<void> deleteBusiness(String id) async {
    await _db.collection('businesses').doc(id).update({
      'is_active': false,
    });
  }

  Business _mapDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final timestamp = data['created_at'] as Timestamp?;

    // Parse api_answers from Firestore (stored as {q1: 8, q2: 5, ...})
    final rawAnswers = data['api_answers'] as Map<String, dynamic>?;
    final apiAnswers = <String, int>{};
    if (rawAnswers != null) {
      for (final entry in rawAnswers.entries) {
        apiAnswers[entry.key] = (entry.value as num).toInt();
      }
    }

    return Business(
      id: doc.id,
      name: data['name'] as String? ?? '',
      ownerId: data['owner_id'] as String? ?? '',
      sector: data['sector'] as String?,
      city: data['city'] as String?,
      instagram: data['instagram'] as String?,
      status: data['status'] as String? ?? 'active',
      isActive: data['is_active'] as bool? ?? true,
      createdAt: timestamp?.toDate() ?? DateTime.now(),
      apiAnswers: apiAnswers,
    );
  }
}
