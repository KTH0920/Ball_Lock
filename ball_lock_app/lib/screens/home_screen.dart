import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'category_screen.dart';
import 'sign_in.dart';
import 'profile_screen.dart';
import 'delivery_status_page.dart';
import 'delivery_status_screen.dart';
import 'cart_screen.dart';
import 'notification_screen.dart';
import 'my_page_screen.dart';

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

    final pages = [
      _buildHomePage(),
      const DeliveryStatusPage(),
      const CartScreen(),
      const MyPageScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(child: pages[_currentIndex]),
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
              return;
            }
          }
          setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: "배달현황"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "장바구니"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "마이페이지"),
        ],
      ),
    );
  }

  // ✅ 홈 화면
  Widget _buildHomePage() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀 + 알림 (기존 유지)
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

          const SizedBox(height: 25),

          // -------------------- 검색창 --------------------
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "무엇을 찾고 계신가요?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CategoryScreen()),
                    );
                  },
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // -------------------- 카테고리 --------------------
          Text(
            "카테고리 🍔",
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryCard("샌드위치", "assets/images/sand.png"),
                _buildCategoryCard("피자", "assets/images/djpizza1.png"),
                _buildCategoryCard("버거", "assets/images/kfc2.png"),
                _buildCategoryCard("음료", "assets/images/drinks.png"),
                _buildCategoryCard("치킨", "assets/images/chicken.png"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // -------------------- 추천 메뉴 --------------------
          Text(
            "오늘의 추천 메뉴 🍴",
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFoodCard("클럽 샌드위치", "₩8,900", "assets/images/sand.png"),
                _buildFoodCard("치즈버거 세트", "₩9,500", "assets/images/kfc2.png"),
                _buildFoodCard("콤비네이션 피자", "₩15,000", "assets/images/djpizza4.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 카테고리 카드
  Widget _buildCategoryCard(String title, String imagePath) {
    final theme = Theme.of(context);
    final isSelected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? null : title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
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
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: const Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
