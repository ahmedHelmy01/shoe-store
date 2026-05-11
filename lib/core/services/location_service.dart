import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationErrors {
  static const String serviceDisabled = 'service_disabled';
  static const String permissionDenied = 'permission_denied';
  static const String permissionDeniedForever = 'permission_denied_forever';
}

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationErrors.serviceDisabled;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationErrors.permissionDenied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationErrors.permissionDeniedForever;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.subAdministrativeArea ?? "";
        String governorate = place.administrativeArea ?? "";

        if (city.isNotEmpty && governorate.isNotEmpty) {
          return "$city,$governorate";
        } else if (city.isNotEmpty) {
          return city;
        } else {
          return governorate;
        }
      }
    } catch (e) {}
    return null;
  }

  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
