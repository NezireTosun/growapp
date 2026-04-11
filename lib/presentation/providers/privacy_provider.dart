import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacySection {
  final String title;
  final String body;
  const PrivacySection({required this.title, required this.body});
}

class PrivacyProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _policyTitle = '';
  String _policyUpdated = '';
  List<PrivacySection> _sections = [];
  bool _isLoading = false;
  bool _loaded = false;

  String get policyTitle => _policyTitle;
  String get policyUpdated => _policyUpdated;
  List<PrivacySection> get sections => _sections;
  bool get isLoading => _isLoading;

  Future<void> load(String locale) async {
    if (_loaded) return;
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _db.collection('privacy_policy').doc('main').get();
      if (!doc.exists) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      final data = doc.data()!;
      _policyTitle = _loc(data['title'], locale);
      _policyUpdated = _loc(data['updated'], locale);

      final rawSections = data['sections'] as List<dynamic>? ?? [];
      _sections = rawSections.map((s) {
        final map = s as Map<String, dynamic>;
        return PrivacySection(
          title: _loc(map['title'], locale),
          body: _loc(map['body'], locale),
        );
      }).toList();

      _loaded = true;
    } catch (_) {
      // Firestore'a erişilemezse sessizce geç
    }

    _isLoading = false;
    notifyListeners();
  }

  String _loc(dynamic field, String locale) {
    if (field == null) return '';
    if (field is String) return field;
    if (field is Map) {
      return (field[locale] ?? field['en'] ?? field.values.firstOrNull ?? '').toString();
    }
    return field.toString();
  }
}
