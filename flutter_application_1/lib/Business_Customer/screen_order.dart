import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_home.dart';
import 'screen_wallet.dart';
import 'screen_message.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';
import 'package:intl/intl.dart';

var OrderState = [
  'Submitted',
  'Pending',
  'Picking Up',
  'Delivering',
  'Delivered',
  'Canceled'
];

final finalBalance = connector.getBalance();
final network = connector.networkName;

getOrderCount() async {
  final allOrders = await connector.getOrderFromBusinessAndCustomer();
  final allOrder = List.from(await allOrders);
  return allOrder.length;
}

Future<List<dynamic>> getOrderInfo() async {
  final allOrders = await connector.getOrderFromBusinessAndCustomer();
  var senderAddress = [];
  var senderDistrict = [];
  var receiverAddress = [];
  var receiverDistrict = [];
  var packageDescription = [];
  var packageHeight = [];
  var packageWidth = [];
  var packageDepth = [];
  var packageWeight = [];
  var paidBySender = [];
  var deliveryFee = [];
  var productAmount = [];
  var totalAmount = [];
  var orderStatus = [];
  var orderDate = [];

  var orders = List.from(await allOrders);
  var orderCount = orders.length;

  for (int i = 0; i < orderCount; i++) {
    senderAddress.add(orders[i][1][0]);
    senderDistrict.add(orders[i][1][1]);
    receiverAddress.add(orders[i][1][2]);
    receiverDistrict.add(orders[i][1][3]);
    packageDescription.add(orders[i][2][0]);
    packageHeight.add(orders[i][2][1]);
    packageWidth.add(orders[i][2][2]);
    packageDepth.add(orders[i][2][3]);
    packageWeight.add(orders[i][2][4].toDouble() * 1000);
    paidBySender.add(orders[i][3][0]);
    deliveryFee.add(orders[i][3][1].toDouble() * (1 / 1e18));
    productAmount.add(orders[i][3][2]);
    totalAmount.add(orders[i][3][3].toDouble() * (1 / 1e18));
    orderStatus.add(orders[i][4]);
    orderDate
        .add(DateTime.fromMillisecondsSinceEpoch(orders[i][5].toInt() * 1000));
  }
  print(totalAmount);
  return [
    senderAddress,
    senderDistrict,
    receiverAddress,
    receiverDistrict,
    packageDescription,
    packageHeight,
    packageWidth,
    packageDepth,
    packageWeight,
    paidBySender,
    deliveryFee,
    productAmount,
    totalAmount,
    orderStatus,
    orderDate
  ];
}

// fetch() async {
//   var order = await connector.getOrderFromBusinessAndCustomer();
//   print(order[0][0][0]);
//   print(order[0][1]);
//   print(order[0][2]);
//   print(order[0][3]);
//   print(order[0][4]);
//   print(order[0][5]);
//   return order;
// }

class OrderPage extends StatefulWidget {
  final String title;
  var connector;
  OrderPage({Key? key, required this.title, required this.connector})
      : super(key: key);
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
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
              onTap: openMessagePage,
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
      ),
      body: TransactionListView(),
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
              HomePage(title: 'Send Package', connector: widget.connector)),
    );
  }

  openOrderPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderPage(
              title: 'Order Tracking & History', connector: widget.connector)),
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
    await widget.connector.killSession();
  }
}

class TransactionListView extends StatelessWidget {
  const TransactionListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getOrderCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderCount = snapshot.data;
          return FutureBuilder(
              future: getOrderInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var orderDate = snapshot.data?[14];
                  var senderAddress = snapshot.data?[0];
                  var senderDistrict = snapshot.data?[1];
                  var receiverAddress = snapshot.data?[2];
                  var receiverDistrict = snapshot.data?[3];
                  var orderStatus = snapshot.data?[11];
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: orderCount,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            enterTransactionDetailsPage(index, context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 150,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 5, 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Order #123456',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(width: 120),
                                          Text(
                                            DateFormat('dd/MM/yyyy HH:mm')
                                                .format(orderDate[index]),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              senderAddress[index] +
                                                  ", " +
                                                  senderDistrict[index],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.arrowDownLong)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              receiverAddress[index] +
                                                  ", " +
                                                  receiverDistrict[index],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Status: ' +
                                                OrderState[
                                                    orderStatus[index].toInt()],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          )
                                        ],
                                      )
                                    ],
                                  ))));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 20),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 0, 0),
                        strokeWidth: 4,
                      ),
                    ],
                  );
                }
              });
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0),
                strokeWidth: 4,
              ),
            ],
          );
        }
      },
    );
  }

  enterTransactionDetailsPage(index, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TransactionDetailsPage(title: 'Details', index: index)),
    );
  }
}

class TransactionDetailsPage extends StatefulWidget {
  final String title;
  final index;
  TransactionDetailsPage({Key? key, required this.title, required this.index})
      : super(key: key);
  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var index = widget.index;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Order #123456',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(children: [
                  Text('Date: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('13/4/2023',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('From',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('Address',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('To',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('Address',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Amount',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('0.2' + ' ETH',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Parcel Information',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                            'Contents: ' +
                                'Mobile Phone, Documents, Clothes, Shoes, etc.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                            'Size: ' + 'w' + ' x ' + 'h' + ' x ' + 'l' + ' cm',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('Weight: ' + '10.5' + ' Kg',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('Status',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('Pending',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text('Parcel Location',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)))
                  ],
                ),
                Text(index.toString()),
              ],
            )));
  }
}
