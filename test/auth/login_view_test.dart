import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management/components/password_text_field.dart';
import 'package:library_management/screens/auth/login_view.dart';

void main() {
  // Create a mock function for the onQuenMatKhauButtonClick callback
  void mockCallback() {}

  testWidgets('LoginView builds correctly', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginView(onQuenMatKhauButtonClick: () {})));

  expect(find.byType(LoginView), findsOneWidget);
  expect(find.text('Chào mừng đến với Reader'), findsOneWidget);
  expect(find.byType(TextField), findsWidgets);
  expect(find.byType(OutlinedButton), findsOneWidget);
  });
  testWidgets('Displays error message for empty username', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginView(onQuenMatKhauButtonClick: () {})));

    await tester.enterText(find.byType(TextField).first, '');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();

    expect(find.text('Bạn chưa điền Tên đăng nhập'), findsOneWidget);
  });


}
