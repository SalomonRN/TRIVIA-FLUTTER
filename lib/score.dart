import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:triviaflutter/firebase_options.dart';

class score extends StatelessWidget {
  final Future<FirebaseApp> firebaseApp =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    final List<String> datosRecibidos =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 2'),
      ),
      body: Container(
        color: Color.fromARGB(255, 131, 37, 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 132, 39),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nombre: ${datosRecibidos[1]}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 131, 37, 0),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Puntaje: ${datosRecibidos[0]}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 131, 37, 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
