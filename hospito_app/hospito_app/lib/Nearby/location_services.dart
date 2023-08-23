import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'location_model.dart';

class LocationServices {
  //reference for users
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('Users');

  Future getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      LocationModel model = LocationModel(
          latitude: position.latitude, longitude: position.longitude);
      return model;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //store Location in profile
  Future storeLocation(List position, String uid) {
    return userReference.doc(uid).update({
      'Position': position,
    });
  }

  //get Locations
  Future getLocation() {
    return userReference.get();
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
}
