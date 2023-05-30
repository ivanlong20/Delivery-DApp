import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'screen_connect_metamask.dart';
import 'package:intl/intl.dart';
import 'app_drawer.dart';
import 'screen_message.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

var OrderState = [
  'Submitted',
  'Pending',
  'Picking Up',
  'Delivering',
  'Delivered',
  'Canceled'
];

getOrderCount() async {
  final allOrders = await connector.getDeliverymanOrder();
  final allOrder = List.from(await allOrders);
  Future.delayed(Duration(seconds: 3));
  return allOrder.length;
}

Future<List<dynamic>> getOrderInfo() async {
  final allOrders = await connector.getDeliverymanOrder();
  var id = [];
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
  var senderwalletAddress = [];
  var recipientwalletAddress = [];

  var orders = List.from(await allOrders);
  var orderCount = orders.length;

  for (int i = 0; i < orderCount; i++) {
    id.add(orders[i][0]);
    senderAddress.add(orders[i][2][0]);
    senderDistrict.add(orders[i][2][1]);
    receiverAddress.add(orders[i][2][2]);
    receiverDistrict.add(orders[i][2][3]);
    packageDescription.add(orders[i][3][0]);
    packageHeight.add(orders[i][3][1]);
    packageWidth.add(orders[i][3][2]);
    packageDepth.add(orders[i][3][3]);
    packageWeight.add(orders[i][3][4].toDouble() / 1000);
    paidBySender.add(orders[i][4][0]);
    deliveryFee.add(orders[i][4][1].toDouble() * (1 / 1e18));
    productAmount.add(orders[i][4][2].toDouble() * (1 / 1e18));
    totalAmount.add(orders[i][4][3].toDouble() * (1 / 1e18));
    orderStatus.add(orders[i][5]);
    orderDate
        .add(DateTime.fromMillisecondsSinceEpoch(orders[i][6].toInt() * 1000));
    senderwalletAddress.add(orders[i][1][0]);
    recipientwalletAddress.add(orders[i][1][1]);
  }
  print(totalAmount);
  return [
    id,
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
    orderDate,
    senderwalletAddress,
    recipientwalletAddress
  ];
}

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
      drawer: AppDrawer(connector: widget.connector),
      body: TransactionListView(),
    );
  }
}

class TransactionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<dynamic>(
      future: getOrderCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderCount = snapshot.data;
          return FutureBuilder(
              future: getOrderInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var id = snapshot.data?[0];
                  var senderWalletAddress = snapshot.data?[16];
                  var recipientWalletAddress = snapshot.data?[17];
                  var orderDate = snapshot.data?[15];
                  var senderAddress = snapshot.data?[1];
                  var senderDistrict = snapshot.data?[2];
                  var receiverAddress = snapshot.data?[3];
                  var receiverDistrict = snapshot.data?[4];
                  var orderStatus = snapshot.data?[14];
                  var deliveryFee = snapshot.data?[11];
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: orderCount,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransactionDetailsPage(
                                      title: 'Details',
                                      index: index,
                                      connector: connector,
                                      orderID: id[index],
                                      sender: senderWalletAddress,
                                      receiver: recipientWalletAddress)),
                            );
                            // fetch();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 180,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          flex: 15,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Order #' +
                                                    id[index].toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(width: 100),
                                              Text(
                                                DateFormat('dd/MM/yyyy HH:mm')
                                                    .format(orderDate[index]),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                          flex: 30,
                                          child: Center(
                                              child: Text(
                                            senderAddress[index] +
                                                ", " +
                                                senderDistrict[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ))),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Expanded(
                                          flex: 15,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(FontAwesomeIcons
                                                  .arrowDownLong)
                                            ],
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                          flex: 30,
                                          child: Center(
                                              child: Text(
                                            receiverAddress[index] +
                                                ", " +
                                                receiverDistrict[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: Row(children: [
                                          Text(
                                            'Status: ' +
                                                OrderState[
                                                    orderStatus[index].toInt()],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Expanded(
                                              flex: 15,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Amount: ' +
                                                        deliveryFee[index]
                                                            .toStringAsFixed(
                                                                6) +
                                                        ' ETH',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ],
                                              ))
                                        ]),
                                      ),
                                    ],
                                  ))));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 20),
                  );
                } else if (snapshot.hasError) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Orders Available",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please check again later",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ]);
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
        } else if (snapshot.hasError) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "No Orders Available",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please check again later",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ]);
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
    ));
  }
}

class TransactionDetailsPage extends StatefulWidget {
  final String title;
  final index;
  var connector, orderID, sender, receiver;
  TransactionDetailsPage(
      {Key? key,
      required this.title,
      required this.index,
      required this.connector,
      required this.orderID,
      required this.sender,
      required this.receiver})
      : super(key: key);
  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var index = widget.index;
    return Scaffold(
        floatingActionButton: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: FaIcon(FontAwesomeIcons.route),
                ),
                SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            title: 'Messages',
                            connector: widget.connector,
                            orderID: widget.orderID,
                            orderSender: widget.sender,
                            orderReceiver: widget.receiver,
                          ),
                        ));
                  },
                  child: Icon(Icons.message),
                ),
                SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: FaIcon(FontAwesomeIcons.checkCircle),
                )
              ],
            )),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: FutureBuilder(
                    future: getOrderInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var id = snapshot.data?[0];
                        var orderDate = snapshot.data?[15];
                        var senderAddress = snapshot.data?[1];
                        var senderDistrict = snapshot.data?[2];
                        var receiverAddress = snapshot.data?[3];
                        var receiverDistrict = snapshot.data?[4];
                        var parcelDescription = snapshot.data?[5];
                        var parcelWidth = snapshot.data?[6];
                        var parcelHeight = snapshot.data?[7];
                        var parcelDepth = snapshot.data?[8];
                        var parcelWeight = snapshot.data?[9];
                        var orderStatus = snapshot.data?[14];
                        var payBySender = snapshot.data?[10];
                        var deliveryFee = snapshot.data?[11];
                        print(snapshot.data?[14]);
                        return Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Order #' + id[index].toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 75),
                                    Text(
                                        DateFormat('dd/MM/yyyy HH:mm')
                                            .format(orderDate[index]),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(children: [
                                  Text(
                                    'Payment: ' +
                                        (payBySender[index] == true
                                            ? 'Sender'
                                            : 'Receiver'),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )
                                ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('From',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            senderAddress[index] +
                                                ", " +
                                                senderDistrict[index],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('To',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            receiverAddress[index] +
                                                ", " +
                                                receiverDistrict[index],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('Delivery Fee',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            deliveryFee[index]
                                                    .toStringAsFixed(10) +
                                                ' ETH',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('Parcel Information',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            'Description : ' +
                                                parcelDescription[index],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            'Size: ' +
                                                parcelWidth[index].toString() +
                                                ' x ' +
                                                parcelHeight[index].toString() +
                                                ' x ' +
                                                parcelDepth[index].toString() +
                                                ' cm',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            'Weight: ' +
                                                parcelWeight[index].toString() +
                                                ' Kg',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            OrderState[
                                                orderStatus[index].toInt()],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)))
                                  ],
                                )
                              ],
                            ));
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
                    }))));
  }
}
