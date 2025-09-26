// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Locker',
      theme: ThemeData(primarySwatch: Colors.green),

      // ✅ 로그인 여부에 따라 첫 화면 분기
      home: FirebaseAuth.instance.currentUser == null
          ? const SplashScreen()   // 로그인 안 되어 있으면 스플래시 (→ 로그인)
          : const HomeScreen(),    // 로그인 되어 있으면 메인화면
    );
  }
}
