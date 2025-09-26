import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nameController =
  TextEditingController(text: "사용자");
  final TextEditingController _phoneController =
  TextEditingController(text: "+82 010-0000-0000");
  final TextEditingController _emailController =
  TextEditingController(text: "user@example.com");
  final TextEditingController _paymentController =
  TextEditingController(text: "카드 없음");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // ✅ 프로필 화면과 동일한 회색 배경
      appBar: AppBar(
        title: const Text("프로필 수정"),
        backgroundColor: const Color(0xFF11AB69),
        elevation: 0,
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
              Positioned(
                bottom: 10,
                child: IconButton(
                  onPressed: () {
                    // TODO: 이미지 업로드 기능
                  },
                  icon: const Icon(Icons.add_circle,
                      color: Colors.black54, size: 28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ✅ 사용자 정보 수정 블럭
                _buildEditCard(
                  title: "사용자 정보 수정",
                  children: [
                    _buildTextField("Name", _nameController),
                    _buildTextField("Phone no.", _phoneController,
                        keyboardType: TextInputType.phone),
                    _buildTextField("E-Mail", _emailController,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true),
                    _buildTextField("Payment Method", _paymentController),
                  ],
                ),
              ],
            ),
          ),

          // 저장 버튼
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
                  // TODO: Firebase/DB 저장 로직
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("프로필이 저장되었습니다.")),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "저장하기",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 블럭(Card) 스타일
  Widget _buildEditCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
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

  /// 공통 텍스트필드
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
        bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }
}
