import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/report_form_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚀 Launch confirmation
  print('🚀 Launching Citizen Report from final_citizensreport');

  // ✅ Supabase initialization
  await Supabase.initialize(
    url: 'https://yshddxrtqrewnjmesogr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlzaGRkeHJ0cXJld25qbWVzb2dyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3MDEzNzcsImV4cCI6MjA3ODI3NzM3N30.'
        'LPIV4P5OA08RRRaWDVf8V4i0hx6wgyMt2EGkUNP4kOY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Citizen Report',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Georgia'),
      home: const HomeScreen(),
      routes: {'/report': (_) => const ReportFormScreen()},
    );
  }
}
