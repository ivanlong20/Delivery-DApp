import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_accepted_order.dart';
import 'screen_accepted_order_details.dart';

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
                                      builder: (context) =>
                                          TransactionDetailsPage(
                                              title: 'Details',
                                              index: index,
                                              connector: connector,
                                              orderID: id[index],
                                              sender:
                                                  senderWalletAddress[index],
                                              receiver:
                                                  recipientWalletAddress[index],
                                              orderStatus: orderStatus[index],
                                              senderAddress:
                                                  senderAddress[index] +
                                                      ", " +
                                                      senderDistrict[index],
                                              recipientAddress:
                                                  receiverAddress[index] +
                                                      ", " +
                                                      receiverDistrict[index])),
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255)),
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 180,
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
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
                                                    DateFormat(
                                                            'dd/MM/yyyy HH:mm')
                                                        .format(
                                                            orderDate[index]),
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
                                                        orderStatus[index]
                                                            .toInt()],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
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
