import 'package:flutter_test/flutter_test.dart';
import 'package:latres_124240180/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HarryPotterApp(isLoggedIn: false));
    expect(find.text('HARRY POTTER'), findsOneWidget);
  });
}
