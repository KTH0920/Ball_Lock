import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final bool isSelected = selectedCategory == category;

        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          selectedColor: const Color(0xFF11AB69),
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? const Color(0xFF11AB69) : Colors.grey.shade400,
            ),
          ),
          // ChoiceChip의 onSelected 파라미터 활용!
          onSelected: (bool selected) {
            if (selected) {
              onCategorySelected(category); // 선택
            } else {
              onCategorySelected(null);     // 해제
            }
          },
        );
      }).toList(),
    );
  }
}
