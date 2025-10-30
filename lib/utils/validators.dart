
class Validators {
  static bool isEmail(String s) => s.contains('@') && s.contains('.');
  static String strengthLabel(int score) => switch (score) {
    0 || 1 => 'Weak',
    2 => 'Fair',
    3 => 'Good',
    4 => 'Strong',
    _ => 'Very Strong',
  };
}

class PasswordHeuristics {
  static int score(String p) {
    int s = 0;
    if (p.length >= 6) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) s++;
    if (p.length >= 10) s++;
    return s; // 0..5
  }
}
