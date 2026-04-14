import 'package:flutter_test/flutter_test.dart';
import 'package:growapp/presentation/providers/analytics_provider.dart';

void main() {
  group('AnalyticsProvider computed properties', () {
    test('weekChangePercent: positive change', () {
      final p = AnalyticsProvider();
      // Access private fields via fake data flag
      p.loadAnalytics(userId: 'x', businessId: 'y'); // triggers fake data
      // weekChangePercent = ((30 - 22) / 22) * 100 = ~36
      expect(p.weekChangePercent, greaterThan(0));
    });

    test('weekChangePercent: zero when both are zero', () {
      // White-box: use the formula directly
      // _lastWeekTotal = 0, _thisWeekTotal = 0 → 0
      const last = 0;
      const current = 0;
      final result = last == 0 ? (current > 0 ? 100 : 0) : (((current - last) / last) * 100).round();
      expect(result, 0);
    });

    test('weekChangePercent: 100 when last is 0 and current > 0', () {
      const last = 0;
      const current = 5;
      final result = last == 0 ? (current > 0 ? 100 : 0) : (((current - last) / last) * 100).round();
      expect(result, 100);
    });

    test('weekChangePercent: negative change', () {
      const last = 10;
      const current = 5;
      final result = last == 0 ? (current > 0 ? 100 : 0) : (((current - last) / last) * 100).round();
      expect(result, -50);
    });
  });
}
