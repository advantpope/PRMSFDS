import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } else {
      throw Exception('Location permission denied');
    }
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await Geolocator.placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
      }
      return 'Unknown location';
    } catch (e) {
      return 'Unable to fetch address';
    }
  }
}
