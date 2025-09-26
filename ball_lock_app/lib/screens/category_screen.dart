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
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Stadium
            const Text("Stadium", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: dummyStadiums.map((stadium) {
                final isSelected = selectedStadium == stadium;
                return ChoiceChip(
                  label: Text(stadium.name),
                  selected: isSelected,
                  selectedColor: const Color(0xFF11AB69),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) {
                    setState(() {
                      // ✅ 같은 걸 다시 누르면 해제
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
              const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: selectedStadium!.categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    selectedColor: const Color(0xFF11AB69),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() {
                        // ✅ 같은 걸 다시 누르면 해제
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
              const Text("SubCategory", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: selectedCategory!.subCategories.map((sub) {
                  final isSelected = selectedSubCategory == sub;
                  return ChoiceChip(
                    label: Text(sub),
                    selected: isSelected,
                    selectedColor: const Color(0xFF11AB69),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() {
                        // ✅ 같은 걸 다시 누르면 해제
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
            ElevatedButton(
              onPressed: () {
                debugPrint(
                  "Stadium: ${selectedStadium?.name}, "
                      "Category: ${selectedCategory?.name}, "
                      "SubCategory: $selectedSubCategory",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF11AB69),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Filter", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
