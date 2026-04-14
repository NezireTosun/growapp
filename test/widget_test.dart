import 'package:flutter_test/flutter_test.dart';
import 'package:growapp/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GrowApp());
    await tester.pumpAndSettle();
    expect(find.text('Your Business Name'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
