// location_service.dart
import 'package:geolocator/geolocator.dart';

// class LocationService {
// }
Future<Position> getFormattedPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }
  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Request the user to enable the location services
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  // Check for location permissions

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  // String apiPosition = 'latitude=${position.latitude}&longitude=${position.longitude}';
  return position;
}
