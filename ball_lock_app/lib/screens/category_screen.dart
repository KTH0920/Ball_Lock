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

  // ✅ 브랜드별 이미지 매핑
  final Map<String, String> brandImages = {
    'BBQ': 'assets/images/bbq1.png',
    'BHC': 'assets/images/bhc1.png',
  };

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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stadiums').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("구장 데이터 없음");
                }

                final stadiums = snapshot.data!.docs;
                return Wrap(
                  spacing: 10,
                  children: stadiums.map((doc) {
                    final name = doc.id;
                    final isSelected = selectedStadium == name;
                    return ChoiceChip(
                      label: Text(name),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1E6F6A),
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

            // ⭐ Category
            if (selectedStadium != null) ...[
              const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stadiums')
                    .doc(selectedStadium)
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("카테고리 없음");
                  }

                  final categories = snapshot.data!.docs;
                  return Wrap(
                    spacing: 10,
                    children: categories.map((doc) {
                      final name = doc.id;
                      final isSelected = selectedCategory == name;
                      return ChoiceChip(
                        label: Text(name),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1E6F6A),
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

            // ⭐ Brand
            if (selectedCategory != null) ...[
              const Text("Brand", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stadiums')
                    .doc(selectedStadium)
                    .collection('categories')
                    .doc(selectedCategory)
                    .collection('brands')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("브랜드 없음");
                  }

                  final brands = snapshot.data!.docs;
                  return Wrap(
                    spacing: 10,
                    children: brands.map((doc) {
                      final name = doc.id;
                      final isSelected = selectedBrand == name;
                      return ChoiceChip(
                        label: Text(name),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1E6F6A),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedBrand = isSelected ? null : name;
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            // ⭐ Menu Items + 이미지 카드 디자인
            if (selectedBrand != null) ...[
              const Text("Menu Items", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("메뉴 없음");
                    }

                    final items = snapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final data = items[index].data() as Map<String, dynamic>;
                        final name = data['name'] ?? '이름 없음';
                        final price = data['price'] ?? '';
                        final imagePath = brandImages[selectedBrand] ?? '';

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  imagePath,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₩$price",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                debugPrint("Stadium: $selectedStadium, Category: $selectedCategory, Brand: $selectedBrand");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F6A),
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
