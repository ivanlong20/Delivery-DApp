import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import '../etherscan_api.dart';
import '../screen_user_selection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

final finalBalance = getBalance(getAddress());

class HomePage extends StatefulWidget {
  final String title;
  var connector, session;
  HomePage(
      {super.key,
      required this.title,
      required this.connector,
      required this.session});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Column(children: [
              const Row(children: [
                Text(
                  'Balance',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                )
              ]),
              Row(children: [
                FutureBuilder<dynamic>(
                    future: finalBalance,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        var balance = int.parse(snapshot.data) *
                            (1 / 1000000000000000000);
                        return Text(
                          balance.toStringAsFixed(5),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      } else {
                        return const Text(
                          '0',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      }
                    }),
                const Text(' ETH',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ))
              ]),
              Row(
                children: [
                  Text(
                      widget.connector.connected
                          ? getNetworkName(widget.session.chainId)
                          : 'Not Connected',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ))
                ],
              )
            ])),
            ListTile(
              leading: const Icon(Icons.local_shipping_rounded),
              title: const Text('View Available Orders'),
              // onTap: openHomePage,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.solidCircleCheck),
              title: const Text('Acctepted Orders'),
              // onTap: openOrderPage
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              // onTap: openMessagePage
            ),
            ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text('Wallet'),
              // onTap: openWalletPage
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: logout)
          ],
        ),
      ),
    );
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    widget.connector.on(
        'disconnect',
        (payload) => setState(() {
              widget.session = null;
            }));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserSelectionPage(title: 'Landing Page')),
    );
  }
}
