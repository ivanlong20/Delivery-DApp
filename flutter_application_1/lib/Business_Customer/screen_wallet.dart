import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:etherscan_api/etherscan_api.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'screen_home.dart';
import 'screen_order.dart';
import 'screen_message.dart';
import '../etherscan_api.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';

final finalBalance = getBalance(getAddress());

class WalletPage extends StatefulWidget {
  final String title;
  var session, connector;
  WalletPage(
      {Key? key,
      required this.title,
      required this.session,
      required this.connector})
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
              Row(children: [
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
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      } else {
                        return Text(
                          '0',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      }
                    }),
                Text(' ETH',
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
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ))
                ],
              )
            ])),
            ListTile(
              leading: Icon(Icons.local_shipping_rounded),
              title: Text('Send Package'),
              onTap: openHomePage,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Order Tracking & History'),
              onTap: openOrderPage,
            ),
            ListTile(
                leading: Icon(Icons.message),
                title: Text('Message'),
                onTap: openMessagePage),
            ListTile(
                leading: Icon(Icons.wallet),
                title: Text('Wallet'),
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
                      var balance =
                          int.parse(snapshot.data) * (1 / 1000000000000000000);
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
              Text(
                  widget.connector.connected
                      ? getNetworkName(widget.session.chainId)
                      : 'Not Connected',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  )),
            ]),
            SizedBox(
              height: 30,
            ),
            QrImageView(
              data: getAddress(),
              version: QrVersions.auto,
              size: 300.0,
            ),
            SizedBox(
              height: 30,
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
                          getAddress(),
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
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                            ClipboardData(text: getAddress().toString()))
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
          builder: (context) => WalletPage(
              title: 'Wallet',
              session: widget.session,
              connector: widget.connector)),
    );
  }

  openHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
              title: 'Send Package',
              session: widget.session,
              connector: widget.connector)),
    );
  }

  openOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderPage(
              title: 'Order Tracking & History',
              session: widget.session,
              connector: widget.connector)),
    );
  }

  openMessagePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessagePage(
              title: 'Message',
              session: widget.session,
              connector: widget.connector)),
    );
  }

  logout() {
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
