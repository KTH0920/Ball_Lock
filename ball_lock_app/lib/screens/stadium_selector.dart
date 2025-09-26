import 'package:flutter/material.dart';

class SubCategorySelector extends StatelessWidget {
  final List<String> subCategories;
  final String? selectedSubCategory;
  final Function(String?) onSubCategorySelected;

  const SubCategorySelector({
    super.key,
    required this.subCategories,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: subCategories.map((subCategory) {
        final isSelected = selectedSubCategory == subCategory;
        return ChoiceChip(
          label: Text(
            subCategory,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary   // ✅ 선택 시 대비색
                  : theme.colorScheme.onSurface,  // ✅ 기본 텍스트 색
            ),
          ),
          selected: isSelected,
          selectedColor: theme.colorScheme.primary, // ✅ 테마의 메인컬러
          backgroundColor: theme.colorScheme.surfaceVariant, // ✅ 라이트/다크 모드 자동 대응
          onSelected: (_) {
            onSubCategorySelected(
              isSelected ? null : subCategory, // ✅ 다시 누르면 해제
            );
          },
        );
      }).toList(),
    );
  }
}
