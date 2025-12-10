import 'package:aplikasi_produk/pages/home_page.dart';
import 'package:aplikasi_produk/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login method
  void login() async {
    if (_emailController.text == 'test@example.com' &&
        _passwordController.text == '12345678') {
      // save to shared preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // clear controller
      _emailController.clear();
      _passwordController.clear();

      if (!mounted) return;

      // show snackbar
      showSnackbar(context, 'Login berhasil');

      // navigate to home page
      Navigator.push(context, HomePage.route());
    } else {
      showSnackbar(context, 'Email atau password salah');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo
                    Text(
                      'Aplikasi Produk',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // email textfield
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),

                    SizedBox(height: 20),

                    // password textfield
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),

                    SizedBox(height: 20),

                    // login button
                    ElevatedButton(onPressed: login, child: Text('Login')),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
