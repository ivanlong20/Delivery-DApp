import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_home.dart';
import 'screen_message.dart';
import 'screen_connect_metamask.dart';
import 'package:intl/intl.dart';
import 'app_drawer.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

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
  final allOrders = await connector.getOrderFromBusinessAndCustomer();
  final allOrder = List.from(await allOrders);
  Future.delayed(Duration(seconds: 3));
  return allOrder.length;
}

Future<List<dynamic>> getOrderInfo() async {
  final allOrders = await connector.getOrderFromBusinessAndCustomer();
  print(allOrders);
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
  var deliverymanWalletAddress = [];
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
    deliverymanWalletAddress.add(orders[i][1][2]);
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
    recipientwalletAddress,
    deliverymanWalletAddress
  ];
}

fetch() async {
  var order = await connector.getOrderFromBusinessAndCustomer();
  // print(order[0][0][0]);
  // print(order[0][1]);
  // print(order[0][2]);
  // print(order[0][3]);
  // print(order[0][4]);
  // print(order[0][5]);
  print(order.length);
  // return order;
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
  const TransactionListView({Key? key}) : super(key: key);
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
                  var orderDate = snapshot.data?[15];
                  var senderAddress = snapshot.data?[1];
                  var senderDistrict = snapshot.data?[2];
                  var receiverAddress = snapshot.data?[3];
                  var receiverDistrict = snapshot.data?[4];
                  var orderStatus = snapshot.data?[14];
                  var senderWalletAddress = snapshot.data?[16];
                  var recipientWalletAddress = snapshot.data?[17];
                  var deliverymanWalletAddress = snapshot.data?[18];
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: orderCount,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            enterTransactionDetailsPage(
                                index,
                                context,
                                connector,
                                id[index],
                                senderWalletAddress[index],
                                recipientWalletAddress[index],
                                orderStatus[index],
                                deliverymanWalletAddress[index]);
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
                                              child: Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    senderAddress[index] +
                                                        ", " +
                                                        senderDistrict[index],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  )))),
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
                                              child: Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    receiverAddress[index] +
                                                        ", " +
                                                        receiverDistrict[index],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  )))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                          flex: 15,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Status: ' +
                                                    OrderState[
                                                        orderStatus[index]
                                                            .toInt()],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          )),
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
    ));
  }

  enterTransactionDetailsPage(
      index,
      context,
      connector,
      id,
      senderWalletAddress,
      recipientWalletAddress,
      orderStatus,
      deliverymanWalletAddress) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TransactionDetailsPage(
                title: 'Details',
                index: index,
                connector: connector,
                orderID: id,
                sender: senderWalletAddress,
                receiver: recipientWalletAddress,
                orderStatus: orderStatus,
                deliveryman: deliverymanWalletAddress,
              )),
    );
  }
}

