class Report {
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String severity;

  Report({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.severity,
  });

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
