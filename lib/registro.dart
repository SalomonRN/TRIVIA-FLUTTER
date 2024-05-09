import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RegistrarUsuario());
}

class RegistrarUsuario extends StatelessWidget {
  final TextEditingController txt_pass_ = TextEditingController();
  final TextEditingController txt_email_ = TextEditingController();
  final TextEditingController txt_nameU_ = TextEditingController();
  final TextEditingController txt_age_ = TextEditingController();

  void registrar(BuildContext context) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    final nuevoUsuario = {
      'name': txt_nameU_.text,
      'email': txt_email_.text,
      'age': txt_age_.text,
      'pass': txt_pass_.text,
    };
    final newPostKey = databaseReference.child('posts').push().key;
    databaseReference.child("usuarios").child(newPostKey!).set(nuevoUsuario);

    // Navegar de regreso a la pantalla anterior después de registrar
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'jerseyr'),
      home: Scaffold(
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
                            fontFamily: 'jerseyr',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 131, 37, 0),
                          ),
                        ),
                        SizedBox(height: 30),
                        Image.asset(
                          'images/p1.GIF',
                          width: 480,
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
                          child: WaveText("Registro de usuario",
                              style: TextStyle(fontSize: 50)),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: txt_nameU_,
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 131, 37, 0)),
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: txt_age_,
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 131, 37, 0)),
                          decoration: InputDecoration(
                            labelText: 'Edad',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: txt_email_,
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 131, 37, 0)),
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: txt_pass_,
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 131, 37, 0)),
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            registrar(context);
                          },
                          child: Text(
                            'Registrar usuario',
                            style: TextStyle(
                              color: Color.fromARGB(255, 233, 132, 39),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
