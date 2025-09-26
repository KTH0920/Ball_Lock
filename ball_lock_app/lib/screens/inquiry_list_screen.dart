import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InquiryListScreen extends StatelessWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("내 문의 내역")),
        body: const Center(child: Text("로그인이 필요합니다.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("내 문의 내역"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("inquiries")
            .where("userId", isEqualTo: user.uid) // ✅ orderBy 제거
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "에러 발생: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("작성한 문의가 없습니다."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final inquiry = docs[i].data() as Map<String, dynamic>;
              final status = inquiry["status"] ?? "pending";
              final reply = inquiry["replyContent"];
              final createdAt =
              (inquiry["createdAt"] as Timestamp?)?.toDate();

              // 상태별 색상 & 아이콘
              IconData statusIcon;
              Color statusColor;
              String statusLabel;

              switch (status) {
                case "answered":
                  statusIcon = Icons.check_circle;
                  statusColor = Colors.green;
                  statusLabel = "답변 완료";
                  break;
                case "rejected":
                  statusIcon = Icons.cancel;
                  statusColor = Colors.red;
                  statusLabel = "반려됨";
                  break;
                default:
                  statusIcon = Icons.hourglass_bottom;
                  statusColor = Colors.orange;
                  statusLabel = "대기중";
              }

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(inquiry["content"] ?? ""),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (createdAt != null)
                        Text(
                          "작성일: ${createdAt.toLocal()}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      Text("상태: $statusLabel",
                          style: TextStyle(color: statusColor)),
                      if (reply != null && reply.isNotEmpty)
                        Text("답변: $reply"),
                    ],
                  ),
                  leading: Icon(statusIcon, color: statusColor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
