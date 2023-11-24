import 'package:flutter_test/flutter_test.dart';
import 'package:library_management/main.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is present.
    expect(find.text('Quản lý thư viện'), findsOneWidget);

    // You can add more test cases based on your app's behavior.
  });

  // Add more tests as needed.
}
