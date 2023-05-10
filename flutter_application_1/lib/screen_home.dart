import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'etherscan_api.dart';
import 'screen_wallet.dart';
import 'screen_order.dart';
import 'screen_message.dart';

final eth = getEthereumPrice();
TextEditingController textController1 = TextEditingController();
TextEditingController textController2 = TextEditingController();
int? _choiceIndex1;
int? _choiceIndex2;
int _sizePickerIndex1 = 0;
int _sizePickerIndex2 = 0;
int _sizePickerIndex3 = 0;
double _weightPickerIndex = 0.0;

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
                const SizedBox(height: 10),
                const Row(children: [
                  Text('Details',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left)
                ]),
                const SizedBox(height: 40),
                const Row(children: [
                  Text('From',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
                ]),
                const SizedBox(height: 20),
                TextField(
                  maxLines: 1,
                  controller: textController1,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.pin_drop_outlined),
                      labelText: '  Enter Sender\'s address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(height: 19),
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
                const SizedBox(height: 20),
                const Row(children: [
                  Text('To',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
                ]),
                const SizedBox(height: 20),
                TextField(
                  maxLines: 1,
                  controller: textController2,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.flag),
                      labelText: '  Enter Receiver\'s address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 45),
                FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size(450, 60)),
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemInfoPage(
                                    title: 'Item Details',
                                    session: widget.session,
                                    connector: widget.connector)),
                          )
                        },
                    child: Text('Continue',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)))
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

class ItemInfoPage extends StatefulWidget {
  final String title;
  final session, connector;
  ItemInfoPage(
      {Key? key,
      required this.title,
      required this.session,
      required this.connector})
      : super(key: key);
  @override
  State<ItemInfoPage> createState() => _ItemInfoPageState();
}

class _ItemInfoPageState extends State<ItemInfoPage> {
  @override
  Widget build(BuildContext context) {
    final ethPrice = eth;

    calculateFee(width, height, depth, weight, ethPrice) async {
      double fee = await ethPrice;
      double deliveryFee = 0;
      //40 HKD for first 1kg, 15 HKD for each additional 1kg, then convert to ETH
      if (width * height * depth / 5000 > weight) {
        if (width * height * depth / 5000 < 1) {
          deliveryFee = 40 / fee;
        } else {
          deliveryFee = ((40 / (fee)) +
              (((width * height * depth / 5000) - 1) / 0.5).ceil() *
                  (7.5 / (fee)));
        }
      } else {
        if (weight < 1) {
          deliveryFee = 40 / fee;
        } else {
          deliveryFee =
              ((40 / (fee)) + ((weight - 1) / 0.5).ceil() * (7.5 / (fee)));
        }
      }
      return deliveryFee;
    }

    getETHPrice() async {
      double fee = 0;
      fee = await ethPrice;
      return fee;
    }

    convertFeeToHKD() async {
      double eth = await getETHPrice();
      double HKD = 0;
      HKD = await calculateFee(_sizePickerIndex1, _sizePickerIndex2,
              _sizePickerIndex3, _weightPickerIndex, eth) *
          eth;
      return HKD;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                const Row(children: [
                  Text('Dimension',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
                ]),
                SizedBox(
                  height: 10,
                ),
                const Row(children: [
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    'H    ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 72,
                  ),
                  Text(
                    'W  ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Text(
                    ' D',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberPicker(
                      value: _sizePickerIndex1,
                      minValue: 0,
                      maxValue: 300,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndex1 = value),
                    ),
                    Text(
                      'X',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    NumberPicker(
                      value: _sizePickerIndex2,
                      minValue: 0,
                      maxValue: 300,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndex2 = value),
                    ),
                    Text(
                      'X',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    NumberPicker(
                      value: _sizePickerIndex3,
                      minValue: 0,
                      maxValue: 300,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndex3 = value),
                    ),
                    Text('Cm',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text('Weight',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  DecimalNumberPicker(
                    value: _weightPickerIndex,
                    minValue: 0,
                    maxValue: 500,
                    onChanged: (value) =>
                        setState(() => _weightPickerIndex = value),
                  ),
                  Text('Kg',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Estimated Fee',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<dynamic>(
                        future: calculateFee(
                            _sizePickerIndex1,
                            _sizePickerIndex2,
                            _sizePickerIndex3,
                            _weightPickerIndex,
                            ethPrice),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            var price = snapshot.data;
                            return Text(
                              price.toStringAsFixed(8),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            );
                          } else {
                            return const Text(
                              '0',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            );
                          }
                        }),
                    Text(' ETH',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w700)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('≈',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<dynamic>(
                        future: convertFeeToHKD(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            var price = snapshot.data;
                            return Text(
                              price.toStringAsFixed(2),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600),
                            );
                          } else {
                            return const Text(
                              '0',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600),
                            );
                          }
                        }),
                    Text(' HKD',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBox(height: 40),
                FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size(400, 50)),
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                    title: 'Payment Details',
                                    session: widget.session,
                                    connector: widget.connector)),
                          )
                        },
                    child: Text('Next', style: TextStyle(fontSize: 18)))
              ],
            )));
  }
}

class PaymentPage extends StatefulWidget {
  final String title;
  final session, connector;
  PaymentPage(
      {Key? key,
      required this.title,
      required this.session,
      required this.connector})
      : super(key: key);
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Payment Page')])),
    );
  }
}
