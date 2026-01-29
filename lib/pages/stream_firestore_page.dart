import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconn2g14/models/user_model.dart';
import 'package:flutter/material.dart';

class StreamFirestorePage extends StatelessWidget {
  StreamFirestorePage({super.key});

  final CollectionReference userReference = FirebaseFirestore.instance
      .collection("users");

  final usersRefTipada = FirebaseFirestore.instance
      .collection("users")
      .withConverter(
        fromFirestore: (snapshot, options) => UserModel.fromFirestore(snapshot),
        toFirestore: (value, options) => value.toMap(),
      );

  Stream<QuerySnapshot<UserModel>> watchUsers() {
    return usersRefTipada.orderBy("createdAt", descending: true).snapshots();
  }

  Future<void> addUser() async {
    final user = UserModel(
      name: "Juanito",
      email: "Juan@tes.com",
      createdAt: DateTime.now(),
      age: 45,
    );

    await usersRefTipada.add(user);
  }

  Future<void> updateUser(String docId) async {
    await usersRefTipada.doc(docId).update({"name": "Nombre actualizado"});
  }

  Future<void> deteleUser(String docId) async {
    await usersRefTipada.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addUser();
        },
      ),
      appBar: AppBar(title: Text("Uuarios en tiempo real")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder(
                // stream: userReference.snapshots(),
                stream: watchUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final List docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(child: Text("No hay usuarios aún"));
                  }

                  final usersList = docs.map((e) => e.data()).toList();

                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      final UserModel u = usersList[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(u.name[0])),
                        title: Text(u.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                updateUser(u.id!);
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deteleUser(u.id!);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "${u.email} / ${u.createdAt.toString().substring(0, 11)}",
                        ),
                      );
                    },
                  );

                  // return ListView.builder(
                  //   itemCount: docs.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     var data = docs[index].data() as Map<String, dynamic>;
                  //     return ListTile(title: Text(data["name"]));
                  //   },
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
