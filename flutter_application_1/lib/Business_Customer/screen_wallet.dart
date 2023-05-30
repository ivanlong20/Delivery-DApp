import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Deliverymen/app_drawer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'screen_home.dart';
import 'screen_order.dart';
import 'screen_message.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';

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
      drawer: AppDrawer(connector: widget.connector),
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
}
