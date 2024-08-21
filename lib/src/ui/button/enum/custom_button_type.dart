import 'package:flutter/material.dart';

enum CustomButtonType {
  primaryButton,
  textButton,
  outlineButton,
}

typedef OnPressed = void Function(BuildContext context);
