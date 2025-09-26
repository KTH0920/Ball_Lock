import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("알림"),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "오늘",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          _buildNotification(theme, "푸드락커", "주문이 접수되었습니다.", "5분 전"),
          _buildNotification(theme, "푸드락커", "배달원이 출발했습니다.", "10분 전"),

          const SizedBox(height: 20),
          Text(
            "어제",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          _buildNotification(theme, "푸드락커", "주문이 완료되었습니다.", "1일 전"),
          _buildNotification(theme, "푸드락커", "리뷰 이벤트에 참여해보세요!", "1일 전"),
        ],
      ),
    );
  }

  Widget _buildNotification(
      ThemeData theme, String title, String message, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Icon(Icons.notifications, color: theme.colorScheme.onPrimary),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Text(
          time,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ),
    );
  }
}
