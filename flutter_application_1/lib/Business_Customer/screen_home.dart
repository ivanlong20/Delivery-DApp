import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import '../etherscan_api.dart';
import 'screen_connect_metamask.dart';
import 'package:intl/intl.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'app_drawer.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

final eth = getEthereumPrice();
TextEditingController senderDeliveryAddress = TextEditingController();
TextEditingController recipientDeliveryAddress = TextEditingController();
int? senderDistrictIndex1;
int? recipientDistrictIndex2;
List<String> district = [
  'Hong Kong',
  'Kowloon',
  'Others',
  'New Territories',
  'Island District',
];
TextEditingController packageDescription = TextEditingController();

int _sizePickerIndexH = 0;
int _sizePickerIndexW = 0;
int _sizePickerIndexD = 0;
double _weightPickerIndex = 0.0;
TextEditingController receiverWalletAddress = TextEditingController();
int? paidBy;
TextEditingController productAmountinHKD = TextEditingController()..text = '0';

var priceSender, priceReceiver;

calculateFee(width, height, depth, weight, ethPrice) async {
  double fee = await ethPrice;
  double deliveryFee = 0;
  //40 HKD for first 1kg, 7.5 HKD for each additional 0.5kg, then convert to ETH
  if (width * height * depth / 150000 > weight) {
    if (width * height * depth / 150000 < 1) {
      deliveryFee = 40 / fee;
    } else {
      deliveryFee = ((40 / (fee)) +
          (((width * height * depth / 150000) - 1) / 0.5).ceil() *
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

getProductAmount() {
  return productAmountinHKD.text;
}

combineAllFee(deliveryFee, ethPrice) async {
  double eth = await ethPrice;
  double dFee = await deliveryFee;
  double pFee = 0;
  if (getProductAmount() != '') {
    pFee = double.parse(getProductAmount());
  } else {
    pFee = 0;
  }
  var fee = dFee + pFee / eth;
  return fee;
}

//Shipping Home Page

class HomePage extends StatefulWidget {
  final String title;
  var connector;
  HomePage({Key? key, required this.title, required this.connector})
      : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.title)),
        drawer: AppDrawer(connector: widget.connector),
        body: SingleChildScrollView(
            child: Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: [
                        const Row(children: [
                          Text('Shipping Details',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left)
                        ]),
                        const SizedBox(height: 10),
                        const Row(children: [
                          Text('From',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600))
                        ]),
                        const SizedBox(height: 5),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              senderDeliveryAddress.text = text;
                            });
                          },
                          maxLines: 1,
                          controller: senderDeliveryAddress,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.pin_drop_outlined),
                              labelText: '  Enter Sender\'s address',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        const SizedBox(height: 15),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                                spacing: 5,
                                children: List<Widget>.generate(5, (int index) {
                                  return ChoiceChip(
                                    label: Text(district[index]),
                                    selected: senderDistrictIndex1 == index,
                                    selectedColor:
                                        Color.fromARGB(255, 221, 221, 221),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        senderDistrictIndex1 =
                                            selected ? index : null;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  );
                                }))),
                        const SizedBox(height: 10),
                        const Row(children: [
                          Text('To',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600))
                        ]),
                        const SizedBox(height: 5),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              recipientDeliveryAddress.text = text;
                            });
                          },
                          maxLines: 1,
                          controller: recipientDeliveryAddress,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.flag),
                              labelText: '  Enter Receiver\'s address',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        const SizedBox(height: 15),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                                spacing: 5,
                                children: List<Widget>.generate(5, (int index) {
                                  return ChoiceChip(
                                    label: Text(district[index]),
                                    selected: recipientDistrictIndex2 == index,
                                    selectedColor:
                                        Color.fromARGB(255, 221, 221, 221),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        recipientDistrictIndex2 =
                                            selected ? index : null;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  );
                                }))),
                        SizedBox(
                          height: 20,
                        ),
                        const Row(children: [
                          Text('Package Information',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600))
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              packageDescription.text = text;
                            });
                          },
                          maxLines: 1,
                          controller: packageDescription,
                          decoration: InputDecoration(
                              icon: const FaIcon(FontAwesomeIcons.box),
                              labelText: 'What\'s in your package?',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        const SizedBox(height: 30),
                        FilledButton(
                            style: FilledButton.styleFrom(
                                minimumSize: Size(400, 50)),
                            onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemInfoPage(
                                            title: 'Item Details',
                                            connector: widget.connector)),
                                  )
                                },
                            child: Text('Continue',
                                style: TextStyle(fontSize: 18)))
                      ],
                    )))));
  }
}
//

