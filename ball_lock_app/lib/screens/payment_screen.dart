import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'delivery_status_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  final TextEditingController _seatController = TextEditingController();

  final List<Map<String, dynamic>> _methods = [
    {"title": "락커 배달", "subtitle": "10~15분 후 도착", "fee": 1000, "icon": Icons.lock_outline},
    {"title": "좌석 배달", "subtitle": "20~25분 후 도착", "fee": 2500, "icon": Icons.event_seat},
    {"title": "픽업", "subtitle": "10~13분 후 픽업", "fee": 0, "icon": Icons.store_mall_directory},
  ];

  final int menuPrice = 25000;
  final double discount = 0.1;

  @override
  void dispose() {
    _seatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int deliveryFee = _methods[_selectedMethod]["fee"];
    final double total = menuPrice + deliveryFee - (menuPrice * discount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("결제화면"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔹 상단 내용은 스크롤 가능
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "수령방법을 선택해주세요*",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // 🔹 수령 방법 리스트
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
                                Icon(method["icon"], color: theme.colorScheme.primary),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method["title"],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      method["subtitle"],
                                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "${method["fee"]}원",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // 🔹 좌석 입력 필드
                  TextField(
                    controller: _seatController,
                    decoration: InputDecoration(
                      labelText: "좌석번호 입력 (예: A12)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 결제 금액 요약
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("메뉴 금액", "${menuPrice}원"),
                        _buildSummaryRow("배달팁", "${deliveryFee}원"),
                        _buildSummaryRow("할인", "-${(discount * 100).toInt()}%"),
                        const Divider(),
                        _buildSummaryRow(
                          "최종 결제금액",
                          "${total.toInt()}원",
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 하단 결제 버튼 (가로 전체)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final seat = _seatController.text.trim();
                if (seat.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("좌석번호를 입력해주세요.")),
                  );
                  return;
                }

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                final userData = userDoc.data();

                final order = {
                  "uid": user!.uid,
                  "customerName": userData?['name'] ?? "이름 없음",
                  "phone": userData?['phone'] ?? "",
                  "seat": seat,
                  "locker": null,
                  "lockerPassword": null,
                  "menu": "떡볶이",
                  "quantity": 2,
                  "price": total.toInt(),
                  "payment": "완료",
                  "status": "대기",
                  "createdAt": FieldValue.serverTimestamp(),
                };

                final docRef =
                await FirebaseFirestore.instance.collection("orders").add(order);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("결제가 완료되었습니다. ($seat석)")),
                );

                await Future.delayed(const Duration(seconds: 1));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeliveryStatusScreen(orderId: docRef.id),
                  ),
                );
              },
              child: const Text(
                "결제하기",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 결제 요약 행 위젯
  Widget _buildSummaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
