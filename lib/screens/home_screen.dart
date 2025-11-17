import 'package:flutter/material.dart';
import 'report_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/home_background.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          Column(
            children: [
              const Spacer(flex: 2),
              Center(
                child: Column(
                  children: [
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          14,
                          97,
                          11,
                        ), // Green
                        foregroundColor: Colors.white, // White text
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
