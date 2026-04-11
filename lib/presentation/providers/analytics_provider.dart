import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryStat {
  final String categoryId;
  final int count;
  final double percent;

  const CategoryStat({
    required this.categoryId,
    required this.count,
    required this.percent,
  });
}

class AnalyticsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Demo mode flag – set to true to use fake data without Firebase
  static const bool _useFakeData = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Streak
  int _streakDays = 0;
  int get streakDays => _streakDays;

  int _completedToday = 0;
  int get completedToday => _completedToday;

  // Weekly performance
  List<int> _thisWeekDaily = List.filled(7, 0); // Mon-Sun
  List<int> get thisWeekDaily => _thisWeekDaily;

  int _thisWeekTotal = 0;
  int get thisWeekTotal => _thisWeekTotal;

  int _lastWeekTotal = 0;
  int get lastWeekTotal => _lastWeekTotal;

  int get weekChangePercent {
    if (_lastWeekTotal == 0) return _thisWeekTotal > 0 ? 100 : 0;
    return (((_thisWeekTotal - _lastWeekTotal) / _lastWeekTotal) * 100).round();
  }

  // Category distribution
  List<CategoryStat> _categories = [];
  List<CategoryStat> get categories => _categories;

  // Monthly performance (current month, day-by-day)
  List<int> _thisMonthDaily = [];
  List<int> get thisMonthDaily => _thisMonthDaily;
  int _thisMonthTotal = 0;
  int get thisMonthTotal => _thisMonthTotal;
  int _lastMonthTotal = 0;
  int get lastMonthTotal => _lastMonthTotal;
  int get monthChangePercent {
    if (_lastMonthTotal == 0) return _thisMonthTotal > 0 ? 100 : 0;
    return (((_thisMonthTotal - _lastMonthTotal) / _lastMonthTotal) * 100).round();
  }

  // Yearly performance (12 months)
  List<int> _thisYearMonthly = List.filled(12, 0);
  List<int> get thisYearMonthly => _thisYearMonthly;
  int _thisYearTotal = 0;
  int get thisYearTotal => _thisYearTotal;
  int _lastYearTotal = 0;
  int get lastYearTotal => _lastYearTotal;
  int get yearChangePercent {
    if (_lastYearTotal == 0) return _thisYearTotal > 0 ? 100 : 0;
    return (((_thisYearTotal - _lastYearTotal) / _lastYearTotal) * 100).round();
  }

  String? _userId;
  String? _businessId;

  String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> loadAnalytics({
    required String userId,
    required String businessId,
  }) async {
    if (_isLoading) return; // Zaten yükleniyorsa ikinci isteği engelle
    _userId = userId;
    _businessId = businessId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_useFakeData) {
        _loadFakeData();
      } else {
        // Fetch all relevant assignments in 2 batch queries instead of N individual reads
        final allDocs = await _fetchAllAssignments();
        _computeStreak(allDocs);
        _computeWeeklyPerformance(allDocs);
        _computeMonthlyPerformance(allDocs);
        _computeYearlyPerformance(allDocs);
        await _loadCategoryDistribution(allDocs);
      }
    } catch (e) {
      debugPrint('[AnalyticsProvider] Error: $e');
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
        _errorMessage = 'network_error';
      } else {
        _errorMessage = 'generic_error';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetches all daily_assignment docs for this user+business in a single query.
  /// Returns a map of dateStr -> completed count / tasks list.
  Future<Map<String, Map<String, dynamic>>> _fetchAllAssignments() async {
    final now = DateTime.now();
    // Query prefix: userId_businessId_ to get all docs for this business
    final prefix = '${_userId}_${_businessId}_';
    // We need last ~400 days for yearly+streak coverage
    final startDate = now.subtract(const Duration(days: 400));
    final startDocId = '$prefix${_dateStr(startDate)}';
    final endDocId = '$prefix${_dateStr(now)}~'; // ~ sorts after digits

    debugPrint('[Analytics] fetching assignments prefix=$prefix from=$startDocId to=$endDocId');

    final snapshot = await _db
        .collection('daily_assignments')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: startDocId)
        .where(FieldPath.documentId, isLessThanOrEqualTo: endDocId)
        .get();

    debugPrint('[Analytics] fetched ${snapshot.docs.length} assignment docs');

    final result = <String, Map<String, dynamic>>{};
    for (final doc in snapshot.docs) {
      // doc.id format: userId_businessId_YYYY-MM-DD
      final parts = doc.id.split('_');
      if (parts.length >= 3) {
        // date is last part
        final dateStr = parts.last;
        result[dateStr] = doc.data();
      }
    }
    return result;
  }

  int _countCompletedInDoc(Map<String, dynamic>? data) {
    if (data == null) return 0;
    final tasks = List<Map<String, dynamic>>.from(data['tasks'] ?? []);
    return tasks.where((t) => t['status'] == 'completed').length;
  }

  void _computeStreak(Map<String, Map<String, dynamic>> docs) {
    final now = DateTime.now();
    int streak = 0;
    _completedToday = _countCompletedInDoc(docs[_dateStr(now)]);

    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final completed = _countCompletedInDoc(docs[_dateStr(date)]);
      if (completed > 0) {
        streak++;
      } else {
        if (i == 0) continue; // today may have 0 — don't break streak
        break;
      }
    }
    _streakDays = streak;
  }

  void _computeWeeklyPerformance(Map<String, Map<String, dynamic>> docs) {
    final now = DateTime.now();
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));

    _thisWeekDaily = List.filled(7, 0);
    _thisWeekTotal = 0;

    for (int i = 0; i < 7; i++) {
      final date = thisMonday.add(Duration(days: i));
      if (date.isAfter(now)) break;
      final completed = _countCompletedInDoc(docs[_dateStr(date)]);
      _thisWeekDaily[i] = completed;
      _thisWeekTotal += completed;
    }

    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    _lastWeekTotal = 0;
    for (int i = 0; i < 7; i++) {
      final date = lastMonday.add(Duration(days: i));
      _lastWeekTotal += _countCompletedInDoc(docs[_dateStr(date)]);
    }
  }

  void _computeMonthlyPerformance(Map<String, Map<String, dynamic>> docs) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    _thisMonthDaily = List.filled(daysInMonth, 0);
    _thisMonthTotal = 0;

    for (int d = 1; d <= now.day; d++) {
      final date = DateTime(now.year, now.month, d);
      final completed = _countCompletedInDoc(docs[_dateStr(date)]);
      _thisMonthDaily[d - 1] = completed;
      _thisMonthTotal += completed;
    }

    final lastMonthDate = DateTime(now.year, now.month - 1, 1);
    final daysInLastMonth =
        DateTime(lastMonthDate.year, lastMonthDate.month + 1, 0).day;
    _lastMonthTotal = 0;
    for (int d = 1; d <= daysInLastMonth; d++) {
      final date = DateTime(lastMonthDate.year, lastMonthDate.month, d);
      _lastMonthTotal += _countCompletedInDoc(docs[_dateStr(date)]);
    }
  }

  void _computeYearlyPerformance(Map<String, Map<String, dynamic>> docs) {
    final now = DateTime.now();
    _thisYearMonthly = List.filled(12, 0);
    _thisYearTotal = 0;

    for (int m = 1; m <= now.month; m++) {
      final daysInMonth = DateTime(now.year, m + 1, 0).day;
      int monthTotal = 0;
      for (int d = 1; d <= daysInMonth; d++) {
        final date = DateTime(now.year, m, d);
        if (date.isAfter(now)) break;
        monthTotal += _countCompletedInDoc(docs[_dateStr(date)]);
      }
      _thisYearMonthly[m - 1] = monthTotal;
      _thisYearTotal += monthTotal;
    }

    _lastYearTotal = 0;
    for (int m = 1; m <= 12; m++) {
      final daysInMonth = DateTime(now.year - 1, m + 1, 0).day;
      for (int d = 1; d <= daysInMonth; d++) {
        final date = DateTime(now.year - 1, m, d);
        _lastYearTotal += _countCompletedInDoc(docs[_dateStr(date)]);
      }
    }
  }

  Future<void> _loadCategoryDistribution(
      Map<String, Map<String, dynamic>> docs) async {
    final now = DateTime.now();
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));

    // Tamamlanan görevlerin numeric ID'lerini topla ("cafe_124" → 124, "124" → 124)
    final completedNumericIds = <int>{};
    for (int i = 0; i < 7; i++) {
      final date = thisMonday.add(Duration(days: i));
      if (date.isAfter(now)) break;
      final doc = docs[_dateStr(date)];
      if (doc == null) continue;
      final tasks = List<Map<String, dynamic>>.from(doc['tasks'] ?? []);
      for (final t in tasks) {
        if (t['status'] == 'completed') {
          final rawId = t['task_id'].toString();
          final numericId = int.tryParse(RegExp(r'\d+').firstMatch(rawId)?.group(0) ?? '');
          if (numericId != null) completedNumericIds.add(numericId);
        }
      }
    }

    debugPrint('[Analytics] completedTaskIds=$completedNumericIds');

    if (completedNumericIds.isEmpty) {
      _categories = [];
      return;
    }

    // Firestore tasks collection'unda task_id field'ı int — batch query
    final categoryCounts = <String, int>{};
    final idList = completedNumericIds.toList();
    for (int i = 0; i < idList.length; i += 10) {
      final batch = idList.sublist(i, (i + 10).clamp(0, idList.length));
      final snapshot = await _db
          .collection('tasks')
          .where('task_id', whereIn: batch)
          .get();
      debugPrint('[Analytics] tasks query batch=$batch found=${snapshot.docs.length}');
      for (final doc in snapshot.docs) {
        final cat = doc.data()['category'] as String? ??
            doc.data()['category_id'] as String? ??
            doc.data()['main_category'] as String? ??
            'other';
        categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
      }
    }

    final total = categoryCounts.values.fold<int>(0, (a, b) => a + b);
    _categories = categoryCounts.entries.map((e) {
      return CategoryStat(
        categoryId: e.key,
        count: e.value,
        percent: total > 0 ? e.value / total : 0,
      );
    }).toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }

  void _loadFakeData() {
    _streakDays = 30;
    _completedToday = 4;

    _thisWeekDaily = [5, 4, 6, 3, 4, 5, 3];
    _thisWeekTotal = _thisWeekDaily.fold(0, (a, b) => a + b);
    _lastWeekTotal = 22;

    _thisMonthDaily = List.generate(30, (i) => i % 3 == 0 ? 3 : i % 3 == 1 ? 2 : 1);
    _thisMonthTotal = _thisMonthDaily.fold(0, (a, b) => a + b);
    _lastMonthTotal = 58;

    _thisYearMonthly = [18, 22, 25, 30, 28, 35, 32, 29, 27, 30, 0, 0];
    _thisYearTotal = _thisYearMonthly.fold(0, (a, b) => a + b);
    _lastYearTotal = 210;

    const total = 30;
    _categories = [
      CategoryStat(categoryId: 'acquisition', count: 8, percent: 8 / total),
      CategoryStat(categoryId: 'conversion', count: 6, percent: 6 / total),
      CategoryStat(categoryId: 'retention', count: 5, percent: 5 / total),
      CategoryStat(categoryId: 'social_proof', count: 4, percent: 4 / total),
      CategoryStat(categoryId: 'profitability', count: 4, percent: 4 / total),
      CategoryStat(categoryId: 'experience', count: 3, percent: 3 / total),
    ];
  }
}
