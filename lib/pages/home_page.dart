import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconn2g14/models/user_model.dart';
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
                  // docs.forEach((user) {
                  //   print(user.data());
                  // });
                  List<UserModel> userModelList = docs.map((doc) {
                    return UserModel.fromMap(
                      doc.data() as Map<String, dynamic>,
                    );
                  }).toList();

                  userModelList.forEach((usuario) {
                    print("---------------------");
                    print(usuario.createdAt);
                    print(usuario.email);
                    print(usuario.name);
                  });
                });
              },
              child: Text("Obtener información"),
            ),

            ElevatedButton(
              onPressed: () {
                print(Timestamp.now().toDate());
                userReference
                    .where("age", isGreaterThan: 30)
                    .where("createdAt", isLessThan: Timestamp.now())
                    .get()
                    .then((value) {
                      List<QueryDocumentSnapshot> docs = value.docs;
                      List<UserModel> userModelList = docs.map((element) {
                        return UserModel.fromMap(
                          element.data() as Map<String, dynamic>,
                        );
                      }).toList();
                      userModelList.forEach((usuario) {
                        print("---------------------");
                        print(usuario.createdAt);
                        print(usuario.email);
                        print(usuario.age);
                        print(usuario.name);
                      });
                    });
              },
              child: Text("Obtener info filtrada"),
            ),

            ElevatedButton(
              onPressed: () {
                // AGREGAR UN USUARIO DESDE UN MAPA
                // userReference
                //     .add({
                //       "name": "Ana",
                //       "createdAr": Timestamp.now(),
                //       "email": "anita123@gmail.com",
                //       "age": 45,
                //     })
                //     .then((value) {
                //       print(value);
                //       print(value.id);
                //       print("Uusario agregado correctamente");
                //     })
                //     .catchError((error) {
                //       print("Error al agregar el usuario: $error");
                //     });

                // AGREGAR UN USUARIO DESDE UN USERMODEL
                UserModel newUser = UserModel(
                  name: "Carlos",
                  email: "CARLITOS@12.COM",
                  createdAt: DateTime.now(),
                  age: 15,
                );

                userReference
                    .add(newUser.toMap())
                    .then((value) {
                      print(value);
                      print(value.id);
                      print("Usuario registrado correctamente");
                    })
                    .catchError((error) {
                      print("Error al agregar el usuario: $error");
                    });
              },
              child: Text("Agregar un usuario"),
            ),
          ],
        ),
      ),
    );
  }
}
