// icon source: https://www.mappity.org/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'screen_accepted_order_details.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'screen_connect_metamask.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final senderLatLng = senderPosition;
final recipientLatLng = recipientPosition;

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

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

class RouteNavigationAfterPickedUpPage extends StatefulWidget {
  final title;
  var senderAddress, recipientAddress;
  RouteNavigationAfterPickedUpPage(
      {Key? key,
      required this.title,
      required this.senderAddress,
      this.recipientAddress})
      : super(key: key);
  @override
  State<RouteNavigationAfterPickedUpPage> createState() =>
      RouteNavigationAfterPickedUpPageState();
}

class RouteNavigationAfterPickedUpPageState
    extends State<RouteNavigationAfterPickedUpPage> {
  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  List<LatLng> polylineCoordinates = [];
  Position? position;
  late BitmapDescriptor deliverymanIcon, recipientIcon;

  final google_api_key = "AIzaSyCYR6ZZ3jgCSbfvUHCqO2JYEmIOVVx8wTs";

  void getCurrentLocation() async {

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Marker marker = Marker(
        markerId: MarkerId("Deliveryman"),
        position: LatLng(22.405753, 114.143229),
        icon: deliverymanIcon,
        infoWindow: InfoWindow(title: "You"));

    Marker recipientMarker = Marker(
        markerId: MarkerId("Recipient"),
        position:
            LatLng(recipientPosition.latitude, recipientPosition.longitude),
        icon: recipientIcon,
        infoWindow:
            InfoWindow(title: "Parcel Destination", snippet: recipientAddress));

    GoogleMapController googleMapController = await mapController.future;

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      var lat = position!.latitude;
      var lng = position.longitude;

      Marker newMarker = Marker(
          markerId: MarkerId("Deliveryman"),
          position: LatLng(lat, lng),
          icon: deliverymanIcon,
          infoWindow: InfoWindow(title: "You"));

      Marker recipientMarker = Marker(
          markerId: MarkerId("Recipient"),
          position:
              LatLng(recipientPosition.latitude, recipientPosition.longitude),
          icon: recipientIcon,
          infoWindow: InfoWindow(
              title: "Parcel Destination", snippet: recipientAddress));

      Set<Marker> newMarkers = {
        _markers.firstWhere((m) => m.markerId == MarkerId("Deliveryman"),
            orElse: () => marker)
      };

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 18, target: LatLng(lat, lng), bearing: position.heading),
        ),
      );

      setPolyPoints();
      
        _markers.clear();
        newMarkers.add(newMarker);
        newMarkers.add(recipientMarker);

      setState(() {
        _markers = newMarkers;
      });
    });
    setState(() {
      _markers.add(marker);
      _markers.add(recipientMarker);
    });
  }

  void setPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    var orginalPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key, // Your Google Map Key
        PointLatLng(orginalPosition.latitude, orginalPosition.longitude),
        PointLatLng(recipientLatLng.latitude, recipientLatLng.longitude));

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getBytesFromAsset('assets/icon/cargo-truck.png', 96)
        .then((value) => {deliverymanIcon = BitmapDescriptor.fromBytes(value)});
    getBytesFromAsset('assets/icon/delivery.png', 96)
        .then((value) => {recipientIcon = BitmapDescriptor.fromBytes(value)});
    getCurrentLocation();
    setPolyPoints();
    super.initState();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("position: $position");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: position == null
          ? LoadingPage()
          : GoogleMap(
              myLocationButtonEnabled: true,
              mapToolbarEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(position!.latitude, position!.longitude),
                  zoom: 18,
                  bearing: position!.heading),
              markers: _markers,
              onMapCreated: onMapCreated,
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Color.fromARGB(255, 104, 104, 104),
                  width: 6,
                ),
              },
            ),
    );
  }

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
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
                  ],
                ))));
  }
}
