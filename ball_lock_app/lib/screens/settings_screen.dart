import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = true;
  bool _location = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E6F6A), // ✅ 색상 통일
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("알림 설정"),
            value: _notification,
            activeColor: const Color(0xFF1E6F6A), // ✅ 스위치 활성 색상 통일
            onChanged: (val) => setState(() => _notification = val),
          ),
          SwitchListTile(
            title: const Text("위치 확인"),
            value: _location,
            activeColor: const Color(0xFF1E6F6A), // ✅ 스위치 활성 색상 통일
            onChanged: (val) => setState(() => _location = val),
          ),
          ListTile(
            title: const Text("언어"),
            trailing: const Text("KOR"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("온도"),
            trailing: const Text("C°"),
            onTap: () {},
          ),
          // ✅ 다크모드 Provider 연동
          SwitchListTile(
            title: const Text("다크 모드"),
            value: themeProvider.isDarkMode,
            activeColor: const Color(0xFF1E6F6A), // ✅ 스위치 색상 맞춤
            onChanged: (val) => themeProvider.toggleTheme(val),
          ),
          const Divider(),
          const ListTile(
            title: Text("현재 버전"),
            subtitle: Text(
              "현재 최신 버전입니다.\n버전 1.1.0",
              style: TextStyle(fontSize: 12),
            ),
          ),
          ListTile(
            title: const Text("로그아웃"),
            trailing: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              // TODO: 로그아웃 로직 추가
            },
          ),
        ],
      ),
    );
  }
}
