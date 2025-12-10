import 'package:aplikasi_produk/pages/login_page.dart';
import 'package:aplikasi_produk/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLogin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final isLoggedIn = snapshot.data!;

        return isLoggedIn ? HomePage() : LoginPage();
      },
    );
  }
}
