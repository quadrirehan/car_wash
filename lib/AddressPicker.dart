import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as locator;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'WashingPackage.dart';

class AddressPicker extends StatefulWidget {
  @override
  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  Completer<GoogleMapController> _controller = Completer();
  static double lat;
  static double lng;
  String lang = "English";
  String address = "";

//  final dbHelper = DatabaseHelper.instance;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(55.032474, 2.972818),
    zoom: 14.4746,
  );
  int locationmove = 0;
  LatLng DeliveryLocationLatLng = null;
  static final CameraPosition _kLake =
      CameraPosition(target: LatLng(lat, lng), zoom: 14.151926040649414);

  void initPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (locationmove == 0) {
        setState(() {
          debugPrint(lat.toString());

          lat = currentLocation.latitude;
          lng = currentLocation.longitude;
          updateLocation();
        });
      }
      // Use current location
    });
  }

  void updateLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    locationmove++;
    getAddress(lat.toString(), lng.toString());
    getUserLocation();
  }

  final Set<Marker> _markers = {};

//  DatabaseHelper _databaseHelper;

  locator.Position currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        actions: <Widget>[
//          InkWell(
//            onTap: () {
//              if (DeliveryLocationLatLng == null) {
//              } else {
//                getAddress(DeliveryLocationLatLng.latitude.toString(),
//                    DeliveryLocationLatLng.longitude.toString());
//              }
//            },
//            child: Container(
//              margin: EdgeInsets.only(right: 20),
//              child: Row(
//                children: <Widget>[
//                  Icon(Icons.check),
//                  Text(lang == "English" ? "Set Location" : "حفظ الموقع")
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraIdle: () {
              getAddress(DeliveryLocationLatLng.latitude.toString(),
                  DeliveryLocationLatLng.longitude.toString());
            },
            mapToolbarEnabled: true,
            markers: _markers,
            onCameraMove: (val) {
              setState(() {
                DeliveryLocationLatLng = val.target;
               /* getAddress(DeliveryLocationLatLng.latitude.toString(),
                    DeliveryLocationLatLng.longitude.toString());*/

                _markers.add(
                  Marker(
                    markerId: MarkerId("1001"),
                    position: val.target,
                    infoWindow: InfoWindow(
                      title: lang == "English"
                          ? 'Delivery Location'
                          : "موقع التسليم",
                    ),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                );
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Icon(Icons.location_on),
                          ),
                          Expanded(
                            child: Text(
                            address,
                            textAlign: TextAlign.center,
                          ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.only(left: 18,right: 18),
                        child: RaisedButton(
                          onPressed: address == ""? null : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WashingPackage(address, lat, lng)));
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Text("Continue"),
                          color: address == "" ? Colors.grey : Colors.blue,
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: getUserLocation, //_goToTheLake,
//        label: Text(lang == "English" ? 'My Location' : "موقعي الحالي"),
//        icon: Icon(Icons.location_searching),
//      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void getAddress(String lat, String lon) async {
    var addresses;
    var first;
    final coordinates = new Coordinates(double.parse(lat), double.parse(lon));
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;

    setState(() {
      address = first.addressLine.toString().replaceAll("'", "");
    });
    debugPrint("address: " + address);
    debugPrint("Latitude: " + lat.toString());
    debugPrint("Longitude: " + lng.toString());
//    _databaseHelper = DatabaseHelper();
//    int id = 0;
//    var addr = _databaseHelper.queryAllAddress();
//    addr.then((value) async {
//      if (value.length != 0) {
//        setState(() {
//          id = value[0]['_id'];
//          _databaseHelper.updateLocation(
//              id, address, lat.toString(), lng.toString());
//          Navigator.pop(context, address);
//        });
//      } else {
//        int result = await _databaseHelper.saveMyLocation(
//          address,
//          lat,
//          lon,
//          DateTime.now().toString(),
//        );
//        if (result > 0) {
//          Navigator.pop(context, address);
//        }
//      }
//    });
  }

  Future<locator.Position> locateUser() async {
    return locator.Geolocator()
        .getCurrentPosition(desiredAccuracy: locator.LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    debugPrint('currentLocation $currentLocation');
    setState(() {
      setState(() {
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
        getAddress(lat.toString(), lng.toString());
      });
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
