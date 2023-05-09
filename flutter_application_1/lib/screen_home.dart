import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
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
  TextEditingController textController = TextEditingController();
  int? _choiceIndex1;
  int? _choiceIndex2;
  int _sizePickerIndex1 = 0;
  int _sizePickerIndex2 = 0;
  int _sizePickerIndex3 = 0;
  int _weightPickerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final address = widget.session.accounts[0].toString();
    List<String> district = [
      'Hong Kong',
      'Kowloon',
      'Others',
      'New Territories',
      'Island District',
    ];

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
                      future: getBalance(address),
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
                title: const Text('Ship'),
                onTap: openHomePage,
              ),
              ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Order Tracking & History'),
                  onTap: openOrderPage),
              ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Message'),
                  onTap: openMessagePage),
              ListTile(
                  leading: const Icon(Icons.wallet),
                  title: const Text('Wallet'),
                  onTap: openWalletPage),
            ],
          ),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                Row(children: [
                  Text('Addresses',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left)
                ]),
                SizedBox(height: 20),
                Row(children: [
                  Text('From',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
                ]),
                SizedBox(height: 10),
                TextField(
                  maxLines: 1,
                  controller: textController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.pin_drop_outlined),
                      labelText: '  Enter Sender\'s address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                        spacing: 5,
                        children: List<Widget>.generate(5, (int index) {
                          return ChoiceChip(
                            label: Text(district[index]),
                            selected: _choiceIndex1 == index,
                            selectedColor: Color.fromARGB(255, 221, 221, 221),
                            onSelected: (bool selected) {
                              setState(() {
                                _choiceIndex1 = selected ? index : null;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          );
                        }))),
                SizedBox(height: 20),
                Row(children: [
                  Text('To',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
                ]),
                SizedBox(height: 10),
                TextField(
                  maxLines: 1,
                  controller: textController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.pin_drop_outlined),
                      labelText: '  Enter Receiver\'s address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                        spacing: 5,
                        children: List<Widget>.generate(5, (int index) {
                          return ChoiceChip(
                            label: Text(district[index]),
                            selected: _choiceIndex2 == index,
                            selectedColor: Color.fromARGB(255, 221, 221, 221),
                            onSelected: (bool selected) {
                              setState(() {
                                _choiceIndex2 = selected ? index : null;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          );
                        }))),
                SizedBox(height: 10),
                Row(children: [
                  Text('Item Details',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left)
                ]),
                Row(children: [
                  Text('Size',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
                ]),
                Row(
                  children: [
                    NumberPicker(
                      value: _sizePickerIndex1,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndex1 = value),
                    ),
                    NumberPicker(
                      value: _sizePickerIndex2,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndex2 = value),
                    ),
                    NumberPicker(
                      value: _sizePickerIndex3,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndex3 = value),
                    )
                  ],
                ),
                Row(children: [
                  Text('Weight',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
                ]),
                Row(
                  children: [],
                )
              ],
            )));
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
