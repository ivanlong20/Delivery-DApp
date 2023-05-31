import 'package:flutter/material.dart';
import 'screen_home.dart';
import 'screen_order.dart';
import 'screen_wallet.dart';
import 'screen_message.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

class AppDrawer extends StatefulWidget {
  final connector;
  AppDrawer({Key? key, @required this.connector}) : super(key: key);
  @override
  _AppDrawerDrawerState createState() => _AppDrawerDrawerState();
}

class _AppDrawerDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
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
            title: const Text('Send Package'),
            onTap: openHomePage,
          ),
          ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Order Tracking & History'),
              onTap: openOrderPage),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              // onTap: openMessagePage
              ),
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
          builder: (context) =>
              HomePage(title: 'Ship', connector: widget.connector)),
    );
  }

  openOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderPage(
              title: 'Order Tracking & History', connector: widget.connector)),
    );
  }

  // openMessagePage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             MessagePage(title: 'Message', connector: widget.connector)),
  //   );
  // }

  logout() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserSelectionPage(title: 'Landing Page')),
    );
    await widget.connector.killSession();
  }
}
