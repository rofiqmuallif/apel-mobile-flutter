// services/location_service.dart
import 'package:geolocator/geolocator.dart';

// Reverse geocoding (opsional): gunakan geocoding package
// import 'package:geocoding/geocoding.dart';

class LocationResult {
  final Position position;
  final String? address;
  LocationResult({required this.position, this.address});
}

class LocationService {
  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<LocationResult?> getCurrentLocation() async {
    try {
      if (!await _ensurePermission()) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      String? address;
      // Reverse geocoding opsional:
      // try {
      //   final places = await placemarkFromCoordinates(
      //       position.latitude, position.longitude);
      //   if (places.isNotEmpty) {
      //     final p = places.first;
      //     address = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}';
      //   }
      // } catch (_) {}

      return LocationResult(position: position, address: address);
    } catch (_) {
      return null;
    }
  }
}
