import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:web_flut/presentation/auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final double _duration = 0.5;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const SignInScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/bookshelf-icon.webp', height: 200),
                const SizedBox(height: 20),
                Text(
                  'My Bookshelf',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SpinKitWaveSpinner(color: theme.colorScheme.primary, duration: Duration(milliseconds: 1000),),
                const SizedBox(height: 10),
                Text(
                  'Developed by Randy Dinky Saputra',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ).animate().fadeIn(duration: _duration.seconds).scale(begin: Offset(0.5, 0.5), end: Offset(1.0, 1.0), duration: _duration.seconds),
      ),
    );
  }
}
