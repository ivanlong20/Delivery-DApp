import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_accepted_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

getOrderCount() async {
  var allOrders;
  allOrders = await connector.getPendingOrder();
  final allOrder = List.from(await allOrders);
  Future.delayed(Duration(seconds: 5));
  return allOrder.length;
}

Future<List<dynamic>> getOrderInfo() async {
  var allOrders;
  allOrders = await connector.getPendingOrder();

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
    orderDate
  ];
}

class AvailableOrderListView extends StatelessWidget {
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
                  var deliveryFee = snapshot.data?[11];
                  var packageDescription = snapshot.data?[5];
                  var packageHeight = snapshot.data?[6];
                  var packageWidth = snapshot.data?[7];
                  var packageDepth = snapshot.data?[8];
                  var packageWeight = snapshot.data?[9];
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: orderCount,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            showOrderConfirmationDialog(
                                context,
                                id[index],
                                packageDescription[index],
                                packageHeight[index].toInt(),
                                packageWidth[index].toInt(),
                                packageDepth[index].toInt(),
                                packageWeight[index].toDouble());
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
                                        height: 10,
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
                                                            FontWeight.w700,
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
                                      SizedBox(height: 5),
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
                                                            FontWeight.w700,
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  )))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: Container(
                                          width: 330,
                                          child: Text(
                                            'Amount: ' +
                                                deliveryFee[index]
                                                    .toStringAsFixed(6) +
                                                ' ETH',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
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

  Future<bool?> showOrderConfirmationDialog(
      context,
      orderID,
      packageDescription,
      packageHeight,
      packageWidth,
      packageDepth,
      packageWeight) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Accept Order"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Package Description: " + packageDescription.toString(),
                style: TextStyle(fontWeight: FontWeight.w800)),
            Text(
                "Dimension: " +
                    packageHeight.toString() +
                    " x " +
                    packageWidth.toString() +
                    " x " +
                    packageDepth.toString() +
                    " cm",
                style: TextStyle(fontWeight: FontWeight.w800)),
            Text("Weight: " + packageWeight.toString() + " kg",
                style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Text("Confirm to delivery the order",
                style: TextStyle(fontWeight: FontWeight.w600))
          ]),
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
              onPressed: () => transaction(context, orderID),
            )
          ],
        );
      },
    );
  }

  transaction(context, orderID) async {
    Future.delayed(Duration.zero, () => connector.openWalletApp());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );
    await connector.deliveryAcceptOrder(orderID: BigInt.from(orderID.toInt()));
    uploadOrdertoFirebase(orderID);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order #' + orderID.toString() + ' Accepted')));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderPage(title: 'Accepted Orders', connector: connector)),
    );
  }

  uploadOrdertoFirebase(orderID) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    GeoFlutterFire geo = GeoFlutterFire();
    GeoFirePoint location = geo.point(latitude: 0, longitude: 0);

    final order_info = {
      "deliverymanWalletAddress": connector.address,
      "uid": user!.uid,
      "location": location.data
    };

    db.collection("orders").doc(orderID.toString()).set(order_info);
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