class TransactionDetailsPage extends StatefulWidget {
  final String title;
  final index;
  var connector, orderID, sender, receiver, orderStatus, deliveryman;
  TransactionDetailsPage(
      {Key? key,
      required this.title,
      required this.index,
      required this.connector,
      required this.orderID,
      required this.sender,
      required this.receiver,
      required this.orderStatus,
      required this.deliveryman})
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
            padding: EdgeInsets.all(0),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              (widget.orderStatus.toInt() == 0 ||
                      widget.orderStatus.toInt() == 1)
                  ? FloatingActionButton(
                      onPressed: () {
                        cancelOrder();
                      },
                      child: const Icon(Icons.cancel),
                    )
                  : const SizedBox(height: 0),
              (widget.orderStatus.toInt() == 2 ||
                      widget.orderStatus.toInt() == 3 ||
                      widget.orderStatus.toInt() == 4)
                  ? FloatingActionButton(
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
                                orderDeliveryman: widget.deliveryman,
                              ),
                            ));
                      },
                      child: const Icon(Icons.message),
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 30),
              (widget.orderStatus.toInt() == 3 &&
                      connector.address == widget.receiver.toString())
                  ? FloatingActionButton(
                      onPressed: () {
                        confirmReceived(widget.deliveryman, widget.orderID);
                      },
                      child: FaIcon(FontAwesomeIcons.checkCircle),
                    )
                  : const SizedBox(height: 30)
            ])),
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
                        var deliveryFee = snapshot.data?[11];
                        var productAmount = snapshot.data?[12];
                        var parcelDescription = snapshot.data?[5];
                        var parcelWidth = snapshot.data?[6];
                        var parcelHeight = snapshot.data?[7];
                        var parcelDepth = snapshot.data?[8];
                        var parcelWeight = snapshot.data?[9];
                        var orderStatus = snapshot.data?[14];
                        var payBySender = snapshot.data?[10];
                        var recipientWalletAddress = snapshot.data?[17];
                        print(orderStatus[index].toString() +
                            " " +
                            recipientWalletAddress[index].toString() +
                            " " +
                            payBySender[index].toString() +
                            " " +
                            connector.address.toString());
                        // print(orderStatus[index].toString() == '0' &&
                        //     connector.address.toString() ==
                        //         recipientWalletAddress[index].toString() &&
                        //     payBySender == 'false');
                        print(orderStatus[index] == BigInt.from(0));
                        print(connector.address.toString() ==
                            recipientWalletAddress[index].toString());

                        print(payBySender[index].toString() == "false");

                        // print(snapshot.data?[14]);
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
                                    const SizedBox(width: 70),
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
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
                                    Text('Amount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Delivery Fee: ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700)),
                                    Flexible(
                                        child: Text(
                                            deliveryFee[index]
                                                    .toStringAsFixed(8) +
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
                                    Text('Product Amount: ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700)),
                                    Flexible(
                                        child: Text(
                                            productAmount[index]
                                                    .toStringAsFixed(8) +
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
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                (orderStatus[index] == 3)
                                    ? Row(
                                        children: [
                                          Flexible(
                                              child: Text('Parcel Location',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          const SizedBox(height: 30)
                                        ],
                                      )
                                    : const SizedBox(height: 30),
                                (orderStatus[index] == BigInt.from(0) &&
                                        connector.address.toString() ==
                                            recipientWalletAddress[index]
                                                .toString() &&
                                        payBySender[index].toString() ==
                                            "false")
                                    ? FilledButton(
                                        style: FilledButton.styleFrom(
                                            minimumSize: Size(350, 50)),
                                        onPressed: () => {
                                              payByRecipient(
                                                  deliveryFee[index] * 1e18 +
                                                      productAmount[index] *
                                                          1e18 +
                                                      100)
                                            },
                                        child: Text('Pay Now',
                                            style: TextStyle(fontSize: 18)))
                                    : const SizedBox(height: 0)
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

  payByRecipient(totalAmount) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );
    print(totalAmount.toInt().toString() + 'totalAmount');
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    await connector.payByRecipient(
        orderID: widget.orderID, totalAmount: BigInt.from(totalAmount.toInt()));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Payment Successful')));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPage(
              title: 'Order Tracking & History', connector: connector),
        ));
  }

  confirmReceived(deliverymanWalletAddress, orderID) async {
    var scannedDeliverymanWalletAddress = "0";
    await BarcodeScanner.scan().then((value) {
      setState(() {
        scannedDeliverymanWalletAddress = value.rawContent.toString();
      });
    });

    if (scannedDeliverymanWalletAddress.toString() ==
        deliverymanWalletAddress.toString()) {
      Future.delayed(Duration.zero, () => connector.openWalletApp());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingPage()),
      );

      await connector.deliveryConfirmCompleted(
          orderID: BigInt.from(orderID.toInt()));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order #' + orderID.toString() + ' Received')));

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderPage(
                title: 'Order Tracking & History',
                connector: widget.connector)),
      );
    }
  }

  cancelOrder() async {
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );

    await connector.cancelOrder(orderID: BigInt.from(widget.orderID.toInt()));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order #' + widget.orderID.toString() + ' Cancelled' + ", Amount refunded to payer's wallet")));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderPage(
              title: 'Order Tracking & History', connector: widget.connector)),
    );
  }
}
