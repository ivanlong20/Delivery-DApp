import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_connect_metamask.dart';
import 'package:firebase_auth/firebase_auth.dart';


TextEditingController HKID = TextEditingController();
TextEditingController licenseplateNo = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your HKID',
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      email.text = text;
                    });
                  },
                  maxLines: 1,
                  controller: email,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.perm_identity),
                      labelText: '  HKID',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your License Plate',
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      email.text = text;
                    });
                  },
                  maxLines: 1,
                  controller: email,
                  decoration: InputDecoration(
                      icon: const FaIcon(FontAwesomeIcons.car),
                      labelText: '  License plate number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your email address',
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'New Password',
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(height: 10),
                TextField(
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
                SizedBox(height: 40),
                FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size(400, 50)),
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectMetamaskPage(
                                    title: 'Connect Your Crypto Wallet')),
                          )
                        },
                    child: Text('Continue', style: TextStyle(fontSize: 18)))
              ],
            )));
  }
}
