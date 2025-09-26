import 'package:flutter/material.dart';
import '../../models/stadium.dart';
import '../../models/category.dart';
import '../../data/dummy_data.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Stadium? selectedStadium;
  Category? selectedCategory;
  String? selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ 테마 불러오기

    return Scaffold(
      appBar: AppBar(
        title: const Text("검색"),
        backgroundColor: theme.colorScheme.primary,   // ✅ AppBar 색상 통일
        foregroundColor: theme.colorScheme.onPrimary, // ✅ 글씨/아이콘 흰색
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Stadium
            Text("야구장",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: dummyStadiums.map((stadium) {
                final isSelected = selectedStadium == stadium;
                return ChoiceChip(
                  label: Text(stadium.name),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primary, // ✅ 청록색
                  labelStyle: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.textTheme.bodyMedium?.color,
                  ),
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        selectedStadium = null;
                        selectedCategory = null;
                        selectedSubCategory = null;
                      } else {
                        selectedStadium = stadium;
                        selectedCategory = null;
                        selectedSubCategory = null;
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ⭐ Category
            if (selectedStadium != null) ...[
              Text("카테고리",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: selectedStadium!.categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary, // ✅ 청록색
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.textTheme.bodyMedium?.color,
                    ),
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedCategory = null;
                          selectedSubCategory = null;
                        } else {
                          selectedCategory = cat;
                          selectedSubCategory = null;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            // ⭐ SubCategory
            if (selectedCategory != null) ...[
              Text("세부 카테고리",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: selectedCategory!.subCategories.map((sub) {
                  final isSelected = selectedSubCategory == sub;
                  return ChoiceChip(
                    label: Text(sub),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary, // ✅ 청록색
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.textTheme.bodyMedium?.color,
                    ),
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedSubCategory = null;
                        } else {
                          selectedSubCategory = sub;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint(
                    "Stadium: ${selectedStadium?.name}, "
                        "Category: ${selectedCategory?.name}, "
                        "SubCategory: $selectedSubCategory",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,   // ✅ 청록색
                  foregroundColor: theme.colorScheme.onPrimary, // ✅ 흰 글씨
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("필터 적용"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
