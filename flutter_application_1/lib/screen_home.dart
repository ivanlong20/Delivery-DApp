import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title, walletAddress, blockchainNetwork;
  HomePage(
      {Key? key,
      required this.title,
      required this.walletAddress,
      required this.blockchainNetwork})
      : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        drawer: Drawer(
          child: ListView(
            // padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  // ),
                  child: Wrap(children: [
                Text('Account', style: TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  widget.walletAddress,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                  ),
                ),
                Text(widget.blockchainNetwork,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                    ))
              ])),
              ListTile(
                leading: Icon(Icons.local_shipping_rounded),
                title: Text('Ship'),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Order Tracking & History'),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Message'),
              ),
              ListTile(
                leading: Icon(Icons.wallet),
                title: Text('Wallet'),
              ),
            ],
          ),
        ),
        body: Center(child: Text('Home Page')));
  }
}
