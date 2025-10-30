import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  final String userName;
  final String avatarEmoji;
  final List<String> badges;
  const SuccessScreen({
    super.key,
    required this.userName,
    required this.avatarEmoji,
    required this.badges,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 8))..play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.deepPurple, Colors.purple, Colors.blue, Colors.green, Colors.orange],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.elasticOut,
                    width: 140, height: 140,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                    child: Center(child: Text(widget.avatarEmoji, style: const TextStyle(fontSize: 64))),
                  ),
                  const SizedBox(height: 28),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome, ${/* to avoid analyzer confusion */ ''}${widget.userName}! 🎉',
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 90),
                        textStyle: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Your adventure begins now!', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  if (widget.badges.isNotEmpty) _badgeGrid(widget.badges),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () => _confetti.play(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('More Celebration!', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeGrid(List<String> badges) {
    IconData iconFor(String b) {
      if (b.contains('Password')) return Icons.security;
      if (b.contains('Early')) return Icons.wb_sunny;
      return Icons.verified;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: badges.map((b) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.deepPurple, width: 1.5),
              boxShadow: [BoxShadow(blurRadius: 6, color: Colors.deepPurple.withOpacity(.08))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(iconFor(b), color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(b, style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
          )).toList(),
        ),
      ],
    );
  }
}
