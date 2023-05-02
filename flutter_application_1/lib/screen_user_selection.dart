import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';

class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 150),
            Align(
                alignment: Alignment.center,
                child: Text(
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    'Welcome')),
            SizedBox(height: 150),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(350, 75),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ConnectMetamaskPage(
                        title: 'Connect Your Crypto Wallet');
                  }),
                );
              },
              child: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Customer / Business'),
            ),
            SizedBox(
              height: 30,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(350, 75),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {},
              child: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Delivery Partner'),
            )
          ],
        ),
      ),
    );
  }
}
