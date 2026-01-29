import 'package:flutter/material.dart';

class TemporizadorStreamPage extends StatelessWidget {
  const TemporizadorStreamPage({super.key});

  Stream<int> temporizador() async* {
    int segundos = 0;
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield ++segundos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: temporizador(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "Segundos: ${snapshot.data}",
                    style: TextStyle(fontSize: 25),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
