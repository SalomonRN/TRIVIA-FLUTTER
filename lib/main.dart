// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:triviaflutter/firebase_options.dart';
import 'package:triviaflutter/questions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Ventanainicio());
}

final Future<FirebaseApp> firebaseApp =
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
TextEditingController txt_pass = TextEditingController();
TextEditingController txt_email = TextEditingController();

class Ventanainicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Para ir a la otra pantalla
    void nextActivity(String name) {
      Navigator.pushNamed(context, '/sec', arguments: [name]);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'jerseyr'),
        routes: {
          '/': (context) => FutureBuilder(
                future: firebaseApp,
                builder: (context, snapshot) {
                  // Si existe algun error
                  if (snapshot.hasError) {
                    return const Text("ERROR");
                  } else if (snapshot.hasData) {
                    // Existe data?
                    return MyHomePage(title: 'TRIVIA');
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
          '/questions': (context) => Questions()
        });
  }

  // void login() async {}
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => LogIn();
}

class LogIn extends State<MyHomePage> {
  void login() {
    DatabaseReference database = FirebaseDatabase.instance.ref();
    database
        .child('usuarios')
        .orderByChild('email')
        .equalTo(txt_email.text)
        .get()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        for (var usuarioSnapshot in dataSnapshot.children) {
          if (usuarioSnapshot.child("pass").value.toString() == txt_pass.text) {
            // Siguiente pantalla
            Navigator.pushNamed(context, '/questions',
                arguments: usuarioSnapshot.child("name").value.toString());
          } else {
            // CUANDO NO ESTA LA CONTRASEÑA CORRECTA
            print("CONTRASEÑA INCORRECTA");
          }
        }
      } else {
        // EMAIL NO ENCONTRADO
        print("NO DATA");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trivia Code',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 131, 37, 0)),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'images/p1.gif',
                      width: 300,
                      height: 300,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      child: WaveText(
                        "Inicio de sesión",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: txt_email,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 131, 37, 0)),
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: txt_pass,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 131, 37, 0)),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                            color: Color.fromARGB(255, 233, 132, 39),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistroScreen()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'Aún no te has registrado, ',
                          style: TextStyle(fontSize: 30),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Regístrate',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class WaveText extends StatefulWidget {
  final String text;
  final TextStyle style;

  WaveText(this.text, {required this.style});

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
                ? 60
                : 50,
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

class RegistroScreen extends StatelessWidget {
  TextEditingController txt_pass_ = TextEditingController();
  TextEditingController txt_email_ = TextEditingController();
  TextEditingController txt_nameU_ = TextEditingController();
  TextEditingController txt_age_ = TextEditingController();

  void registrar() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    final nuevoUsuario = {
      'name': txt_nameU_.text,
      'email': txt_email_.text,
      'age': int.parse(txt_age_.text),
      'pass': txt_pass_.text,
    };
    final newPostKey = databaseReference.child('posts').push().key;
    databaseReference.child("usuarios").child(newPostKey!).set(nuevoUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pantalla de Registro")),
      body: Column(
        children: [
          TextField(
            controller: txt_nameU_,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 131, 37, 0)),
            decoration: InputDecoration(
              labelText: 'NAME',
              border: OutlineInputBorder(),
            ),
            obscureText: false,
          ),
          TextField(
            controller: txt_email_,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 131, 37, 0)),
            decoration: InputDecoration(
              labelText: 'EMAIL',
              border: OutlineInputBorder(),
            ),
            obscureText: false,
          ),
          TextField(
            controller: txt_pass_,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 131, 37, 0)),
            decoration: InputDecoration(
              labelText: 'PASS',
              border: OutlineInputBorder(),
            ),
            obscureText: false,
          ),
          TextField(
            controller: txt_age_,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 131, 37, 0)),
            decoration: InputDecoration(
              labelText: 'AGE',
              border: OutlineInputBorder(),
            ),
            obscureText: false,
          ),
          ElevatedButton(
            onPressed: () {
              registrar();
              Navigator.pop(context);

            },
            child: Text(
              "REGISTRARSE ",
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
    );
  }
}
