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
            const SizedBox(height: 150),
            const SizedBox(height: 150),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const  Size(350, 75),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage(title: 'Login');
                  }),
                );
              },
              child: const Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Login'),
            ),
            const SizedBox(
              height: 30,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize:  const Size(350, 75),
                  backgroundColor:  const Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const RegisterPage(title: 'Register');
                  }),
                );
              },
              child: const Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Register'),
            )
          ],
        ),
      ),
    );
  }
}
