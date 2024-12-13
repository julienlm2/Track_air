import 'package:flutter/material.dart';
import 'package:track_air/ParametrePage.dart';
import 'package:track_air/StartPage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo with larger size
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 48),
                        child: Image.asset(
                          'assets/logotrackair.png',
                          height: 200,  // Increased size
                          width: 200,   // Increased size
                        ),
                      ),
                    ),
                    // Buttons with modern styling
                    _buildButton(
                      context,
                      'Start Game',
                      Icons.play_arrow_rounded,
                      const Color(0xFF4CAF50),  // Softer green
                      () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Startpage())),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      'Stats & History',
                      Icons.bar_chart_rounded,
                      const Color(0xFF42A5F5),  // Pleasing blue
                      () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Startpage())),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      'Settings',
                      Icons.settings_rounded,
                      const Color(0xFF78909C),  // Soft blue-grey
                      () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const ParametrePage())),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 65,  // Slightly taller buttons
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12.0,
            spreadRadius: 0,
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,  // Removed default elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,  // Slightly lighter weight
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}