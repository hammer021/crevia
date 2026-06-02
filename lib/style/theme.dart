import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();
  static const Color loginGradientStart = Color.fromARGB(156, 84, 252, 238);
  static const Color loginGradientEnd = Color.fromARGB(236, 98, 151, 221);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
