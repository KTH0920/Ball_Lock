import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // ✅ Provider 추가
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
<<<<<<< HEAD
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart'; // ✅ ThemeProvider import
=======
import 'screens/home_screen.dart';
import 'services/db_upload.dart'; // ✅ 우리가 만든 DB 업로드 파일
>>>>>>> kth

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

<<<<<<< HEAD
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
=======
  // ✅ DB 업로드 실행 (임시)
  await uploadSuwonData();

  runApp(const MyApp());
>>>>>>> kth
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Locker',

      // ✅ 테마 적용
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // ✅ 스플래시부터 시작
      home: const SplashScreen(),
    );
  }
}
