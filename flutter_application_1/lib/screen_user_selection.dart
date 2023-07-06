import 'package:flutter/material.dart';
import 'Business_Customer/screen_connect_metamask.dart';
import 'Deliverymen/screen_login_register_selection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ethereum_connector.dart';

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
            SizedBox(height: 200),
            Align(
                alignment: Alignment.center,
                child: Text(
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    'Welcome')),
            SizedBox(height: 75),
            FilledButton.icon(
              icon: FaIcon(FontAwesomeIcons.user),
              label: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  ' User'),
              style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  minimumSize: Size(350, 100)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ConnectMetamaskPage(
                        title: 'Connect Your Wallet');
                  }),
                );
              },
            ),
            SizedBox(
              height: 40,
            ),
            FilledButton.icon(
              icon: FaIcon(FontAwesomeIcons.truckFast),
              label: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  ' Delivery Partner'),
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  minimumSize: Size(350, 100)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginRegisterSelectionPage(
                        title: 'Login / Register');
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
