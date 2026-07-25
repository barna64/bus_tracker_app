import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import '../authgate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    ;
    return AnimatedSplashScreen(
      duration: 2000,
      backgroundColor: theme.colorScheme.primary,
      centered: true,
      splashIconSize: deviceHeight,
      splashTransition: SplashTransition.scaleTransition,
      curve: Curves.easeInOutCirc,
      splash: _buildSplashContent(context),
      nextScreen: const AuthGate(),
    );
  }

  Widget _buildSplashContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            'LU',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 8,
              height: 1,
            ),
          ),

          SizedBox(height: 5),
          const Text(
            'BUS TRACKER',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 12,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Your University Bus Companion',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Leading University',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
