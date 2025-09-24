import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscurePw = true;
  bool _obscureCf = true;
  bool _marketing = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  OutlineInputBorder _border({bool isFocused = false}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: isFocused ? const Color(0xFF6DB06C) : Colors.transparent,
      width: 1.2,
    ),
  );

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _createAccount() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pw = _password.text;
    final cf = _confirm.text;

    if (name.isEmpty || email.isEmpty || pw.isEmpty || cf.isEmpty) {
      _showError('모든 필드를 입력해주세요.');
      return;
    }
    if (pw.length < 6) {
      _showError('비밀번호는 최소 6자 이상이어야 합니다.');
      return;
    }
    if (pw != cf) {
      _showError('비밀번호가 일치하지 않습니다.');
      return;
    }

    try {
      setState(() => _loading = true);

      // 1) Auth
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pw)
          .timeout(const Duration(seconds: 20));

      // 2) Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'uid': cred.user!.uid,
        'name': name,
        'email': email,
        'marketing': _marketing,
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 20));

      // 로그인 화면으로 되돌리려면 로그아웃
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해주세요.')),
      );
      Navigator.pop(context, true); // SignInPage로 복귀(성공 신호 true)

    } on TimeoutException {
      _showError('네트워크가 지연되고 있어요. 잠시 후 다시 시도해주세요.');
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          msg = '잘못된 이메일 형식입니다.';
          break;
        case 'weak-password':
          msg = '비밀번호가 너무 약합니다.';
          break;
        default:
          msg = '회원가입 실패: ${e.code}';
      }
      _showError(msg);
    } on FirebaseException catch (e) {
      _showError('데이터 저장 실패: ${e.message ?? e.code}');
    } catch (e) {
      _showError('오류 발생: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 AppBar 스타일
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _filledField(controller: _name, hint: 'Name'),
                    const SizedBox(height: 14),
                    _filledField(
                      controller: _email,
                      hint: 'Email Id or Username',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    // 비밀번호
                    TextField(
                      controller: _password,
                      obscureText: _obscurePw,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        border: _border(),
                        enabledBorder: _border(),
                        focusedBorder: _border(isFocused: true),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePw
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                          onPressed: () => setState(() => _obscurePw = !_obscurePw),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 비밀번호 확인
                    TextField(
                      controller: _confirm,
                      obscureText: _obscureCf,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        border: _border(),
                        enabledBorder: _border(),
                        focusedBorder: _border(isFocused: true),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureCf
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                          onPressed: () => setState(() => _obscureCf = !_obscureCf),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 마케팅 동의
                    Row(
                      children: [
                        Checkbox(
                          value: _marketing,
                          activeColor: const Color(0xFF6DB06C),
                          onChanged: (v) => setState(() => _marketing = v ?? false),
                        ),
                        const Expanded(
                          child: Text(
                            'Yes, I want to receive discounts, loyalty offers\nand other updates.',
                            style: TextStyle(height: 1.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    const OrDivider(labelTop: 'OR', labelBottom: 'Sign Up using'),
                    const SizedBox(height: 8),
                    const SocialRow(),

                    const SizedBox(height: 22),
                    PrimaryButton(
                      label: _loading ? 'Creating...' : 'Create Account',
                      onPressed: _loading ? null : _createAccount,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filledField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(isFocused: true),
      ),
    );
  }
}

// ===== 재사용 위젯 =====

class OrDivider extends StatelessWidget {
  final String labelTop;
  final String labelBottom;
  const OrDivider({super.key, required this.labelTop, required this.labelBottom});

  @override
  Widget build(BuildContext context) {
    final grey = Colors.grey.shade400;
    return Column(
      children: [
        const SizedBox(height: 6),
        Text(labelTop, style: TextStyle(color: grey)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Divider(color: grey)),
            const SizedBox(width: 12),
            Text(
              labelBottom,
              style: TextStyle(color: Colors.grey.shade600, letterSpacing: 0.2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: grey)),
          ],
        ),
      ],
    );
  }
}

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleBrand(label: 'N', bg: Color(0xFF03C75A)), // Naver
        SizedBox(width: 18),
        CircleBrand(label: 'G', bg: Colors.white, border: true), // Google
        SizedBox(width: 18),
        CircleBrand(label: 'K', bg: Color(0xFFFFE812), textColor: Colors.black), // Kakao
      ],
    );
  }
}

class CircleBrand extends StatelessWidget {
  final String label;
  final Color bg;
  final bool border;
  final Color textColor;
  const CircleBrand({
    super.key,
    required this.label,
    required this.bg,
    this.border = false,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {},
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: border ? Border.all(color: Colors.grey.shade300, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6DB06C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
