import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  static const emojis = ['🧙‍♂️', '👩‍🚀', '🐉', '🦊', '🤖'];
  final int? selected;
  final ValueChanged<int> onPick;
  const AvatarPicker({super.key, required this.selected, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(emojis.length, (i) {
        final picked = selected == i;
        return GestureDetector(
          onTap: () => onPick(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: picked ? Colors.green : Colors.deepPurple, width: 2),
              color: picked ? Colors.green.withOpacity(.08) : Colors.white,
            ),
            child: Text(emojis[i], style: const TextStyle(fontSize: 28)),
          ),
        );
      }),
    );
  }
}
