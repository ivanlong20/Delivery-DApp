import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen_connect_metamask.dart';

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Padding(
                padding:  const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome back!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 100),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          email.text = text;
                        });
                      },
                      maxLines: 1,
                      controller: email,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.email),
                          labelText: '  Email address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      onChanged: (text) {
                        setState(() {
                          password.text = text;
                        });
                      },
                      maxLines: 1,
                      controller: password,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.password),
                          labelText: '  Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(height: 60),
                    FilledButton(
                        style:
                            FilledButton.styleFrom(minimumSize: Size(400, 50)),
                        onPressed: () async =>
                            {await firebaseLogin(email.text, password.text)},
                        child:
                            const Text('Login', style: TextStyle(fontSize: 18)))
                  ],
                ))));
  }

  Future<bool?> showInvalidLoginDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  const Text("Invalid Login"),
          content:  const Text("Wrong email or password",
              style: TextStyle(fontWeight: FontWeight.w600)),
          actions: <Widget>[
            TextButton(
              child:  const Text("Confirm"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  firebaseLogin(email, password) async {
    bool login = false;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      login = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        login = false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        login = false;
      }
    }
    (login == true)
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ConnectMetamaskPage(title: 'Connect Your Wallet'),
            ))
        : showInvalidLoginDialog();
  }
}
