import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../model/report_model.dart';

/// A service class for interacting with Supabase backend.
///
/// Handles image uploads to Supabase Storage and report data insertion/retrieval
/// from the Supabase database.
class SupabaseService {
  /// Supabase client instance used for storage and database operations.
  static final _client = Supabase.instance.client;

  /// Submits a citizen report to Supabase.
  ///
  /// This method performs the following steps:
  /// 1. Reads image bytes from the provided [XFile].
  /// 2. Uploads the image to Supabase Storage under the `report_images` bucket.
  /// 3. Retrieves the public URL of the uploaded image.
  /// 4. Inserts a new report record into the `reports` table with metadata.
  ///
  /// Throws an exception if the insert fails or returns no data.
  ///
  /// Example usage:
  /// ```dart
  /// await SupabaseService.submitReport(
  ///   title: 'Flooding',
  ///   description: 'Water overflow near Main Street',
  ///   image: capturedImage,
  ///   latitude: 10.654,
  ///   longitude: -61.501,
  ///   severity: 'High',
  /// );
  /// ```
  static Future<void> submitReport({
    required String title,
    required String description,
    required XFile image,
    required double latitude,
    required double longitude,
    required String severity,
  }) async {
    try {
      // ✅ Read image bytes as Uint8List
      final Uint8List bytes = await image.readAsBytes();
      final String fileName = '${const Uuid().v4()}.jpg';

      // ✅ Upload image to Supabase Storage
      await _client.storage.from('report_images').uploadBinary(fileName, bytes);

      // ✅ Get public URL of uploaded image
      final String imageUrl = _client.storage
          .from('report_images')
          .getPublicUrl(fileName);

      // ✅ Insert full report into Supabase table
      final response = await _client.from('reports').insert({
        'title': title,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'severity': severity,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      if (response.isEmpty) {
        throw Exception('Insert failed or returned no data');
      }

      print('✅ Report submitted successfully');
    } catch (e) {
      print('❌ Supabase error: $e');
      rethrow;
    }
  }

  /// Fetches all submitted reports from the Supabase database.
  ///
  /// Retrieves data from the `reports` table, ordered by `created_at` descending.
  /// Converts each record into a [Report] model instance.
  ///
  /// Returns an empty list if an error occurs.
  ///
  /// Example usage:
  /// ```dart
  /// final reports = await SupabaseService.fetchReports();
  /// ```
  static Future<List<Report>> fetchReports() async {
    try {
      final response = await _client
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching reports: $e');
      return [];
    }
  }
}