//Item Information Page

class ItemInfoPage extends StatefulWidget {
  final String title;
  final connector;
  ItemInfoPage({Key? key, required this.title, required this.connector})
      : super(key: key);
  @override
  State<ItemInfoPage> createState() => _ItemInfoPageState();
}

class _ItemInfoPageState extends State<ItemInfoPage> {
  @override
  Widget build(BuildContext context) {
    final ethPrice = eth;

    convertFeeToHKD() async {
      double eth = await ethPrice;
      double HKD = 0;
      HKD = await calculateFee(_sizePickerIndexH, _sizePickerIndexW,
              _sizePickerIndexD, _weightPickerIndex, eth) *
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
                    'H   ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 72,
                  ),
                  Text(
                    ' W  ',
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
                      value: _sizePickerIndexH,
                      minValue: 0,
                      maxValue: 150,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndexH = value),
                    ),
                    Text(
                      'X',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    NumberPicker(
                      value: _sizePickerIndexW,
                      minValue: 0,
                      maxValue: 150,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndexW = value),
                    ),
                    Text(
                      'X',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    NumberPicker(
                      value: _sizePickerIndexD,
                      minValue: 0,
                      maxValue: 150,
                      onChanged: (value) =>
                          setState(() => _sizePickerIndexD = value),
                    ),
                    Text('Cm',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600))
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
                    maxValue: 50,
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
                            _sizePickerIndexH,
                            _sizePickerIndexW,
                            _sizePickerIndexD,
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
                const SizedBox(height: 30),
                FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size(400, 50)),
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                    title: 'Payment Details',
                                    connector: widget.connector)),
                          )
                        },
                    child: Text('Next', style: TextStyle(fontSize: 18)))
              ],
            )));
  }
}

//

//Payment Page

