import 'package:flutter/material.dart';

class ProgressTracker extends StatelessWidget {
  final double percent; // 0..1
  const ProgressTracker({super.key, required this.percent});

  String get label => percent >= 1
      ? 'Ready for adventure!'
      : percent >= .75
          ? 'Almost done!'
          : percent >= .5
              ? 'Halfway there!'
              : percent >= .25
                  ? 'Great start!'
                  : 'Let’s begin!';

  @override
  Widget build(BuildContext context) {
    final p = (percent.clamp(0, 1) * 100).round();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 14,
              value: percent.clamp(0, 1),
              backgroundColor: Colors.grey.shade300,
              color: Colors.deepPurple,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text('$p%', style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: Colors.grey)),
    ]);
  }
}
