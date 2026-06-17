import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF11998E), // Teal Green
              Color(0xFF38EF7D), // Lime Green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Icon container
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 72,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(curve: Curves.elasticOut, duration: 600.ms),
              const SizedBox(height: 24),
              // Title
              Text(
                'Fitness Tracker',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0, delay: 200.ms, duration: 500.ms),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'Track. Train. Transform.',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.75),
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
              const Spacer(flex: 2),
              // Progress bar
              SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
