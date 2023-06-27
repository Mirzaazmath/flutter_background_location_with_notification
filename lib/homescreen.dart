import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class HomeScreen extends StatefulWidget {

  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// here we are creating longitude to store user longitude
  var longitude = "longitude";

  /// here we are creating latitude to store user latitude
  var latitude = "latitude";

  /// here we are creating the  StreamSubscription to get latitude and longitude as it changes
  late StreamSubscription<Position> streamSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// here we are calling _getcurrentlocation to get user current location
    _getcurrentlocation();
  }

  void _getcurrentlocation() async {
    // here we are create a bool to check the service
    bool serviceEnabled;
    // here we are create  LocationPermission to get user permission to access the location
    LocationPermission permission;
    // here we are checking service is on or not
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if not then ask user for permission
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error("Location Services are disabled");
    }

    /// here we are again checking the permission
    permission = await Geolocator.checkPermission();
    // if it is denied
    if (permission == LocationPermission.denied) {
      /// here we are again  requestPermission from user
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        /// if user again denied we return error
        return Future.error("Location permission are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      /// if user again deniedForever we return error
      return Future.error("Location permissions are permanently denied");
    }

    /// after getting the LocationPermission we are going to user position by using
    /// streamSubscription that comes with package(Geolocator)
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
          /// here we retivinig the latitude and longitude and storing them in the variable that
          /// we created earlier
          latitude = "latitude ${position.latitude}";
          longitude = "longitude${position.longitude}";

          /// after getting the latitude and longitude we are going to save them in firebase
          /// In firebase we create collection with name location
          /// and in that collection we create a document with name user name  becuse if we put same name
          /// it will update only that document not all
          /// In document we store our data as key value pair "latitude" :16252636.933,"longitude":937379.3837
          /// and name "name":n username
          /// and we SetOptions as merge true because it will merge the new data with existing data


        });

    print(latitude);
    print(longitude);

    // getaddressfromlanlong(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
