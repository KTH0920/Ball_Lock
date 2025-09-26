import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart'; // 홈 화면 import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후 HomeScreen으로 이동
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary, // ✅ 테마의 메인 컬러 사용
      body: Center(
        child: Image.asset(
          "assets/images/food_locker_logo.png",
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
