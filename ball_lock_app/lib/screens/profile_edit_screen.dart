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
    final theme = Theme.of(context); // ✅ 테마 불러오기

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("프로필 수정"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
              Positioned(
                bottom: 10,
                child: IconButton(
                  onPressed: () {
                    // TODO: 이미지 업로드 기능
                  },
                  icon: Icon(Icons.add_circle,
                      color: theme.iconTheme.color, size: 28),
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
                  theme: theme,
                  title: "사용자 정보 수정",
                  children: [
                    _buildTextField(theme, "Name", _nameController),
                    _buildTextField(theme, "Phone no.", _phoneController,
                        keyboardType: TextInputType.phone),
                    _buildTextField(theme, "E-Mail", _emailController,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true),
                    _buildTextField(theme, "Payment Method", _paymentController),
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
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("프로필이 저장되었습니다.")),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  "저장하기",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 블럭(Card) 스타일
  Widget _buildEditCard({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
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
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// 공통 텍스트필드
  Widget _buildTextField(
      ThemeData theme,
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor ??
              theme.colorScheme.surfaceVariant,
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
