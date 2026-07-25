import 'package:geolocator/geolocator.dart';

/// Get a continuous stream of position updates
Stream<Position> getPositionStream() async* {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  yield* Geolocator.getPositionStream(locationSettings: locationSettings);
}
