import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.bounceOut,
                width: 120, height: 120,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple, shape: BoxShape.circle),
                child: const Icon(Icons.emoji_emotions, color: Colors.white, size: 64),
              ),
              const SizedBox(height: 32),
              AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Join The Adventure!',
                    speed: const Duration(milliseconds: 90),
                    textStyle: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Create your account and start your journey',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text('Start Adventure', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
