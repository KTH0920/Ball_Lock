import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'delivery_status_screen.dart';

class DeliveryStatusPage extends StatefulWidget {
  const DeliveryStatusPage({super.key});

  @override
  State<DeliveryStatusPage> createState() => _DeliveryStatusPageState();
}

class _DeliveryStatusPageState extends State<DeliveryStatusPage> {
  bool _loading = true;
  String? _orderId;

  @override
  void initState() {
    super.initState();
    _checkOrder();
  }

  Future<void> _checkOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
        _orderId = null;
      });
      return;
    }

    try {
      // 🔹 최근 주문 1건만 조회
      final snapshot = await FirebaseFirestore.instance
          .collection("orders")
          .where("uid", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final status = data["status"] ?? "";

        if (status != "완료") {
          setState(() {
            _orderId = snapshot.docs.first.id;
            _loading = false;
          });
          return;
        }
      }

      // 🔹 주문이 없거나 완료된 상태일 때
      setState(() {
        _orderId = null;
        _loading = false;
      });
    } catch (e) {
      debugPrint("🔥 Firestore 오류: $e");
      setState(() {
        _orderId = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("배달 현황")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_orderId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("배달 현황")),
        body: const Center(
          child: Text(
            "현재 주문이 없는 상태입니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return DeliveryStatusScreen(orderId: _orderId!);
  }
}
