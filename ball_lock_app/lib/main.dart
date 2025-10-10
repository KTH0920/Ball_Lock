import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

Future<void> main() async {
  // ✅ Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase 무조건 정확히 한 번만 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ 앱 실행 (Firebase 초기화 이후)
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Locker',

      // ✅ 다크모드 테마 적용
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // ✅ FirebaseAuth 상태 확인 후 화면 분기
      home: FutureBuilder(
        // Firebase 초기화 완료 후 Auth 상태 확인
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 초기화 중 로딩 스피너
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Firebase 초기화 실패')),
            );
          }

          // ✅ 로그인 여부에 따라 화면 분기
          return FirebaseAuth.instance.currentUser == null
              ? const SplashScreen()
              : const HomeScreen();
        },
      ),
    );
  }
}
