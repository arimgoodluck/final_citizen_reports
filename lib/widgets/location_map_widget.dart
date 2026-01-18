import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// - A reusable widget that displays a Google Map for selecting a location.
/// - Allows users to tap on the map to select a location.
/// - Displays a marker at the selected location.
/// - Notifies parent widgets via [onTap] and [onMapCreated] callbacks.
class LocationMapWidget extends StatelessWidget {
  /// The currently selected location to display as a marker.
  final LatLng? selectedLocation;

  /// Callback triggered when the user taps on the map.
  final Function(LatLng) onTap;

  /// Callback triggered when the map is created.
  final Function(GoogleMapController) onMapCreated;

  /// Creates a [LocationMapWidget] with required callbacks and optional marker.
  const LocationMapWidget({
    super.key,
    required this.selectedLocation,
    required this.onTap,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(10.654, -61.502), // Default center: UWI, Trinidad
          zoom: 12,
        ),
        onMapCreated: onMapCreated,
        onTap: onTap,
        markers: selectedLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }
}
