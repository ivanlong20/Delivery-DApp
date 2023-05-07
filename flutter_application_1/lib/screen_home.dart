import 'package:flutter/material.dart';
import 'etherscan_api.dart';
import 'screen_wallet.dart';
import 'screen_order.dart';
import 'screen_message.dart';

class HomePage extends StatefulWidget {
  final String title;
  final session, connector;
  HomePage(
      {Key? key,
      required this.title,
      required this.session,
      required this.connector})
      : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final address = widget.session.accounts[0].toString();

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
                      future: getBalance(address),
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
                title: Text('Ship'),
                onTap: openHomePage,
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Order Tracking & History'),
                onTap: openOrderPage
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Message'),
                onTap: openMessagePage
              ),
              ListTile(
                  leading: Icon(Icons.wallet),
                  title: Text('Wallet'),
                  onTap: openWalletPage),
            ],
          ),
        ),
        body: Center(child: Text('Home Page')));
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
              title: 'Ship',
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
}
