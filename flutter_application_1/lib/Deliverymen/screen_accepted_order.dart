import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'app_drawer.dart';
import 'accepted_order_listview.dart';
import 'dart:async';
import '../ethereum_connector.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


final finalBalance = connector.getBalance();
final network = connector.networkName;

getOrderID() async {
  final allOrders = await connector.getDeliverymanOrder();
  final allOrder = List.from(await allOrders);
  var orderCount = allOrder.length;
  var id = [];
  for (int i = 0; i < orderCount; i++) {
    if (allOrder[i][5].toInt() == 2 || allOrder[i][5].toInt() == 3) {
      id.add(allOrder[i][0].toInt());
    }
  }
  return id;
}

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
    senderAddress.add(encrypter
        .decrypt(encrypt.Encrypted.fromBase64(orders[i][2][0].toString()),iv:iv));
    senderDistrict.add(encrypter
        .decrypt(encrypt.Encrypted.fromBase64(orders[i][2][1].toString()),iv:iv));
    receiverAddress.add(encrypter
        .decrypt(encrypt.Encrypted.fromBase64(orders[i][2][2].toString()), iv: iv));
    receiverDistrict.add(encrypter
        .decrypt(encrypt.Encrypted.fromBase64(orders[i][2][3].toString()),iv:iv));
    packageDescription.add(encrypter
        .decrypt(encrypt.Encrypted.fromBase64(orders[i][3][0].toString()), iv: iv));
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
  void initState() {
    super.initState();
  }

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
