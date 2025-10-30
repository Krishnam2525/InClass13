import 'package:flutter/material.dart';
import '../utils/validators.dart';

class PasswordStrength extends StatelessWidget {
  final int score; // 0..5
  const PasswordStrength({super.key, required this.score});

  Color get color => switch (score) {
        0 || 1 => Colors.red,
        2 => Colors.orange,
        3 => Colors.yellow,
        4 => Colors.lightGreen,
        _ => Colors.green,
      };

  String get label => Validators.strengthLabel(score);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: score / 5,
            backgroundColor: Colors.grey.shade300,
            color: color,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
    ]);
  }
}
