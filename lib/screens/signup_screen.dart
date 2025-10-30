import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/validators.dart';
import '../widgets/progress_tracker.dart';
import '../widgets/password_strength.dart';
import '../widgets/avatar_picker.dart';
import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final dobC = TextEditingController();
  bool showPass = false, loading = false;
  int? avatarIndex;

  late final AnimationController shakeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> shake = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
  ]).animate(CurvedAnimation(parent: shakeCtrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    dobC.dispose();
    shakeCtrl.dispose();
    super.dispose();
  }

  bool get nameOk => nameC.text.trim().isNotEmpty;
  bool get emailOk => Validators.isEmail(emailC.text.trim());
  bool get dobOk => dobC.text.isNotEmpty;
  int get pScore => PasswordHeuristics.score(passC.text);
  bool get passStrong => pScore >= 4;
  bool get avatarOk => avatarIndex != null;

  double get progress {
    final steps = [nameOk, emailOk, dobOk, passStrong, avatarOk];
    final done = steps.where((e) => e).length;
    return done / steps.length;
  }

  List<String> get badges {
    final out = <String>[];
    if (passStrong) out.add('Strong Password Master');
    if (DateTime.now().hour < 12) out.add('The Early Bird Special');
    if (nameOk && emailOk && dobOk && passC.text.isNotEmpty && avatarOk) {
      out.add('Profile Completer');
    }
    return out;
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (d != null) setState(() => dobC.text = '${d.day}/${d.month}/${d.year}');
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false) ||
        !avatarOk ||
        !passStrong) {
      shakeCtrl.forward(from: 0);
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 1200),
        content: Text(!avatarOk
            ? 'Pick an avatar to continue'
            : (!passStrong
                ? 'Make the password stronger (CAPS, digit, symbol)'
                : 'Fix the fields')),
      ));
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => loading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          userName: nameC.text.trim(),
          avatarEmoji: AvatarPicker.emojis[avatarIndex!],
          badges: badges,
        ),
      ),
    );
  }

  InputBorder fieldBorder(bool ok) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ok ? Colors.green : Colors.grey.shade400),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Account 🎉')),
      body: AnimatedBuilder(
        animation: shakeCtrl,
        builder: (c, child) =>
            Transform.translate(offset: Offset(shake.value, 0), child: child),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InfoCard(),
                    const SizedBox(height: 16),
                    ProgressTracker(percent: progress),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: nameC,
                      decoration: InputDecoration(
                        labelText: 'Adventure Name',
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: nameOk
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        border: fieldBorder(nameOk),
                        enabledBorder: fieldBorder(nameOk),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'What should we call you?' : null,
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email),
                        suffixIcon: emailOk
                            ? const Text(' 🎉', style: TextStyle(fontSize: 18))
                            : null,
                        border: fieldBorder(emailOk),
                        enabledBorder: fieldBorder(emailOk),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) => Validators.isEmail(v!.trim())
                          ? null
                          : 'Enter a valid email',
                    ),
                    const SizedBox(height: 12),

                    // DOB
                    TextFormField(
                      controller: dobC,
                      readOnly: true,
                      onTap: pickDate,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: pickDate),
                        border: fieldBorder(dobOk),
                        enabledBorder: fieldBorder(dobOk),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tap to pick your date'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Password + strength
                    TextFormField(
                      controller: passC,
                      obscureText: !showPass,
                      decoration: InputDecoration(
                        labelText: 'Secret Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(showPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() => showPass = !showPass),
                        ),
                        border: fieldBorder(passStrong),
                        enabledBorder: fieldBorder(passStrong),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'At least 6 characters';
                        if (!passStrong)
                          return 'Try a capital, a number, and a symbol';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    PasswordStrength(score: pScore),

                    const SizedBox(height: 18),

                    // Avatar
                    Text('Choose Your Avatar',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    AvatarPicker(
                      selected: avatarIndex,
                      onPick: (i) => setState(() => avatarIndex = i),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 54,
                      child: loading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              onPressed: submit,
                              icon: const Icon(Icons.rocket_launch,
                                  color: Colors.white),
                              label: const Text('Start My Adventure',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, color: Colors.deepPurple[800]),
          const SizedBox(width: 10),
          Expanded(
              child: Text('Complete your adventure profile!',
                  style: TextStyle(
                      color: Colors.deepPurple[800],
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
