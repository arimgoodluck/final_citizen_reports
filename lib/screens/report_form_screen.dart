import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/location_map_widget.dart';

/// A screen that allows users to submit a citizen report.
/// Users can select a predefined issue type or enter a custom title, write a description, choose severity, capture an image and select a location.
/// The report is then submitted to Supabase.
class ReportFormScreen extends StatefulWidget {
  /// Creates a [ReportFormScreen] widget.
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  /// Common issue titles for quick selection.
  final List<String> _commonTitles = [
    'Pothole',
    'Broken Streetlight',
    'Flooding',
    'Illegal Dumping',
    'Other',
  ];

  String? _selectedTitle;
  bool _showCustomTitle = false;

  XFile? _image;
  String? _severity;
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  /// Opens the camera to capture an image.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _image = picked);
    }
  }

  /// Requests location permission and retrieves the user's current location.
  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition();
    final latLng = LatLng(pos.latitude, pos.longitude);
    setState(() => _selectedLocation = latLng);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
  }

  /// Validates input and submits the report to Supabase.
  Future<void> _submitReport() async {
    if (_image == null || _selectedLocation == null || _severity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    final file = File(_image!.path);
    if (!file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image file not found. Please retake the photo.'),
        ),
      );
      return;
    }

    final xfile = XFile(file.path);
    final title = _showCustomTitle
        ? _titleController.text
        : _selectedTitle ?? '';

    try {
      await SupabaseService.submitReport(
        title: title,
        description: _descController.text,
        image: xfile,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        severity: _severity!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Submission failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit a Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 16),

            /// Dropdown for selecting issue type.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Issue Type'),
              items: _commonTitles.map((title) {
                return DropdownMenuItem(value: title, child: Text(title));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTitle = value;
                  _showCustomTitle = value == 'Other';
                });
              },
            ),

            /// Text field for custom title if "Other" is selected.
            if (_showCustomTitle)
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Custom Title'),
              ),

            const SizedBox(height: 12),

            /// Description input field.
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),

            const SizedBox(height: 12),

            /// Dropdown for selecting severity level.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Severity'),
              items: [
                DropdownMenuItem(
                  value: 'Low',
                  child: Text('Low', style: TextStyle(color: Colors.green)),
                ),
                DropdownMenuItem(
                  value: 'Medium',
                  child: Text('Medium', style: TextStyle(color: Colors.orange)),
                ),
                DropdownMenuItem(
                  value: 'High',
                  child: Text('High', style: TextStyle(color: Colors.red)),
                ),
              ],
              onChanged: (value) => setState(() => _severity = value),
            ),

            const SizedBox(height: 12),

            /// Button to capture image.
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture Image'),
            ),

            /// Display captured image preview.
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.file(
                  File(_image!.path),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 12),

            /// Button to fetch current location.
            ElevatedButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Use My Location'),
            ),

            const SizedBox(height: 12),
            const Text('Select Location on Map'),

            /// Interactive map widget for selecting location.
            LocationMapWidget(
              selectedLocation: _selectedLocation,
              onTap: (latLng) => setState(() => _selectedLocation = latLng),
              onMapCreated: (controller) => _mapController = controller,
            ),

            const SizedBox(height: 20),

            /// Submit button.
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 14, 97, 11),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: _submitReport,
                child: const Text('Submit Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
