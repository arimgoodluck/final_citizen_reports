import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../model/report_model.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  /// Submit a report with image upload and database insert
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

  /// Fetch all reports from the database
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
