import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key, required this.userCallBack})
      : super(key: key);

  final Function(UserCredential) userCallBack;
  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final signupEmailController = TextEditingController();
  final signupPass1Controller = TextEditingController();
  final signupPass2Controller = TextEditingController();
  String? signupExceptionText;

  final loginEmailController = TextEditingController();
  final loginPass1Controller = TextEditingController();
  String? loginExceptionText;

  Future<void> SignUp() async {
    setState(() {
      signupExceptionText = null;
    });

    if (signupPass1Controller.text == signupPass2Controller.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: signupEmailController.text,
                password: signupPass1Controller.text);

        DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");

        await usersRef.set({
          userCredential.user?.uid: {
            "counts": {
              "breakfast": {
                "fruits_veggies": 0,
                "intense_exercise": 0,
                "moderate_exercise": 0,
                "processed": 0,
                "ultra_processed": 0,
                "whole": 0
              },
              "lunch": {
                "fruits_veggies": 0,
                "intense_exercise": 0,
                "moderate_exercise": 0,
                "processed": 0,
                "ultra_processed": 0,
                "whole": 0
              },
              "dinner": {
                "fruits_veggies": 0,
                "intense_exercise": 0,
                "moderate_exercise": 0,
                "processed": 0,
                "ultra_processed": 0,
                "whole": 0
              }
            }
          }
        });

        widget.userCallBack(userCredential);
      } on FirebaseAuthException catch (e) {
        setState(() {
          signupExceptionText = e.code;
        });
      }
    } else {
      setState(() {
        signupExceptionText = "Passwords must match";
      });
    }
  }

  Future<void> Login() async {
    setState(() {
      loginExceptionText = null;
    });

    if (loginEmailController.text != "" && loginPass1Controller.text != "") {
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: loginEmailController.text,
                password: loginPass1Controller.text);

        widget.userCallBack(userCredential);
      } on FirebaseAuthException catch (e) {
        setState(() {
          loginExceptionText = e.code;
        });
      }
    } else {
      setState(() {
        loginExceptionText = "Both fields must be filled";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
            ),
            body: Column(children: [
              TextField(
                controller: loginEmailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: loginPass1Controller,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              if (loginExceptionText != null) Text(loginExceptionText ?? ""),
              ElevatedButton(onPressed: Login, child: const Text('Login')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                  child: const Text("Sign Up"))
            ]),
          );
        },
        '/signUp': (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sign Up'),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  TextField(
                    controller: signupEmailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: signupPass1Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  TextField(
                    controller: signupPass2Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Re-type Password',
                    ),
                  ),
                  if (signupExceptionText != null)
                    Text(signupExceptionText ?? ""),
                  ElevatedButton(
                      onPressed: SignUp, child: const Text('Sign Up')),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
