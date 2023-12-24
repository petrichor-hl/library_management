import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management/screens/auth/login_view.dart';

void main() {
  group('LoginView Widget Tests', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginView(onQuenMatKhauButtonClick: () {})));
      
      expect(find.text('Chào mừng đến với Reader'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Username and Password fields
    });
  
    // Add more tests here
  });
}
