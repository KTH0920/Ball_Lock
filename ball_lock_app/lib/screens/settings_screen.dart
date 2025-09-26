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
    final theme = Theme.of(context); // ✅ 현재 테마 가져오기
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("알림 설정"),
            value: _notification,
            onChanged: (val) => setState(() => _notification = val),
          ),
          SwitchListTile(
            title: const Text("위치 확인"),
            value: _location,
            onChanged: (val) => setState(() => _location = val),
          ),
          ListTile(
            title: const Text("언어"),
            trailing: Text("KOR", style: theme.textTheme.bodyMedium),
            onTap: () {},
          ),
          ListTile(
            title: const Text("온도"),
            trailing: Text("C°", style: theme.textTheme.bodyMedium),
            onTap: () {},
          ),
          // ✅ 다크모드 Provider 연동
          SwitchListTile(
            title: const Text("다크 모드"),
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(val),
          ),
          const Divider(),
          ListTile(
            title: const Text("현재 버전"),
            subtitle: Text(
              "현재 최신 버전입니다.\n버전 1.1.0",
              style: theme.textTheme.bodySmall,
            ),
          ),
          ListTile(
            title: const Text("로그아웃"),
            trailing: Icon(Icons.logout, color: theme.colorScheme.error),
            onTap: () {
              // TODO: 로그아웃 로직 추가
            },
          ),
        ],
      ),
    );
  }
}
