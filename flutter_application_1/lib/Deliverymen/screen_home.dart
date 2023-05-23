import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen_accepted_order.dart';
import 'screen_message.dart';
import 'screen_wallet.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

class HomePage extends StatefulWidget {
  final String title;
  var connector;
  HomePage({super.key, required this.title, required this.connector});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
        body: AvailableOrderListView());
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

class AvailableOrderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              showOrderConfirmationDialog(context);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.circular(20)),
                height: 150,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Order #123456',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 170),
                            Text(
                              '13/4/2023',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sender\'s Address',
                                style: TextStyle(fontWeight: FontWeight.w600))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [FaIcon(FontAwesomeIcons.arrowDownLong)],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Receiver\'s Address',
                                style: TextStyle(fontWeight: FontWeight.w600))
                          ],
                        )
                      ],
                    ))));
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 20),
    );
  }

  Future<bool?> showOrderConfirmationDialog(context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Accept Order"),
          content: Text("Confirm to delivery the order",
              style: TextStyle(fontWeight: FontWeight.w600)),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text("Confirm", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
