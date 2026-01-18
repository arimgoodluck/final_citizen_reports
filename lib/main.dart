import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/report_form_screen.dart';

/// The main entry point of the Citizen Report application.
/// Initializes Flutter bindings and connects to Supabase backend.
/// Launches the app with [MyApp] as the root widget.
Future<void> main() async {
  // Ensures Flutter engine is initialized before async operations.
  WidgetsFlutterBinding.ensureInitialized();

  // Launch confirmation for debugging and console visibility.
  print('Launching Citizen Report from final_citizensreport');

  // Supabase initialization with project URL and anonymous key.
  // This enables authentication, storage, and database access.
  await Supabase.initialize(
    url: 'https://yshddxrtqrewnjmesogr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlzaGRkeHJ0cXJld25qbWVzb2dyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3MDEzNzcsImV4cCI6MjA3ODI3NzM3N30.'
        'LPIV4P5OA08RRRaWDVf8V4i0hx6wgyMt2EGkUNP4kOY',
  );

  // Launches the root widget of the app.
  runApp(const MyApp());
}

/// The root widget of the Citizen Report application.
/// Sets up global theme, disables debug banner, and defines navigation routes.
class MyApp extends StatelessWidget {
  /// Constructs the root [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the debug banner in release mode.
      debugShowCheckedModeBanner: false,

      // App title used by the OS and task manager.
      title: 'Citizen Report',

      // Global theme configuration:
      // - Primary color: Deep Purple
      // - Font family: Georgia
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Georgia'),

      // Initial screen shown when the app launches.
      home: const HomeScreen(),

      // Named routes for navigation.
      // '/report' → opens the report submission form.
      routes: {'/report': (_) => const ReportFormScreen()},
    );
  }
}
