import 'dart:ui';

Color getTextColor(Color bgColor) {
  double brightness =
      (bgColor.red * 299 + bgColor.green * 587 + bgColor.blue * 114) / 1000;
  return brightness > 128 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
}
