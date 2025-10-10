import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryStatusScreen extends StatelessWidget {
  final String orderId;
  const DeliveryStatusScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("배달 현황"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!.data() as Map<String, dynamic>;
          final status = order["status"] ?? "대기";
          final locker = order["locker"]?.toString() ?? "미정";
          final pw = order["lockerPassword"]?.toString() ?? "미정";

          return Column(
            children: [
              // 🔹 위쪽 내용은 스크롤 가능하도록
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.delivery_dining,
                                size: 90, color: Colors.green),
                            const SizedBox(height: 16),
                            Text(
                              _statusMessage(status),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(_statusSubMessage(status)),

                            // ✅ 완료 상태일 때만 락커 정보 표시
                            if (status == "완료" &&
                                locker != "미정" &&
                                pw != "미정") ...[
                              const SizedBox(height: 16),
                              const Divider(thickness: 1),
                              const SizedBox(height: 10),
                              Text(
                                "락커 번호: $locker\n비밀번호: $pw",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "락커에서 음식을 수령해주세요!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(thickness: 1),
                      const SizedBox(height: 12),
                      const Text(
                        "📦 배달 상태",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // 🔹 상태별 표시
                      _statusTile(Icons.pending_actions, "대기", "주문이 접수되었습니다.", status == "대기"),
                      const SizedBox(height: 10),
                      _statusTile(Icons.lock_outline, "락커 배정", "락커가 배정되었습니다.", status == "배정"),
                      const SizedBox(height: 10),
                      _statusTile(Icons.restaurant, "조리중", "현재 조리 중입니다.", status == "조리중"),
                      const SizedBox(height: 10),
                      _statusTile(Icons.check_circle_outline, "완료", "락커에서 수령 가능합니다.", status == "완료"),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // 🔹 하단 버튼은 고정
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "메인으로 돌아가기",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ 진행 상태 타일
  static Widget _statusTile(
      IconData icon, String title, String subtitle, bool active) {
    return ListTile(
      leading: Icon(icon, color: active ? Colors.green : Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Text(
        active ? "진행중" : "대기",
        style: TextStyle(
          color: active ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: active ? Colors.green : Colors.grey.shade400),
      ),
    );
  }

  // ✅ 상태별 메시지
  String _statusMessage(String status) {
    switch (status) {
      case "대기":
        return "주문이 접수되었습니다!";
      case "배정":
        return "락커 배정 완료!";
      case "조리중":
        return "현재 조리 중이에요 🍳";
      case "완료":
        return "주문이 완료되었습니다!";
      default:
        return "주문 상태 확인 중...";
    }
  }

  // ✅ 상태별 서브 메시지
  String _statusSubMessage(String status) {
    switch (status) {
      case "대기":
        return "관리자 확인 후 조리가 시작됩니다.";
      case "배정":
        return "락커가 배정되었습니다. 조리 완료 후 이용 가능합니다.";
      case "조리중":
        return "셰프가 맛있게 조리 중입니다 🍳";
      case "완료":
        return "락커에서 수령 가능합니다.";
      default:
        return "";
    }
  }
}
