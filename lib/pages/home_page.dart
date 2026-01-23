import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // final db = FirebaseFirestore.instance;
  // CollectionReference userReference = db.collection("users");

  CollectionReference userReference = FirebaseFirestore.instance.collection(
    "users",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                userReference.get().then((value) {
                  List<QueryDocumentSnapshot> docs = value.docs;
                  docs.forEach((user) {
                    print(user.data());
                  });
                });
              },
              child: Text("Obtener información"),
            ),
          ],
        ),
      ),
    );
  }
}
