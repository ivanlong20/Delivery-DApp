import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'screen_home.dart';
import 'screen_accepted_order.dart';
import 'screen_message.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

class WalletPage extends StatefulWidget {
  final String title;
  var connector;
  WalletPage({Key? key, required this.title, required this.connector})
      : super(key: key);
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
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
                        var balance = snapshot.data;
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
                  Text(network,
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
              onTap: openHomePage,
            ),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.solidCircleCheck),
                title: const Text('Acctepted Orders'),
                onTap: openOrderPage),
            ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Message'),
                onTap: openMessagePage),
            ListTile(
                leading: const Icon(Icons.wallet),
                title: const Text('Wallet'),
                onTap: openWalletPage),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: logout)
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Your Balance',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              FutureBuilder<dynamic>(
                  future: finalBalance,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      var balance = snapshot.data;
                      return Text(
                        balance.toStringAsFixed(10),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                            fontWeight: FontWeight.w600),
                      );
                    } else {
                      return const Text(
                        '0',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                            fontWeight: FontWeight.w600),
                      );
                    }
                  }),
              const Text(' ETH',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ))
            ]),
            SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Network',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )
            ]),
            SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(network,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  )),
            ]),
            SizedBox(
              height: 30,
            ),
            QrImageView(
              data: widget.connector.address,
              version: QrVersions.auto,
              size: 300.0,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 3.0,
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet Address',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Text(
                          widget.connector.address,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text: widget.connector.address.toString()))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Wallet Address copied to clipboard")));
                    });
                  },
                  icon: Icon(
                    Icons.copy,
                    size: 24.0,
                  ),
                  label: Text('Copy Address'), // <-- Text
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  openWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              WalletPage(title: 'Wallet', connector: widget.connector)),
    );
  }

  openHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
              title: 'View Available Orders', connector: widget.connector)),
    );
  }

  openOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderPage(title: 'Accepted Orders', connector: widget.connector)),
    );
  }

  openMessagePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MessagePage(title: 'Message', connector: widget.connector)),
    );
  }

  logout() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserSelectionPage(title: 'Landing Page')),
    );
    await FirebaseAuth.instance.signOut();
    await widget.connector.killSession();
  }
}
