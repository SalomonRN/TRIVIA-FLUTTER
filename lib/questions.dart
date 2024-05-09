import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:triviaflutter/score.dart';
import 'firebase_options.dart';
import 'pregunta.dart';

final Future<FirebaseApp> firebaseApp =
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

class Questions extends StatelessWidget {
  const Questions({super.key});

  @override
  Widget build(BuildContext context) {
    // Esto lo usaré despues ;);)
    String names = ModalRoute.of(context)!.settings.arguments.toString();
    return MaterialApp(
        title: 'TRIVIA',
        theme: ThemeData(
          fontFamily: 'jerseyr',
          primarySwatch: Colors.deepOrange,
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
                    return MyHomePage(
                        title: "TRIVIA GAME",
                        name:
                            names // Aca pondré despues el nombre de la persona
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
          '/sec': (context) => score()
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.name});
  final String title;

  // Aca se guardá el nombre de la persona
  final String name;

  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState(name);
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
  void res_1() {
    eleccion = res1.toString();
    if (eleccion == respuestaCorrecta) {
      pts += 1;
    }
    if (nVeces < cantidad) {
      pintarPregunta();
    } else {
      nextActivity();
    }
  }

  void res_2() {
    eleccion = res2.toString();
    if (eleccion == respuestaCorrecta) {
      pts += 1;
    }
    if (nVeces < cantidad) {
      pintarPregunta();
    } else {
      nextActivity();
    }
  }

  void res_3() {
    eleccion = res3.toString();
    if (eleccion == respuestaCorrecta) {
      pts += 1;
    }
    if (nVeces < cantidad) {
      pintarPregunta();
    } else {
      nextActivity();
    }
  }

  void res_4() {
    eleccion = res4.toString();
    if (eleccion == respuestaCorrecta) {
      pts += 1;
    }
    if (nVeces < cantidad) {
      pintarPregunta();
    } else {
      nextActivity();
    }
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
                Container(
                  height: 40,
                  child: WaveText("pregunta numero $nVeces",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'jerseyr',
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
                Text(
                  textPregunta,
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'jerseyr',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => res_1(),
                  child: Text(
                    res1,
                    style: TextStyle(
                        color: Color.fromARGB(255, 233, 132, 39),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'jerseyr'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => res_2(),
                  child: Text(
                    res2,
                    style: TextStyle(
                        color: Color.fromARGB(255, 233, 132, 39),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'jerseyr'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => res_3(),
                  child: Text(
                    res3,
                    style: TextStyle(
                        color: Color.fromARGB(255, 233, 132, 39),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'jerseyr'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => res_4(),
                  child: Text(
                    res4,
                    style: TextStyle(
                        color: Color.fromARGB(255, 233, 132, 39),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'jerseyr'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
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

class WaveText extends StatefulWidget {
  final String text;

  WaveText(this.text, {required TextStyle style});

  @override
  _WaveTextState createState() => _WaveTextState();
}

class _WaveTextState extends State<WaveText>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: widget.text.length.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text.length, (index) {
        return AnimatedDefaultTextStyle(
          style: TextStyle(
            fontFamily: 'jerseyr',
            fontSize: (index == _animation.value.floor() % widget.text.length)
                ? 40
                : 30,
            color: Color.fromARGB(255, 131, 37, 0),
            fontWeight: FontWeight.bold,
          ),
          duration: Duration(milliseconds: 200),
          child: Text(widget.text[index]),
        );
      }),
    );
  }
}
