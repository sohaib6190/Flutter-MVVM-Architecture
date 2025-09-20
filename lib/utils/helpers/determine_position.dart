part of 'helpers.dart';

Future<LocationData> determinePosition() async {
  Location location = Location();
  PermissionStatus permissionGranted;
  LocationData locationData;

  permissionGranted = await location.hasPermission();

  if (permissionGranted == PermissionStatus.denied ||
      permissionGranted == PermissionStatus.deniedForever) {
    permissionGranted = await location.requestPermission();

    // If permission is denied forever, guide the user to the settings
    if (permissionGranted == PermissionStatus.deniedForever) {
      // Open the app's settings where the user can enable location permission manually
   
      throw Exception(
          'Location permission denied forever. Please enable it in settings.');
    }
  }

  // Fetch the location if permission is granted
  locationData = await location.getLocation();
  return locationData;
}

Future<bool> checkLocationPermission() async {
  Location location = Location();
  PermissionStatus permissionGranted = await location.hasPermission();

  if (permissionGranted == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
}
