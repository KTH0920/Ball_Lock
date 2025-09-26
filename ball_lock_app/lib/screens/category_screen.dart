import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedStadium;
  String? selectedCategory;
  String? selectedBrand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Stadium 선택
            const Text("Stadium", style: TextStyle(fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stadiums').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final stadiums = snapshot.data!.docs;
                return Wrap(
                  spacing: 10,
                  children: stadiums.map((doc) {
                    final name = doc.id;
                    final isSelected = selectedStadium == name;
                    return ChoiceChip(
                      label: Text(name),
                      selected: isSelected,
                      selectedColor: const Color(0xFF11AB69),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) {
                        setState(() {
                          if (isSelected) {
                            selectedStadium = null;
                            selectedCategory = null;
                            selectedBrand = null;
                          } else {
                            selectedStadium = name;
                            selectedCategory = null;
                            selectedBrand = null;
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),

            // ⭐ Category 선택
            if (selectedStadium != null) ...[
              const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stadiums')
                    .doc(selectedStadium)
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();

                  final categories = snapshot.data!.docs;
                  return Wrap(
                    spacing: 10,
                    children: categories.map((doc) {
                      final name = doc.id;
                      final isSelected = selectedCategory == name;
                      return ChoiceChip(
                        label: Text(name),
                        selected: isSelected,
                        selectedColor: const Color(0xFF11AB69),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              selectedCategory = null;
                              selectedBrand = null;
                            } else {
                              selectedCategory = name;
                              selectedBrand = null;
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            // ⭐ Brand 선택
            if (selectedCategory != null) ...[
              const Text("Brand", style: TextStyle(fontWeight: FontWeight.bold)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stadiums')
                    .doc(selectedStadium)
                    .collection('categories')
                    .doc(selectedCategory)
                    .collection('brands')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();

                  final brands = snapshot.data!.docs;
                  return Wrap(
                    spacing: 10,
                    children: brands.map((doc) {
                      final name = doc.id;
                      final isSelected = selectedBrand == name;
                      return ChoiceChip(
                        label: Text(name),
                        selected: isSelected,
                        selectedColor: const Color(0xFF11AB69),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              selectedBrand = null;
                            } else {
                              selectedBrand = name;
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            // ⭐ Items 출력
            if (selectedBrand != null) ...[
              const Text("Menu Items", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stadiums')
                      .doc(selectedStadium)
                      .collection('categories')
                      .doc(selectedCategory)
                      .collection('brands')
                      .doc(selectedBrand)
                      .collection('items')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snapshot.data!.docs;
                    if (items.isEmpty) {
                      return const Text("메뉴 없음");
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final data = items[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['name'] ?? '이름 없음'),
                          subtitle: Text("${data['price'] ?? ''} 원"),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 10),

            // ⭐ Filter 버튼
            ElevatedButton(
              onPressed: () {
                debugPrint(
                  "Stadium: $selectedStadium, "
                      "Category: $selectedCategory, "
                      "Brand: $selectedBrand",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF11AB69),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Filter", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
