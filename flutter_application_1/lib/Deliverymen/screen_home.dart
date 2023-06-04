import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'app_drawer.dart';
import 'available_order_listview.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'current_location_tracker.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;
final orderID = getOrderID();

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

class HomePage extends StatefulWidget {
  final String title;
  var connector;
  HomePage({super.key, required this.title, required this.connector});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final geo = GeoFlutterFire();
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getInstantLocation(orderID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(title: Text(widget.title)),
        drawer: AppDrawer(connector: widget.connector),
        body: AvailableOrderListView());
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore
        .collection('locations')
        .add({'position': point.data, 'name': 'Yay I can be queried!'});
  }
}
