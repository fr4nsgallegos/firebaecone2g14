import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  DateTime createdAt;
  int age;

  UserModel({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.age,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    Timestamp timeFirestore = map["createdAt"] ?? Timestamp.now();
    return UserModel(
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      age: map["age"] ?? "",
      createdAt: timeFirestore.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "createdAt": Timestamp.fromDate(createdAt),
      "age": age,
    };
  }
}
