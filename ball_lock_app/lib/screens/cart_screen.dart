import 'package:flutter/material.dart';
import 'payment_screen.dart'; // ✅ 결제화면 import

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // 샘플 데이터
  final List<Map<String, dynamic>> _cartItems = [
    {"title": "Spicy with black papper sauce", "qty": 1, "price": 100},
    {"title": "Spicy with black papper sauce", "qty": 1, "price": 50},
    {"title": "Spicy with black papper sauce", "qty": 1, "price": 68},
  ];

  double get totalItems =>
      _cartItems.fold(0, (sum, item) => sum + (item["price"] * item["qty"]));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ 테마 가져오기

    return Scaffold(
      appBar: AppBar(
        title: const Text("장바구니"),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // 장바구니 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.fastfood,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                    ),
                    title: Text(item["title"],
                        style: theme.textTheme.bodyMedium),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (item["qty"] > 1) item["qty"]--;
                            });
                          },
                          icon: Icon(Icons.remove_circle_outline,
                              color: theme.colorScheme.primary),
                        ),
                        Text("${item["qty"]}",
                            style: theme.textTheme.bodyMedium),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              item["qty"]++;
                            });
                          },
                          icon: Icon(Icons.add_circle_outline,
                              color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 합계 영역
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Column(
              children: [
                _buildSummaryRow("Items",
                    "\$${totalItems.toStringAsFixed(2)}", theme),
                _buildSummaryRow("Sales Tax", "\$25.99", theme),
                _buildSummaryRow("Promo Code", "\$0.00", theme),
                const Divider(height: 20, thickness: 1),
                _buildSummaryRow(
                  "Subtotal (${_cartItems.length} items)",
                  "\$${(totalItems + 25.99).toStringAsFixed(2)}",
                  theme,
                  isBold: true,
                ),
                const SizedBox(height: 20),

                // 결제 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // ✅ 결제 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "결제하기",
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 요약 행 위젯
  Widget _buildSummaryRow(
      String label, String value, ThemeData theme,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
