import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_connect_metamask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController Name = TextEditingController();
TextEditingController HKID = TextEditingController();
TextEditingController licenseplateNo = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
            child: Container(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Your Name',
                              style: TextStyle(fontSize: 18),
                            )),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              Name.text = text;
                            });
                          },
                          maxLines: 1,
                          controller: Name,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.perm_identity),
                              labelText: '  Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
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
                              HKID.text = text;
                            });
                          },
                          maxLines: 1,
                          controller: HKID,
                          decoration: InputDecoration(
                              icon: const FaIcon(FontAwesomeIcons.idCard),
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
                              licenseplateNo.text = text;
                            });
                          },
                          maxLines: 1,
                          controller: licenseplateNo,
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
                        SizedBox(height: 10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Confirm New Password',
                              style: TextStyle(fontSize: 18),
                            )),
                        SizedBox(height: 10),
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
                              labelText: '  Re-enter Your New Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        SizedBox(height: 40),
                        FilledButton(
                            style: FilledButton.styleFrom(
                                minimumSize: Size(400, 50)),
                            onPressed: () => {
                                  register(email.text, password.text, Name.text,
                                      HKID.text, licenseplateNo.text)
                                },
                            child: Text('Continue',
                                style: TextStyle(fontSize: 18)))
                      ],
                    )))));
  }

  Future<bool?> showInvalidRegisterDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Invalid Register"),
          content: Text("Invliad Information, Please Try Again.",
              style: TextStyle(fontWeight: FontWeight.w600)),
          actions: <Widget>[
            TextButton(
              child: Text("Confirm"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  register(email, password, name, HKID, LicensePlateNo) async {
    bool register = false;
    //register user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      register = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        register = false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        register = false;
      }
    } catch (e) {
      print(e);
      register = false;
    }
    //if register success, add user info to firestore
    if (register) {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
      }

      FirebaseFirestore db = FirebaseFirestore.instance;

      final user_info = {
        "HKID": HKID,
        "LicensePlateNo": LicensePlateNo,
        "uid": user!.uid,
      };

      db.collection("user_info").add(user_info).then((documentSnapshot) =>
          print("Added Data with ID: ${documentSnapshot.id}"));
      //direct to connect metamask page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConnectMetamaskPage(title: 'Connect Your Wallet')),
      );
    } else {
      showInvalidRegisterDialog();
    }
  }
}
