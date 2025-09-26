import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ FirebaseAuth import
import 'profile_screen.dart';
import 'customer_center_screen.dart'; // ✅ 고객센터 화면 import

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser; // ✅ 현재 로그인된 유저 가져오기

    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // ✅ 상단 유저 카드 (프로필로 이동)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: const Border(
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      // ✅ FirebaseAuth에서 displayName 또는 email 표시
                      user?.displayName ?? user?.email ?? "게스트",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
          ),

          // ✅ 적립금, 쿠폰 등 카드
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn("적립금", "1000원"),
                _infoColumn("블람머니", "충전하기"),
                _infoColumn("쿠폰", "0장"),
              ],
            ),
          ),

          // ✅ 메뉴 리스트
          _menuTile("주문내역", onTap: () {
            // TODO: 주문내역 페이지 연결
          }),
          _menuTile("취소/환불 내역", onTap: () {
            // TODO: 환불내역 페이지 연결
          }),
          _menuTile("즐겨찾는 매장", onTap: () {
            // TODO: 즐겨찾기 페이지 연결
          }),
          _menuTile("고객센터", onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomerCenterScreen()),
            );
          }),
          _menuTile("출석체크", onTap: () {
            // TODO: 출석체크 페이지 연결
          }),
          _menuTile("이벤트", onTap: () {
            // TODO: 이벤트 페이지 연결
          }),
          _menuTile("설정", onTap: () {
            // TODO: 설정 페이지 연결
          }),
        ],
      ),
    );
  }

  /// ✅ 적립금/쿠폰 카드 내부 Column
  Widget _infoColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// ✅ 공통 메뉴 아이템
  Widget _menuTile(String title, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
