import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meteo_app/api/api_geocoder.dart';
import 'package:meteo_app/models/device_info.dart';
import 'package:meteo_app/pages/page_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Location location = Location(); // INIT PACKAGE GEOLOC

  bool _serviceEnabled = await location.serviceEnabled();

  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  PermissionStatus _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  LocationData _locationData = await location.getLocation();
  print(" Location ${_locationData.latitude}");
  DeviceInfo.locationData = _locationData;

  ApiGeocoder geocoder =
      ApiGeocoder(apiKey: "959d1296a89c3365a20b001a440c4eb3");
  String? ville = await geocoder.getAddressFromCoordinates(
      latitude: _locationData.latitude!, longitude: _locationData.longitude!);
  DeviceInfo.ville = ville;
    
    
    Map<String, dynamic>? villeTest = 
    await geocoder.getCoordinatesFromAddress( 
      ville: 'Rouen'
    );
    print(villeTest);


  print(DeviceInfo.ville); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const PageHome(),
    );
  }
}
