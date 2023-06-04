import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'screen_order.dart';

final senderLatLng = senderPosition;
final recipientLatLng = recipientPosition;

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

class FireMap extends StatefulWidget {
  final String title, orderID;
  var senderAddress, recipientAddress;
  FireMap(
      {required this.title,
      required this.orderID,
      required this.senderAddress,
      this.recipientAddress});
  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  final google_api_key = "AIzaSyCYR6ZZ3jgCSbfvUHCqO2JYEmIOVVx8wTs";

  final firestore = FirebaseFirestore.instance;
  final geo = GeoFlutterFire();
  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);

  // late Stream<dynamic> query;
  late StreamSubscription subscription;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(22.405753, 114.143229), zoom: 13),
        onMapCreated: onMapCreated,
        myLocationEnabled: true,
        markers: _markers,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  void updateMarkers(geopoint) async {
    BitmapDescriptor deliverymanIcon, senderIcon, recipientIcon;
    deliverymanIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/icon/cargo-truck.png', 96));
    senderIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/icon/pickup.png', 96));
    recipientIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/icon/delivery.png', 96));

    Map<String, dynamic> data = geopoint.data() as Map<String, dynamic>;
    GoogleMapController googleMapController = await mapController.future;

    GeoPoint pos = data['location']['geopoint'];

    print(pos.latitude);
    print(pos.longitude);

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(zoom: 18, target: LatLng(pos.latitude, pos.longitude)),
      ),
    );

    Marker marker = Marker(
        markerId: MarkerId("deliveryman"),
        position: LatLng(pos.latitude, pos.longitude),
        icon: deliverymanIcon,
        infoWindow: InfoWindow(
            title: 'Deliveryman', snippet: 'Your deliveryman is here!'));

    Marker senderMarker = Marker(
        markerId: MarkerId("Sender"),
        position: LatLng(senderPosition.latitude, senderPosition.longitude),
        icon: senderIcon,
        infoWindow: InfoWindow(title: "Parcel Pickup", snippet: senderAddress));

    Marker recipientMarker = Marker(
        markerId: MarkerId("Recipient"),
        position:
            LatLng(recipientPosition.latitude, recipientPosition.longitude),
        icon: recipientIcon,
        infoWindow:
            InfoWindow(title: "Parcel Destination", snippet: recipientAddress));

    Set<Marker> newMarkers = {};

    newMarkers.add(marker);
    newMarkers.add(senderMarker);
    newMarkers.add(recipientMarker);
    setState(() {
      _markers = newMarkers;
    });
  }

  updateQuery(value) {
    setState(() {
      radius.add(value);
    });
  }

  startQuery() async {
    var ref = firestore.collection('orders').doc(widget.orderID);

    ref.snapshots().listen(
          (event) => updateMarkers(event),
          onError: (error) => print("Listen failed: $error"),
        );
  }

  @override
  void initState() {
    startQuery();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
