import 'package:flutter/material.dart';
import 'report_form_screen.dart';

/// The main landing screen for the Citizen Report app.
///
/// Displays a welcoming background image, a semi-transparent overlay,
/// and a call-to-action button that navigates to the report submission form.
class HomeScreen extends StatelessWidget {
  /// Creates a stateless [HomeScreen] widget.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background image covering the entire screen.
          Image.asset('home_background.jpg', fit: BoxFit.cover),

          /// Semi-transparent black overlay for contrast.
          Container(color: Colors.black.withOpacity(0.4)),

          /// Main content column with spacing and centered text/button.
          Column(
            children: [
              const Spacer(flex: 2),

              /// Centered welcome message and navigation button.
              Center(
                child: Column(
                  children: [
                    /// App title text.
                    const Text(
                      'Welcome to Citizen Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Raleway',
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Button to navigate to the report form screen.
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 14, 97, 11),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportFormScreen(),
                          ),
                        );
                      },
                      child: const Text('Submit a Report'),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }
}
