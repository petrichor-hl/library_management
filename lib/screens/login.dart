import 'package:flutter/material.dart';
import 'package:library_management/main.dart';
import 'package:library_management/screens/library_management.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isProcessing = false;

  Map<String, dynamic> accountToLogin = {};

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final enteredUsername = _usernameController.text;
    final enteredPassword = _passwordController.text;

    if (accountToLogin.isEmpty) {
      accountToLogin = await dbProcess.queryAccount();
      // print(accountToLogin);
    }

    if (enteredUsername == accountToLogin['username'] &&
        enteredPassword == accountToLogin['password']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const LibraryManagement(),
          ),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Đăng nhập thất bại. Tên đăng nhập hoặc mật khẩu không đúng',
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    setState(() {
      _isProcessing = false;
    });
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
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.4,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 51, 51),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xFFACACAC)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập Tên tài khoản';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                _PasswordTextField(passwordController: _passwordController),
                const SizedBox(
                  height: 12,
                ),
                _isProcessing
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 22),
                        ),
                        child: const Text(
                          'ĐĂNG NHẬP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ),
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
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 51, 51, 51),
        hintText: 'Mật khẩu',
        hintStyle: const TextStyle(color: Color(0xFFACACAC)),
        suffixIcon: widget.passwordController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isShowPassword = !_isShowPassword;
                  });
                },
                icon: _isShowPassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
        suffixIconColor: const Color(0xFFACACAC),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      ),
      obscureText: !_isShowPassword,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bạn chưa nhập Mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu gồm 6 ký tự trở lên.';
        }
        return null;
      },
      onChanged: (value) {
        if (value.isEmpty) {
          _isShowPassword = false;
        }
        if (value.length <= 1) setState(() {});
      },
    );
  }
}
