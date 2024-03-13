import 'package:flutter/material.dart';

class FormFieldInputIcon extends StatelessWidget {
  const FormFieldInputIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    this.backGroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color? backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 5, top: 5),
        child: Container(
          decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Container(
            margin: const EdgeInsets.all(9),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ));
  }
}
