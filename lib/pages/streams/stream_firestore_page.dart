import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconn2g14/models/user_model.dart';
import 'package:firebaseconn2g14/pages/streams/contador_stream_controller_page.dart';
import 'package:firebaseconn2g14/pages/streams/multiple_stream_controller_page.dart';
import 'package:firebaseconn2g14/pages/streams/temporizador_stream_page.dart';
import 'package:flutter/material.dart';

// OJO AQUI FALTA DEFINIR LOS CLOSE APRA CADA CONTROLADOR
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

  final settingsRef = FirebaseFirestore.instance
      .collection("settings")
      .doc("app");

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchSettings() {
    return settingsRef.snapshots();
  }

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
              flex: 6,
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
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: watchSettings(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  final data = snapshot.data!.data();
                  if (data == null) return Text("No existe el documento");

                  final enMantenimiento =
                      (data["enMantenimiento"] ?? false) as bool;

                  return Text(
                    "Modo de mantenimiento: $enMantenimiento",
                    style: TextStyle(fontSize: 20),
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContadorStreamControllerPage(),
                        ),
                      );
                    },
                    child: Text("Contador StreamcController"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultipleStreamControllerPage(),
                        ),
                      );
                    },
                    child: Text("Múltiples  StreamcController"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TemporizadorStreamPage(),
                        ),
                      );
                    },
                    child: Text("Temporizador Stream Page"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
