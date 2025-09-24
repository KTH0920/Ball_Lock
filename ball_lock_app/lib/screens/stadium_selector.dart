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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: subCategories.map((subCategory) {
        final isSelected = selectedSubCategory == subCategory;
        return ChoiceChip(
          label: Text(subCategory),
          selected: isSelected,
          selectedColor: const Color(0xFF11AB69),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
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
