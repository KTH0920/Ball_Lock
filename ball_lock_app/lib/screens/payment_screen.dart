import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  final List<Map<String, dynamic>> _methods = [
    {"title": "락커 배달", "subtitle": "10~15분 후 도착", "fee": 1000, "icon": Icons.lock_outline},
    {"title": "좌석 배달", "subtitle": "20~25분 후 도착", "fee": 2500, "icon": Icons.event_seat},
    {"title": "픽업", "subtitle": "10~13분 후 픽업", "fee": 0, "icon": Icons.store_mall_directory},
  ];

  final int menuPrice = 25000;
  final double discount = 0.1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final int deliveryFee = _methods[_selectedMethod]["fee"];
    final double total = menuPrice + deliveryFee - (menuPrice * discount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("결제화면"),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("수령방법을 선택해주세요*",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 수령방법 카드
            ...List.generate(_methods.length, (i) {
              final method = _methods[i];
              final selected = _selectedMethod == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedMethod = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected ? theme.colorScheme.primary : theme.dividerColor,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(method["icon"], color: theme.iconTheme.color),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(method["title"],
                                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                              Text(method["subtitle"],
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                            ],
                          ),
                        ],
                      ),
                      Text("${method["fee"]}원",
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            Text("결제금액을 확인해주세요",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 결제 금액 블럭
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(theme, "메뉴 금액", "${menuPrice}원"),
                  _buildSummaryRow(theme, "배달팁", "${deliveryFee}원"),
                  _buildSummaryRow(theme, "메뉴할인", "-${(discount * 100).toInt()}%"),
                  const Divider(height: 20, thickness: 1),
                  _buildSummaryRow(theme, "최종 결제금액", "${total.toInt()}원", bold: true),
                ],
              ),
            ),

            const Spacer(),

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("결제가 완료되었습니다. 총 ${total.toInt()}원")),
                  );
                  Navigator.pop(context);
                },
                child: Text("결제하기",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
