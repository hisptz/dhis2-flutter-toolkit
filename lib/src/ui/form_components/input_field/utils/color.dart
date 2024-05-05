import 'dart:ui';

Color getTextColor(Color bgColor, {Color? darkColor, Color? lightColor}) {
  double brightness =
      (bgColor.red * 299 + bgColor.green * 587 + bgColor.blue * 114) / 1000;
  return brightness > 128
      ? darkColor ?? const Color(0xFF000000)
      : lightColor ?? const Color(0xFFFFFFFF);
}
