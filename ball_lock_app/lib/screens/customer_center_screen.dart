import 'package:flutter/material.dart';
import 'inquiry_screen.dart'; // ✅ 문의하기 화면 import

class CustomerCenterScreen extends StatelessWidget {
  const CustomerCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("고객센터"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "무엇을 도와드릴까요?",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 메뉴 리스트
            _buildMenuItem(context, "문의하기", const InquiryScreen()), // ✅ 문의하기 연결
            _buildMenuItem(context, "답변보기", null),
            _buildMenuItem(context, "전화상담", null),
            _buildMenuItem(context, "버그 신고", null),
            _buildMenuItem(context, "약관 및 정책", null),
          ],
        ),
      ),
    );
  }

  /// ✅ 공통 메뉴 아이템
  Widget _buildMenuItem(BuildContext context, String title, Widget? page) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: theme.textTheme.bodyLarge,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: page != null
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          }
              : null, // 아직 연결 안된 메뉴는 null
        ),
        Divider(height: 1, color: theme.dividerColor),
      ],
    );
  }
}
