import 'dart:math';
import 'dart:typed_data';
import 'package:hospito_app/Screens/lab_detailed_screen.dart';
import 'package:hospito_app/Services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Doctor/Services/services.dart';
import '../Services/auth_services.dart';
import 'location_model.dart';
import 'location_services.dart';

class NearByScreen extends StatefulWidget {
  const NearByScreen({Key? key}) : super(key: key);

  @override
  _NearByScreenState createState() => _NearByScreenState();
}

class _NearByScreenState extends State<NearByScreen> {
  var mapType = MapType.normal;
  var myLat;
  var myLong;
  bool loader = true;
  Set<Marker> _markers = {};
  BitmapDescriptor? _mapMarker;
  GoogleMapController? _googleController;
  void setCustomMarker() async {
    // _mapMarker=await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'images/standing-up-man-.png');
    // _mapMarker=BitmapDescriptor.getBytesFromAsset('assets/images/flutter.png', 100);
  }
  void _onMapCreated(GoogleMapController controller) async {
    var random = Random();
    _googleController = controller;
    final data = await Services().getLabs();
    final myData = await DatabaseServices().getMyLocation();
    int id = random.nextInt(10);
    String latitude = myData.get('Position')[0]['Latitude'];
    double latD = double.parse(latitude);
    String longitude = myData.get('Position')[0]['Longitude'];
    double longD = double.parse(longitude);
    final Uint8List myMarkerIcon = await LocationServices()
        .getBytesFromAsset('assets/myLocatioLogo.png', 100);
    setState(() {
      _markers.add(Marker(
        icon: BitmapDescriptor.fromBytes(myMarkerIcon),
        markerId: MarkerId(id.toString()),
        position: LatLng(latD, longD),
      ));
    });
    var listOfLabs = data.docs;
    for (var Lab in listOfLabs) {
      if (Lab.get('Position').length != 0) {
        // keep this somewhere in a static variable. Just make sure to initialize only once.
        int id = random.nextInt(10);
        print(id);
        String name = Lab.get('Lab Name');
        String doctorName = Lab.get('Doctor');
        String address = Lab.get('Address');
        String labId = Lab.id;
        String number = Lab.get('Phone Number');
        String latitude = Lab.get('Position')[0]['Latitude'];
        double latD = double.parse(latitude);
        String longitude = Lab.get('Position')[0]['Longitude'];
        double longD = double.parse(longitude);
        print(latD);

        //
        final Uint8List markerIcon = await LocationServices()
            .getBytesFromAsset('assets/locationLogo.png', 100);
        setState(() {
          _markers.add(Marker(
              icon: BitmapDescriptor.fromBytes(markerIcon),
              markerId: MarkerId(id.toString()),
              position: LatLng(latD, longD),
              infoWindow: InfoWindow(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LabDetailedScreen(
                          labName: name,
                          docName: doctorName,
                          address: address,
                          labId: labId,
                          phoneNumber: number);
                    }));
                  },
                  title: name,
                  snippet: number)));
        });
      }
    }
  }

  storeLocationInDatabase() async {
    LocationModel model = await LocationServices().getCurrentLocation();
    myLat = model.latitude;
    myLong = model.longitude;
    setState(() {
      loader = false;
    });
    print(loader);
    List position = [];
    position.add({
      'Latitude': model.latitude.toString(),
      'Longitude': model.longitude.toString()
    });
    LocationServices().storeLocation(position, AuthServices().getUid());
  }

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    storeLocationInDatabase();
  }

  @override
  void dispose() {
    _googleController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: GoogleMap(
              mapType: mapType,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(myLat, myLong),
                zoom: 15,
              ),
              onMapCreated: _onMapCreated,
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: FloatingActionButton(
                      backgroundColor:
                          mapType == MapType.normal ? Colors.blue : Colors.red,
                      onPressed: () {
                        if (mapType == MapType.normal) {
                          setState(() {
                            mapType = MapType.hybrid;
                          });
                        } else {
                          setState(() {
                            mapType = MapType.normal;
                          });
                        }
                      },
                      child: Icon(
                        Icons.add_location_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _googleController!
                          .animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(myLat, myLong),
                          zoom: 15,
                        ),
                      ));
                    },
                    child: Icon(
                      Icons.api_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
