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

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.delivery_dining, size: 90, color: Colors.green),
                      const SizedBox(height: 16),
                      Text(
                        _statusMessage(status),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_statusSubMessage(status)),
                      if (status == "완료" && locker != "미정" && pw != "미정") ...[
                        const SizedBox(height: 12),
                        Text(
                          "락커 번호: $locker\n비밀번호: $pw",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("락커에서 음식을 수령해주세요!"),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(thickness: 1),
                const SizedBox(height: 12),
                const Text(
                  "📦 배달 상태",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _statusTile(Icons.pending_actions, "대기", "주문이 접수되었습니다.", status == "대기"),
                const SizedBox(height: 10),
                _statusTile(Icons.lock_outline, "락커 배정", "락커가 배정되었습니다.", status == "배정"),
                const SizedBox(height: 10),
                _statusTile(Icons.restaurant, "조리중", "현재 조리 중입니다.", status == "조리중"),
                const SizedBox(height: 10),
                _statusTile(Icons.check_circle_outline, "완료", "락커에서 수령 가능합니다.", status == "완료"),
                const Spacer(),

                // ✅ 조건에 따라 버튼 변경
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (status == "완료") {
                        // 🔹 락커 열기 로직 (비밀번호 확인 후 열림)
                        final inputPw = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              title: const Text("락커 비밀번호 입력"),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: "비밀번호 입력",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("취소"),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, controller.text),
                                  child: const Text("확인"),
                                ),
                              ],
                            );
                          },
                        );

                        if (inputPw == null) return;
                        if (inputPw == pw) {
                          await FirebaseFirestore.instance
                              .collection("orders")
                              .doc(orderId)
                              .update({"isOpened": true});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("락커가 열렸습니다 🔓")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("비밀번호가 올바르지 않습니다.")),
                          );
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      status == "완료" ? "락커 열기" : "메인으로 돌아가기",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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

  String _statusSubMessage(String status) {
    switch (status) {
      case "대기":
        return "관리자 확인 후 조리가 시작됩니다.";
      case "배정":
        return "락커가 배정되었습니다. 비밀번호를 확인해주세요.";
      case "조리중":
        return "셰프가 맛있게 조리 중입니다 🍳";
      case "완료":
        return "락커에서 수령 가능합니다.";
      default:
        return "";
    }
  }
}
