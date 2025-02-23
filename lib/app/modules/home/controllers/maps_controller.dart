import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsController extends GetxController {
  // Koordinat toko (sesuaikan dengan lokasi toko Anda)
  final double storeLat = -7.973679147406706; // Contoh: Latitude toko
  final double storeLng = 112.61198502666511; // Contoh: Longitude toko

  // Menyimpan lokasi pengguna
  var currentLocation = Rx<Position?>(null);

  // Metode untuk mendapatkan lokasi user saat ini
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    // Ambil lokasi saat ini
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = position;
    return position;
  }

  // Navigasi ke toko menggunakan URI geo
  void navigateToStore() async {
    final uri =
        Uri.parse("geo:$storeLat,$storeLng?q=$storeLat,$storeLng(Store)");
    try {
      print('Trying to open URI: ${uri.toString()}');
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString(), forceSafariVC: false, forceWebView: false);
        print('Successfully opened URI');
      } else {
        print('Geo URI failed, trying browser fallback');
        final url =
            "https://www.google.com/maps/search/?api=1&query=$storeLat,$storeLng";
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false, forceWebView: false);
          print('Successfully opened browser fallback');
        } else {
          throw 'Could not open the map in browser either.';
        }
      }
    } catch (e) {
      print('Error launching map: $e');
      throw 'Could not open the map.';
    }
  }

  // Fungsi untuk membuka lokasi toko di peta
  void openStoreLocation() async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=$storeLat,$storeLng";
    try {
      print('Trying to open URL: $url');
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
        print('Successfully opened store location on map');
      } else {
        print('Cannot launch URL: $url');
        throw 'Could not open the map.';
      }
    } catch (e) {
      print('Error opening store location: $e');
      throw 'Could not open the map.';
    }
  }

  // Fungsi untuk membuka lokasi pengguna di peta
  void openCurrentLocationMap() async {
    if (currentLocation.value != null) {
      final lat = currentLocation.value!.latitude;
      final lng = currentLocation.value!.longitude;
      final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
      try {
        print('Trying to open URL: $url');
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false, forceWebView: false);
          print('Successfully opened current location on map');
        } else {
          print('Cannot launch URL: $url');
          throw 'Could not open the map.';
        }
      } catch (e) {
        print('Error opening current location: $e');
        throw 'Could not open the map.';
      }
    } else {
      throw 'Current location is not available.';
    }
  }
}
