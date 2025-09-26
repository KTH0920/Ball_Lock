import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ 테마 가져오기

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 리스트 아이템들 박스
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (_, __) =>
                  Divider(color: theme.dividerColor, thickness: 1),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3, // ✅ 그림자 추가
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
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
                    contentPadding: const EdgeInsets.all(12),
                  ),
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
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              filled: true,
              fillColor: theme.cardColor, // ✅ 배경 흰색 박스
            ),
          ),

          const SizedBox(height: 20),

          // Filter 버튼 (가운데 정렬)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }
}
