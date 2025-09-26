import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_edit_screen.dart';
import 'sign_in.dart';
import 'settings_screen.dart'; // ✅ 설정 화면 import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ 테마 불러오기
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          // ✅ 설정 아이콘
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          // ✅ 로그아웃 아이콘
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 상단 배경 + 아바타
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.onPrimary,
                child: Icon(Icons.person,
                    size: 55, color: theme.iconTheme.color),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 사용자 정보 카드
                _buildInfoCard(
                  theme: theme,
                  title: "사용자 정보",
                  children: [
                    _buildInfoRow(theme, Icons.person, "Name",
                        user?.displayName ?? "사용자"),
                    _buildInfoRow(theme, Icons.phone, "Phone no.",
                        "+82 010-0000-0000"),
                    _buildInfoRow(theme, Icons.email, "E-Mail",
                        user?.email ?? "이메일 없음"),
                    _buildInfoRow(
                        theme, Icons.payment, "Payment Method", "등록된 카드 없음"),
                  ],
                ),
                const SizedBox(height: 20),

                // 쿠폰함 카드
                _buildInfoCard(
                  theme: theme,
                  title: "내 쿠폰함",
                  children: [
                    _buildInfoRow(theme, Icons.card_giftcard, "보유 쿠폰", "3장"),
                    _buildInfoRow(theme, Icons.discount, "할인 혜택", "10% 할인 쿠폰"),
                  ],
                ),
              ],
            ),
          ),

          // 프로필 수정 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileEditScreen()),
                  );
                },
                child: Text(
                  "프로필 수정하기",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 18,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 공통 카드 위젯
  Widget _buildInfoCard({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// 공통 정보 행 위젯
  Widget _buildInfoRow(
      ThemeData theme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: theme.iconTheme.color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          )
        ],
      ),
    );
  }
}
