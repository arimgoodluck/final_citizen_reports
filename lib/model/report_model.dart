/// A data model representing a citizen-submitted incident report.
///
/// Each report includes metadata such as title, description, location coordinates,
/// and severity level. This class supports JSON deserialization for integration
/// with APIs or local storage.
class Report {
  /// Short title of the report (e.g., "Flooded Street").
  final String title;

  /// Detailed description of the incident.
  final String description;

  /// Latitude coordinate of the incident location.
  final double latitude;

  /// Longitude coordinate of the incident location.
  final double longitude;

  /// Severity level of the incident (e.g., "Low", "Medium", "High").
  final String severity;

  /// Creates a [Report] instance with all required fields.
  ///
  /// All parameters are mandatory to ensure complete metadata.
  Report({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.severity,
  });

  /// Converts the [Report] instance to a Map for storage or fake service usage.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'severity': severity,
    };
  }

  /// Creates a [Report] instance from a JSON map.
  /// This factory constructor handles missing fields gracefully:
  /// - Defaults `title` and `description` to empty strings (`''`)
  /// - Converts `latitude` and `longitude` to `double` safely
  /// - Defaults `severity` to `'Unknown'` if not provided

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      severity: json['severity'] ?? 'Unknown',
    );
  }
}
