import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadSuwonData() async {
  final firestore = FirebaseFirestore.instance;
  WriteBatch batch = firestore.batch();

  final stadiumRef = firestore.collection("stadiums").doc("수원 KT 위즈 파크");

  // --------------------- 치킨 ---------------------
  final chickenRef = stadiumRef.collection("categories").doc("치킨");

  final jinmiRef = chickenRef.collection("brands").doc("진미통닭");
  final jinmiItems = [
    {"name": "프라이드치킨", "price": 17000},
  ];
  for (var menu in jinmiItems) {
    final docRef = jinmiRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  final torimeroRef = chickenRef.collection("brands").doc("토리메로(BBQ 이자카야)");
  final torimeroItems = [
    {"name": "모듬꼬치", "price": 16900},
    {"name": "이카게소", "price": 14900},
    {"name": "트러플 알감자", "price": 11900},
  ];
  for (var menu in torimeroItems) {
    final docRef = torimeroRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  // --------------------- 분식·만두·스낵 ---------------------
  final bunsikRef = stadiumRef.collection("categories").doc("분식·만두·스낵");

  final boyoungRef = bunsikRef.collection("brands").doc("보영만두");
  final boyoungItems = [
    {"name": "군만두/쫄면세트", "price": 25500},
    {"name": "군만두", "price": 8500},
    {"name": "쫄면", "price": 8500},
  ];
  for (var menu in boyoungItems) {
    final docRef = boyoungRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  final brusselsRef = bunsikRef.collection("brands").doc("브뤼셀프라이");
  final brusselsItems = [
    {"name": "홈런세트", "price": 12600},
    {"name": "안타세트", "price": 11600},
    {"name": "2루타세트", "price": 11600},
  ];
  for (var menu in brusselsItems) {
    final docRef = brusselsRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  // --------------------- 카페·디저트 ---------------------
  final dessertRef = stadiumRef.collection("categories").doc("카페·디저트");

  final jungjiRef = dessertRef.collection("brands").doc("정지영커피로스터즈");
  final jungjiItems = [
    {"name": "아메리카노", "price": null},
    {"name": "라떼", "price": null},
    {"name": "바닐라라떼", "price": null},
  ];
  for (var menu in jungjiItems) {
    final docRef = jungjiRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  final yoajungRef = dessertRef.collection("brands").doc("요아정");
  final yoajungItems = [
    {"name": "달콤 위닝의 정석", "price": 20000},
    {"name": "메론 히트의 정석", "price": 19000},
    {"name": "홈런의 정석", "price": 16000},
  ];
  for (var menu in yoajungItems) {
    final docRef = yoajungRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  final salleriaRef = dessertRef.collection("brands").doc("샐러리아");
  final salleriaItems = [
    {"name": "스팀 닭가슴살 단백질 도시락", "price": 8400},
    {"name": "스팀 매콤 닭가슴살 단백질 도시락", "price": 8400},
    {"name": "수비드 닭다리살 단백질 도시락", "price": 8900},
  ];
  for (var menu in salleriaItems) {
    final docRef = salleriaRef.collection("items").doc(menu["name"] as String);
    batch.set(docRef, menu);
  }

  // ✅ Firestore 반영
  await batch.commit();
  print("✅ 수원 KT 위즈 파크 데이터 업로드 완료!");
}
