import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../model/report_model.dart';

class ReportViewerScreen extends StatelessWidget {
  const ReportViewerScreen({super.key});

  Future<List<Report>> _loadReports() => SupabaseService.fetchReports();

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('View Reports')),
        body: FutureBuilder<List<Report>>(
          future: _loadReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading reports',
                  style: TextStyle(color: Colors.redAccent),
                ),
              );
            }
            final reports = snapshot.data ?? [];
            if (reports.isEmpty) {
              return const Center(child: Text('No reports found.'));
            }

            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final r = reports[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(r.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.description),
                        const SizedBox(height: 4),
                        Text(
                          'Location: ${r.latitude.toStringAsFixed(4)}, ${r.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _severityColor(r.severity),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        r.severity,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
