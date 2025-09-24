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
    return Scaffold(
      backgroundColor: const Color(0xFF1D6E69), // ✅ 배경색을 로고 배경색(#1D6E69)으로 통일
      body: Center(
        child: Image.asset(
          "assets/images/food_locker_logo.png",
          fit: BoxFit.contain, // 비율 유지
          width: MediaQuery.of(context).size.width * 0.9, // 화면 90% 차지
        ),
      ),
    );
  }
}
