// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geoflutterfire2/geoflutterfire2.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';

// class FireMap extends StatefulWidget {
//   final String title;
//   FireMap({required this.title});
//   @override
//   State createState() => FireMapState();
// }

// class FireMapState extends State<FireMap> {
//   Completer<GoogleMapController> mapController =
//       Completer<GoogleMapController>();
//   Set<Marker> _markers = {};
//   final firestore = FirebaseFirestore.instance;
//   final geo = GeoFlutterFire();
//   BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);

//   late Stream<dynamic> query;
//   late StreamSubscription subscription;

//   @override
//   build(context) {
//     // widgets go here
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//       ),
//       body: GoogleMap(
//         initialCameraPosition:
//             CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
//         onMapCreated: onMapCreated,
//         myLocationEnabled:
//             true, // Add little blue dot for device location, requires permission from user
//         mapType: MapType.hybrid,
//         markers: _markers,
//       ),
//     );
//   }

//   void onMapCreated(GoogleMapController controller) {
//     if (!mapController.isCompleted) {
//       mapController.complete(controller);
//     }
//   }

//   void updateMarkers(List<DocumentSnapshot> documentList) async {
//     print(documentList);
//     GoogleMapController googleMapController = await mapController.future;

//     documentList.forEach((DocumentSnapshot document) {
//       GeoPoint pos = document.data['position']['geopoint'];
//       double distance = document.data['distance'];
//       var marker = Marker(
//           markerId: MarkerId(document.id),
//           position: LatLng(pos.latitude, pos.longitude),
//           icon: BitmapDescriptor.defaultMarker,
//           infoWindow: InfoWindow(
//               title: 'Magic Marker',
//               snippet: '$distance kilometers from query center'));

//       Set<Marker> newMarkers = {};
//       newMarkers.add(marker);

//       setState(() {
//         _markers = newMarkers;
//       });
//     });
//   }

//   updateQuery(value) {
//     setState(() {
//       radius.add(value);
//     });
//   }

//   startQuery() async {
//     // Get users location
//     var pos = await location.getLocation();
//     double lat = pos.latitude;
//     double lng = pos.longitude;

//     // Make a referece to firestore
//     var ref = firestore.collection('locations');
//     GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

//     // subscribe to query
//     subscription = radius.switchMap((rad) {
//       return geo.collection(collectionRef: ref).within(
//           center: center, radius: rad, field: 'position', strictMode: true);
//     }).listen(updateMarkers);
//   }

// }
