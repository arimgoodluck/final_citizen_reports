import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../model/report_model.dart';

class SupabaseService {
  /// Allows overriding the client for tests
  static SupabaseClient? testClient;

  /// The real production client, unless test overrides it
  static SupabaseClient get _client => testClient ?? Supabase.instance.client;

  /// Upload an image to Supabase
  static Future<String> uploadImage(XFile file) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      final String fileName = '${const Uuid().v4()}.jpg';

      await _client.storage.from('report_images').uploadBinary(fileName, bytes);

      final String url = _client.storage
          .from('report_images')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      print("Upload error: $e");
      rethrow;
    }
  }

  /// Insert report in database
  static Future<void> submitReport({
    required String title,
    required String description,
    required XFile image,
    required double latitude,
    required double longitude,
    required String severity,
  }) async {
    try {
      final imageUrl = await uploadImage(image);

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
        throw Exception("Insert returned no data");
      }
    } catch (e) {
      print("Supabase insert error: $e");
      rethrow;
    }
  }

  /// Fetch reports from Supabase
  static Future<List<Report>> fetchReports() async {
    try {
      final response = await _client
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      final list = response as List;
      return list.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      print("Fetch error: $e");
      return [];
    }
  }
}
