import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_accepted_order.dart';
import 'screen_message.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'screen_route_navigation_before_pickup.dart';
import 'screen_route_navigation_after_pickup.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var senderPosition, recipientPosition;
var senderAddress, recipientAddress;

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

Future<dynamic> getLatLng(String senderAddress, String recipientAddress) async {
  print(senderAddress + "111");
  print(recipientAddress + "2222");
  List<Location> location1 = await locationFromAddress(senderAddress);
  List<Location> location2 = await locationFromAddress(recipientAddress);
  final senderLnglat = LatLng(location1[0].latitude, location1[0].longitude);
  final recipientLnglat = LatLng(location2[0].latitude, location2[0].longitude);
  print(senderLnglat.toString() + "3");
  print(recipientLnglat.toString() + "4");
  return [senderLnglat, recipientLnglat];
}

class TransactionDetailsPage extends StatefulWidget {
  final String title;
  final index;
  var connector,
      orderID,
      sender,
      receiver,
      orderStatus,
      senderAddress,
      recipientAddress;
  TransactionDetailsPage(
      {Key? key,
      required this.title,
      required this.index,
      required this.connector,
      required this.orderID,
      required this.sender,
      required this.receiver,
      required this.orderStatus,
      required this.senderAddress,
      required this.recipientAddress})
      : super(key: key);
  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var index = widget.index;

    return Scaffold(
        floatingActionButton: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (widget.orderStatus.toInt() == 2)
                    ? FloatingActionButton(
                        onPressed: () {
                          showCancelDialog();
                        },
                        child: const Icon(Icons.cancel),
                      )
                    : const SizedBox(height: 0),
                const SizedBox(height: 30),
                (widget.orderStatus.toInt() == 2)
                    ? FutureBuilder(
                        future: getLatLng(
                            widget.senderAddress, widget.recipientAddress),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final senderLatLng = snapshot.data?[0];
                            final recipientLatLng = snapshot.data?[1];
                            senderPosition = senderLatLng;
                            recipientPosition = recipientLatLng;
                            senderAddress = widget.senderAddress;
                            recipientAddress = widget.recipientAddress;
                            return FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RouteNavigationBeforePickedUpPage(
                                        title: 'Route To Sender',
                                        senderAddress: senderLatLng,
                                        recipientAddress: recipientLatLng,
                                      ),
                                    ));
                              },
                              child: FaIcon(FontAwesomeIcons.route),
                            );
                          } else {
                            return const SizedBox(
                              height: 0,
                            );
                          }
                        })
                    : (widget.orderStatus.toInt() == 3)
                        ? FutureBuilder(
                            future: getLatLng(
                                widget.senderAddress, widget.recipientAddress),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final senderLatLng = snapshot.data?[0];
                                final recipientLatLng = snapshot.data?[1];
                                senderPosition = senderLatLng;
                                recipientPosition = recipientLatLng;
                                senderAddress = widget.senderAddress;
                                recipientAddress = widget.recipientAddress;
                                return FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RouteNavigationAfterPickedUpPage(
                                            title: 'Route To Recipient',
                                            senderAddress: senderLatLng,
                                            recipientAddress: recipientLatLng,
                                          ),
                                        ));
                                  },
                                  child: FaIcon(FontAwesomeIcons.route),
                                );
                              } else {
                                return const SizedBox(
                                  height: 0,
                                );
                              }
                            })
                        : const SizedBox(
                            height: 0,
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
                (widget.orderStatus.toInt() == 2 ||
                        widget.orderStatus.toInt() == 3)
                    ? FloatingActionButton(
                        onPressed: () {
                          (widget.orderStatus.toInt() == 2)
                              ? showOrderPickedUpDialog(context, widget.orderID)
                              : (widget.orderStatus.toInt() == 3)
                                  ? showQRcodeToRecipient(context)
                                  : null;
                        },
                        child: FaIcon(FontAwesomeIcons.checkCircle),
                      )
                    : const SizedBox(
                        height: 0,
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

  Future<bool?> showOrderPickedUpDialog(context, orderID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Picked Up Order"),
          content: Text("Confirm to pick up the order",
              style: TextStyle(fontWeight: FontWeight.w600)),
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

  Future<bool?> showCancelDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cancel Order"),
          content: Text("Confirm to cancel the order",
              style: TextStyle(fontWeight: FontWeight.w600)),
          actions: <Widget>[
            TextButton(
              child: Text("Exit"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text("Confirm", style: TextStyle(color: Colors.white)),
              onPressed: () => cancelOrder(),
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
    await connector.deliveryPickupOrder(orderID: BigInt.from(orderID.toInt()));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order #' + orderID.toString() + ' Picked Up')));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderPage(title: 'Accepted Orders', connector: connector)),
    );
  }

  showQRcodeToRecipient(context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return QRImageDialog();
      },
    );
  }

  cancelOrder() async {
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );

    await connector.cancelOrder(orderID: BigInt.from(widget.orderID.toInt()));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order #' +
            widget.orderID.toString() +
            ' Cancelled' +
            ", Amount refunded to payer's wallet")));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderPage(title: 'Accepted Orders', connector: connector)),
    );
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

class QRImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            width: 350,
            height: 440,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Order Comfirmation',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Show QR code to Recipient',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 20,
                  ),
                  QrImageView(
                    data: connector.address.toString(),
                    size: 250,
                    version: QrVersions.auto,
                    gapless: false,
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(80, 80),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                ],
              ),
            )));
  }
}
