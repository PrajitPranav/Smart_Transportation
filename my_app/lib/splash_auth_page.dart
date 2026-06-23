import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'main.dart'; // Replace with your actual home screen file

class SplashAuthPage extends StatefulWidget {
  const SplashAuthPage({super.key});

  @override
  State<SplashAuthPage> createState() => _SplashAuthPageState();
}

class _SplashAuthPageState extends State<SplashAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  int _failCount = 0;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please scan your fingerprint to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        // 👇 If fingerprint is correct, go to Home screen
        Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const HomeScreen()),
);

      } else {
        _handleFailure();
      }
    } catch (e) {
      _handleFailure();
    }
  }

  void _handleFailure() {
    _failCount++;
    if (_failCount >= 3) {
      // 👇 After 3 wrong tries, go to Login screen
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const LoginPage()),
);

    } else {
      // 👇 Wait 1 second and try again
      Future.delayed(const Duration(seconds: 1), _authenticate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
