import 'package:flutter_test/flutter_test.dart';
import 'package:quotegenerator/main.dart';
import 'package:quotegenerator/screens/splash_screen.dart';

void main() {
  testWidgets('App splash screen render smoke test', (WidgetTester tester) async {
    // Build our app and trigger an initial frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the SplashScreen is rendered.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Advance the clock by 3.8 seconds to trigger the splash timer and transition
    await tester.pump(const Duration(milliseconds: 3800));
  });
}
