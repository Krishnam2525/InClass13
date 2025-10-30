import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const SignupAdventureApp());

class SignupAdventureApp extends StatelessWidget {
  const SignupAdventureApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup Adventure',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true, // If FlutLab theme errors, set to false.
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
