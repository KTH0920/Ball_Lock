import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ 테마 가져오기

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor, // ✅ 카드 배경
          border: Border.all(color: theme.dividerColor), // ✅ 테마 경계선
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 리스트 아이템
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant, // ✅ 이미지 자리
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    title: Text(
                      "1x item",
                      style: theme.textTheme.bodyMedium,
                    ),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Notes 입력창
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "메모",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "주문 관련 메모를 입력하세요",
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filter 버튼 (가운데 정렬)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "필터 적용",
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
