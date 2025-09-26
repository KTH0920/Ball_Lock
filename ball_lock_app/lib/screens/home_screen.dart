import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'category_screen.dart';
import 'sign_in.dart';
import 'profile_screen.dart';
import 'favorites_page.dart';
import 'cart_screen.dart';
import 'notification_screen.dart'; // ✅ 알림 화면 추가

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ build 안에서 안전하게 초기화
    final pages = [
      _buildHomePage(),
      const FavoritesScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.disabledColor,
        showUnselectedLabels: true,
        onTap: (i) async {
          if (i == 3) {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }
            return;
          }
          setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "관심목록"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "장바구니"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "프로필"),
        ],
      ),
    );
  }

  // ✅ 홈 화면 위젯
  Widget _buildHomePage() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Food\nLocker!",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationScreen()),
                  );
                },
                icon: const Icon(Icons.notifications_none),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 검색창 + 필터 버튼
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "야구장 검색!",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.surfaceVariant,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                ),
                child: Icon(Icons.tune, color: theme.colorScheme.onPrimary),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // 카테고리 타이틀
          Text(
            "카테고리",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // 카테고리 리스트
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategory("샌드위치", "assets/images/sandwich.png"),
                _buildCategory("피자", "assets/images/pizza.png"),
                _buildCategory("버거", "assets/images/burger.png"),
                _buildCategory("음료", "assets/images/drinks.png"),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 추천 타이틀
          Text(
            "추천 메뉴",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // 추천 메뉴
          Row(
            children: [
              Expanded(
                child: _buildFoodCard(
                    "샌드위치", "\$15.50", "assets/images/sandwich.png"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFoodCard(
                    "햄버거", "\$19.99", "assets/images/burger.png"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ 카테고리 카드
  Widget _buildCategory(String title, String imagePath) {
    final theme = Theme.of(context);
    final bool isSelected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? null : title;
        });
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 음식 카드
  Widget _buildFoodCard(String title, String price, String imagePath) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text("가격: $price",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}
