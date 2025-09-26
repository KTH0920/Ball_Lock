import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
        backgroundColor: const Color(0xFF11AB69),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 프로필 수정 페이지로 이동
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
                decoration: const BoxDecoration(
                  color: Color(0xFF11AB69),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 55, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 사용자 정보 블럭
                _buildInfoCard(
                  title: "사용자 정보",
                  children: [
                    _buildInfoRow(Icons.person, "Name", user?.displayName ?? "사용자"),
                    _buildInfoRow(Icons.phone, "Phone no.", "+82 010-0000-0000"),
                    _buildInfoRow(Icons.email, "E-Mail", user?.email ?? "이메일 없음"),
                    _buildInfoRow(Icons.payment, "Payment Method", "등록된 카드 없음"),
                  ],
                ),
                const SizedBox(height: 20),

                // 쿠폰함 블럭
                _buildInfoCard(
                  title: "내 쿠폰함",
                  children: [
                    _buildInfoRow(Icons.card_giftcard, "보유 쿠폰", "3장"),
                    _buildInfoRow(Icons.discount, "할인 혜택", "10% 할인 쿠폰"),
                  ],
                ),
              ],
            ),
          ),

          // 수정 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11AB69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: 프로필 수정 페이지로 이동
                },
                child: const Text(
                  "프로필 수정하기",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 정보 카드 (블럭 스타일)
  Widget _buildInfoCard({required String title, required List<Widget> children}) {
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
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// 한 줄 정보
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(fontSize: 15, color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
