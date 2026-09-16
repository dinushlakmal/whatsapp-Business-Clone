import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/screens/home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;
  final List<String> _steps = [
    'Initializing WhatsApp Business...',
    'Creating business catalog and settings...',
    'Configuring messaging tools & quick replies...',
    'Almost ready...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _runSetupSteps();
  }

  void _runSetupSteps() async {
    for (int i = 1; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
      }
    }

    // Persist login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // WhatsApp Business Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A884).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/wb.png',
                      width: 64,
                      height: 64,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.storefront_rounded,
                        size: 54,
                        color: Color(0xFF00A884),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Setting up your Business Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF075E54),
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _steps[_currentStep],
                    key: ValueKey<int>(_currentStep),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const SizedBox(
                  width: 38,
                  height: 38,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A884)),
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      'End-to-end encrypted',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
