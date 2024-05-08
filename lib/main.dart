import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:triviaflutter/pantalla2.dart';
import 'firebase_options.dart';
import 'pregunta.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final Future<FirebaseApp> firebaseApp =
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Esto lo usaré despues ;);)
    //final Object? name = ModalRoute.of(context)?.settings.arguments;
    return MaterialApp(
        title: 'TRIVIA',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        /**
         * Esta parte de Routes es para definir las rutas :vvvvv
         * Es decir cada pantalla, lo que está entre comillas es el nombre con el cual vamos a llamarlo despues
         */
        initialRoute: '/',
        routes: {
          /**
           * Para que la base de datos funcione toca si o si hacerlo asi
           */
          '/': (context) => FutureBuilder(
                future: firebaseApp,
                builder: (context, snapshot) {
                  // Si existe algun error
                  if (snapshot.hasError) {
                    return const Text("ERROR");
                  } else if (snapshot.hasData) {
                    // Existe data?
                    return const MyHomePage(
                      title: "TRIVIA GAME",
                      name:
                          'name', // Aca pondré despues el nombre de la persona
                    );
                  } else {
                    /**
                     * -------------------------ACA-------------------
                     * Lo de aca es lo que se va a mostrar antes de que la base de datos retorne la informacion, pero 
                     * realemnte la base de datos retorna en menos de 1 segundo la informacion
                     */
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.amber,
                      color: Colors.blueGrey,
                    ));
                  }
                },
              ),
          // Otra ruta
          '/sec': (context) => Pantalla2()
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.name});
  final String title;

  // Aca se guardá el nombre de la persona
  final Object? name;

  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState('NAME');
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.name);
  // VARIABLES NECESARIAS
  String name;
  List<Pregunta> map = List.empty(growable: true);
  String textPregunta = "";
  int nPregunta = 0;
  String eleccion = '';
  String res1 = '';
  String res2 = '';
  String res3 = '';
  String res4 = '';
  String respuestaCorrecta = '';
  int pts = 0;
  int cantidad = 10;
  int nVeces = 0;
  // FUNCIONES QUE SE EJECUTARAN CUANDO SE LE DEN CLICK AL TEXTO

  void comprobar() {
    if (eleccion == respuestaCorrecta) {
      pts += 1;
    }
    if (nVeces < cantidad) {
      pintarPregunta();
    } else {
      nextActivity();
    }
  }

  void res_1() {
    eleccion = res1.toString();
    comprobar();
  }

  void res_2() {
    eleccion = res2.toString();
    comprobar();
  }

  void res_3() {
    eleccion = res3.toString();
    comprobar();
  }

  void res_4() {
    eleccion = res4.toString();
    comprobar();
  }

  // Para ir a la otra pantalla
  void nextActivity() {
    Navigator.pushNamed(context, '/sec', arguments: [pts.toString(), name]);
  }

  // Para mostrar los datos de la pregunta
  void pintarPregunta() {
    setState(() {
      nVeces += 1;
      Pregunta pregunta = map.elementAt(Random().nextInt(map.length));
      map.remove(pregunta);
      respuestaCorrecta = pregunta.respuestaCorrecta.toString();
      Iterable<String> respuestas = pregunta.respuestas;
      textPregunta = pregunta.pregunta.toString();
      res4 = "Pregunta Numero: $nVeces";
      //
      res1 = respuestas.elementAt(0).toString();
      res2 = respuestas.elementAt(1).toString();
      res3 = respuestas.elementAt(2).toString();
      res4 = respuestas.elementAt(3).toString();
    });
  }

  // Esta es la funcion que traee los datos de la BD
  Future<void> datos() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    final dataSnapshot = await reference.child("preguntas").get();
    for (DataSnapshot preguntaSnapshot in dataSnapshot.children) {
      String pregunta = preguntaSnapshot.child("pregunta").value.toString();
      String respuestaCorrecta =
          preguntaSnapshot.child("respuestaCorrecta").value.toString();
      Iterable<String> respuestas = preguntaSnapshot
          .child("respuestas")
          .children
          .map((e) => e.value.toString());
      Pregunta pregunta0 = Pregunta(pregunta, respuestaCorrecta, respuestas);
      map.add(pregunta0);
    }
    pintarPregunta();
  }

  // Esto es para cuando se incie el Widget
  @override
  void initState() {
    super.initState();
    datos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Pregunta numero $nVeces"),
            Text(textPregunta),
            Material(
              child: InkWell(
                onTap: () {
                  res_1();
                },
                child: Text(res1),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  res_2();
                },
                child: Text(res2),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  res_3();
                },
                child: Text(res3),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  res_4();
                },
                child: Text(res4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
