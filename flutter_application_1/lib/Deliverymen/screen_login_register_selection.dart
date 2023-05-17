import 'package:flutter/material.dart';
import 'screen_login.dart';
import 'screen_register.dart';

class LoginRegisterSelectionPage extends StatelessWidget {
  const LoginRegisterSelectionPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 150),
            SizedBox(height: 150),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(350, 75),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage(title: 'Login');
                  }),
                );
              },
              child: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Login'),
            ),
            SizedBox(
              height: 30,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(350, 75),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const RegisterPage(title: 'Register');
                  }),
                );
              },
              child: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Register'),
            )
          ],
        ),
      ),
    );
  }
}