class PaymentPage extends StatefulWidget {
  final String title;
  final connector;
  PaymentPage({Key? key, required this.title, required this.connector})
      : super(key: key);
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ethPrice = eth;
  List<String> payerList = ['Sender', 'Receiver'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  children: [
                    Text('Receiver\'s Wallet Address',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(42),
                  ],
                  onChanged: (text) {
                    setState(() {
                      receiverWalletAddress.text = text;
                    });
                  },
                  maxLines: 1,
                  controller: receiverWalletAddress,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.wallet),
                      labelText:
                          'i.e. 0x999999cf1046e68e36E1aA2E0E07105eDDD1f08E',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                      onPressed: () {
                        BarcodeScanner.scan().then((value) {
                          setState(() {
                            receiverWalletAddress.text =
                                value.rawContent.substring(9);
                          });
                        });
                      },
                      child: Text('Scan with QR code')),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Paid By',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                        spacing: 5,
                        children: List<Widget>.generate(2, (int index) {
                          return ChoiceChip(
                            label: Text(payerList[index]),
                            selected: paidBy == index,
                            selectedColor: Color.fromARGB(255, 221, 221, 221),
                            onSelected: (bool selected) {
                              setState(() {
                                paidBy = selected ? index : null;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          );
                        }))),
                const SizedBox(height: 20),
                (paidBy == 1)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('Additional Product Amount',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            onChanged: (text) {
                              setState(() {
                                productAmountinHKD.text = text;
                              });
                            },
                            maxLines: 1,
                            controller: productAmountinHKD,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.attach_money),
                                labelText: ' HKD',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FutureBuilder<dynamic>(
                                  future: combineAllFee(
                                      calculateFee(
                                          _sizePickerIndexH,
                                          _sizePickerIndexW,
                                          _sizePickerIndexD,
                                          _weightPickerIndex,
                                          ethPrice),
                                      ethPrice),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      priceReceiver = snapshot.data;
                                      return Text(
                                        priceReceiver.toStringAsFixed(8),
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
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 40),
                          FilledButton(
                              style: FilledButton.styleFrom(
                                  minimumSize: Size(400, 50)),
                              onPressed: () => {transaction()},
                              child: Text('Confirm',
                                  style: TextStyle(fontSize: 18)))
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FutureBuilder<dynamic>(
                                  future: calculateFee(
                                      _sizePickerIndexH,
                                      _sizePickerIndexW,
                                      _sizePickerIndexD,
                                      _weightPickerIndex,
                                      ethPrice),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      priceSender = snapshot.data;
                                      return Text(
                                        priceSender.toStringAsFixed(8),
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
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 40),
                          FilledButton(
                              style: FilledButton.styleFrom(
                                  minimumSize: Size(400, 50)),
                              onPressed: () => {transaction()},
                              child: Text('Confirm',
                                  style: TextStyle(fontSize: 18)))
                        ],
                      )
              ])),
        )));
  }

  transaction() async {
    print(productAmountinHKD.text);
    Future.delayed(Duration.zero, () => widget.connector.openWalletApp());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );
    await connector
        .callCreateDeliveryOrder(
            receiverWalletAddress: receiverWalletAddress.text,
            senderAddress: senderDeliveryAddress.text,
            senderDistrict: district[senderDistrictIndex1!],
            receiverAddress: recipientDeliveryAddress.text,
            receiverDistrict: district[recipientDistrictIndex2!],
            packageDiscription: packageDescription.text,
            packageHeight: BigInt.from(_sizePickerIndexH),
            packageWidth: BigInt.from(_sizePickerIndexW),
            packageDepth: BigInt.from(_sizePickerIndexD),
            packageWeight: BigInt.from(_sizePickerIndexW * 1000),
            payBySender: (paidBy == 0) ? true : false,
            deliveryFee: BigInt.from(priceSender * 1e18),
            productAmount: BigInt.from(double.parse(productAmountinHKD.text) *
                (await ethPrice) *
                1e18))
        .then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentConfirmationPage(
                          title: 'Order Confirmation',
                          orderID: value[0],
                          date: value[1],
                          connector: widget.connector,
                        )),
              )
            });
  }
}

class PaymentConfirmationPage extends StatefulWidget {
  final String title;
  final BigInt orderID;
  final DateTime date;
  final connector;
  PaymentConfirmationPage(
      {Key? key,
      required this.title,
      required this.orderID,
      required this.date,
      required this.connector})
      : super(key: key);

  @override
  State<PaymentConfirmationPage> createState() =>
      _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order ID: #' + widget.orderID.toString(),
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text('Time: ' + DateFormat('dd/MM/yyyy HH:mm').format(widget.date),
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            (paidBy == 0)
                ? Column(children: [
                    Text('Status: Submitted',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 40),
                    FilledButton(
                        style:
                            FilledButton.styleFrom(minimumSize: Size(350, 50)),
                        onPressed: () => {payBySender()},
                        child: Text('Pay Now', style: TextStyle(fontSize: 18)))
                  ])
                : Column(children: [
                    Text('Status: Submitted, Pending to Pay by Recipent',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 40),
                    FilledButton(
                        style:
                            FilledButton.styleFrom(minimumSize: Size(350, 50)),
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        title: 'Ship', connector: connector)),
                              )
                            },
                        child: Text('Return', style: TextStyle(fontSize: 18)))
                  ])
          ],
        )));
  }

  payBySender() async {
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );

    await connector.payBySender(
        orderID: widget.orderID, deliveryFee: BigInt.from(priceSender * 1e18));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Payment Successful')));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(title: 'Ship', connector: connector),
        ));
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 0, 0),
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 50),
                    Text('Waiting for Completion',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.w500))
                  ],
                ))));
  }
}

//
