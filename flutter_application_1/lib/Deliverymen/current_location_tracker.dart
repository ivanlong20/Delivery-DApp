import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geoflutterfire2/geoflutterfire2.dart';

Position? position;
late StreamSubscription<Position> positionStream;

void getInstantLocation(orderID) async {
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 50,
  );
  final id = await orderID;
  position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  var lat = position!.latitude;
  var lng = position!.longitude;

  FirebaseFirestore db = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  GeoFirePoint location = geo.point(latitude: lat, longitude: lng);

  final order_info = {
    "location": location.data,
  };

  for (int i = 0; i < id.length; i++) {
    await db.collection('orders').doc(id[i].toString()).update(order_info);
  }

  positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) async {
    var lat = position!.latitude;
    var lng = position.longitude;
    GeoFlutterFire geo = GeoFlutterFire();
    GeoFirePoint location = geo.point(latitude: lat, longitude: lng);

    final order_info = {"location": location.data};

    for (int i = 0; i < id.length; i++) {
      await db.collection('orders').doc(id[i].toString()).update(order_info);
    }
  });
}

void stopTracking() {
  positionStream.cancel();
}
