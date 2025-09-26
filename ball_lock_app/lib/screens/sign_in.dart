import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up.dart'; // 회원가입 화면
import 'home_screen.dart'; // 로그인 성공 후 이동할 메인 화면

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final pw = _password.text;

    if (email.isEmpty || pw.isEmpty) {
      _showSnack('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      setState(() => _loading = true);

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pw)
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } on TimeoutException {
      _showSnack('네트워크가 지연되고 있어요. 잠시 후 다시 시도해주세요.');
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          msg = '이메일 혹은 비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          msg = '잘못된 이메일 형식입니다.';
          break;
        case 'user-disabled':
          msg = '비활성화된 계정입니다.';
          break;
        case 'too-many-requests':
          msg = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
          break;
        default:
          msg = '로그인 실패: ${e.code}';
      }
      _showSnack(msg);
    } catch (e) {
      _showSnack('오류 발생: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  OutlineInputBorder _inputBorder(BuildContext context, {bool isFocused = false}) {
    final theme = Theme.of(context);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: isFocused ? theme.colorScheme.primary : Colors.transparent,
        width: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ✅ 배경색 테마 적용
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
                  Expanded(
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: theme.textTheme.headlineSmall?.copyWith(
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
                    const SizedBox(height: 8),
                    _LabeledField(
                      controller: _email,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant, // ✅ 테마 적용
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        border: _inputBorder(context),
                        enabledBorder: _inputBorder(context),
                        focusedBorder: _inputBorder(context, isFocused: true),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: theme.colorScheme.secondary,
                        ),
                        onPressed: () {
                          // TODO: 비밀번호 재설정 화면으로 이동
                        },
                        child: const Text('Forgot your password?'),
                      ),
                    ),
                    const SizedBox(height: 8),

                    const _OrDivider(labelTop: 'OR', labelBottom: 'Sign In using'),
                    const SizedBox(height: 8),

                    const _SocialRow(),

                    const SizedBox(height: 20),
                    _PrimaryButton(
                      label: _loading ? 'Signing In...' : 'Sign In',
                      onPressed: _loading ? null : _signIn,
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          final created = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUpPage()),
                          );
                          if (created == true && context.mounted) {
                            _showSnack('회원가입이 완료되었습니다. 로그인해주세요.');
                          }
                        },
                        child: Text(
                          'Need An Account?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
}

class _LabeledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const _LabeledField({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant, // ✅ 입력 배경 테마 적용
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: _border(context),
        enabledBorder: _border(context),
        focusedBorder: _border(context, isFocused: true),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context, {bool isFocused = false}) {
    final theme = Theme.of(context);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: isFocused ? theme.colorScheme.primary : Colors.transparent,
        width: 1.2,
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  final String labelTop;
  final String labelBottom;
  const _OrDivider({required this.labelTop, required this.labelBottom});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grey = theme.dividerColor;

    return Column(
      children: [
        const SizedBox(height: 6),
        Text(labelTop, style: theme.textTheme.bodySmall?.copyWith(color: grey)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Divider(color: grey)),
            const SizedBox(width: 12),
            Text(
              labelBottom,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: grey)),
          ],
        ),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _CircleBrand(label: 'N', bg: Color(0xFF03C75A)), // Naver
        SizedBox(width: 18),
        _CircleBrand(label: 'G', bg: Colors.white, border: true), // Google
        SizedBox(width: 18),
        _CircleBrand(label: 'K', bg: Color(0xFFFFE812), textColor: Colors.black), // Kakao
      ],
    );
  }
}

class _CircleBrand extends StatelessWidget {
  final String label;
  final Color bg;
  final bool border;
  final Color textColor;
  const _CircleBrand({
    required this.label,
    required this.bg,
    this.border = false,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {}, // TODO: 소셜 로그인 연결
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

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // ✅ 테마 적용
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
