import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/main.dart';
import 'package:library_management/screens/library_management.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isProcessing = false;

  Map<String, dynamic> accountToLogin = {};

  String _errorText = '';

  void _submit() async {
    // check
    final enteredUsername = _usernameController.text;
    final enteredPassword = _passwordController.text;

    _errorText = '';
    if (enteredUsername.isEmpty) {
      _errorText = 'Bạn chưa điền Tên đăng nhập';
    } else if (enteredPassword.isEmpty) {
      _errorText = 'Bạn chưa nhập Mật khẩu';
    } else if (enteredPassword.length < 6) {
      _errorText = 'Mật khẩu có ít nhất 6 ký tự';
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    if (accountToLogin.isEmpty) {
      accountToLogin = await dbProcess.queryAccount();
      // print(accountToLogin);
    }

    if (enteredUsername == accountToLogin['username'] && enteredPassword == accountToLogin['password']) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            width: 300,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const LibraryManagement(),
            duration: const Duration(milliseconds: 300),
          ),
          (route) => false,
        );
      }
    } else {
      _errorText = 'Tên đăng nhập hoặc mật khẩu không đúng';

      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MoveWindow(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.85, 1],
                ),
              ),
              position: DecorationPosition.foreground,
              child: Image.asset(
                'assets/book-cover/background-login.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            surfaceTintColor: Colors.transparent,
            elevation: 12,
            child: Container(
              width: screenWidth * 0.35,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(50),
                  Image.asset(
                    'assets/logo/Asset_1.png',
                    width: 44,
                  ),
                  const Gap(12),
                  const Text(
                    'Chào mừng đến với Reader',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu sắc của border
                        width: 1, // Độ rộng của border
                      ),
                      borderRadius: BorderRadius.circular(10), // Bán kính của border
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tên đăng nhập',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _usernameController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'admin174',
                            hintStyle: TextStyle(color: Color(0xFFACACAC)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            isCollapsed: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),
                  _PasswordTextField(passwordController: _passwordController),
                  const Gap(4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: const Text('Quên mật khẩu'),
                    ),
                  ),
                  const Gap(14),
                  Text(
                    _errorText,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const Gap(16),
                  _isProcessing
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : OutlinedButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                            foregroundColor: Colors.black,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tiếp tục',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Gap(4),
                              Icon(Icons.login_rounded)
                            ],
                          ),
                        ),
                  const Gap(40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({required this.passwordController});
  final TextEditingController passwordController;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Màu sắc của border
          width: 1, // Độ rộng của border
        ),
        borderRadius: BorderRadius.circular(10), // Bán kính của border
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mật khẩu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              hintText: '••••••',
              hintStyle: const TextStyle(color: Color(0xFFACACAC)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              isCollapsed: true,
              suffixIcon: widget.passwordController.text.isEmpty
                  ? null
                  : InkWell(
                      onTap: () {
                        setState(() {
                          _isShowPassword = !_isShowPassword;
                        });
                      },
                      child: _isShowPassword
                          ? const Icon(
                              Icons.visibility_off,
                            )
                          : const Icon(
                              Icons.visibility,
                            ),
                    ),
              suffixIconColor: const Color(0xFFACACAC),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 28,
                minWidth: 28,
              ),
            ),
            obscureText: !_isShowPassword,
            onChanged: (value) {
              if (value.isEmpty) {
                _isShowPassword = false;
              }
              if (value.length <= 1) setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
