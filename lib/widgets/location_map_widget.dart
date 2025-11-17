import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapWidget extends StatelessWidget {
  final LatLng? selectedLocation;
  final Function(LatLng) onTap;
  final Function(GoogleMapController) onMapCreated;

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
          target: LatLng(10.654, -61.502),
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
