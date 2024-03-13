import 'package:flutter/material.dart';

class LineSeparator extends StatelessWidget {
  const LineSeparator({
    super.key,
    required this.color,
    this.height = 1.5,
  });

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: height,
            color: color,
          ),
        ),
      ),
    );
  }
}
