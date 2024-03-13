import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputFieldIcon extends StatelessWidget {
  final String? svgIcon;
  final IconData? iconData;
  final Color? iconColor;
  final Color backgroundColor;

  const InputFieldIcon(
      {super.key,
      this.iconData,
      this.svgIcon,
      required this.backgroundColor,
      this.iconColor});

  Widget _getIcon() {
    if (svgIcon != null) {
      return SvgPicture.asset(svgIcon!,
          colorFilter: ColorFilter.mode(
            iconColor ?? Colors.black,
            BlendMode.srcATop,
          ));
    }
    if (iconData != null) {
      return Icon(
        iconData,
        color: iconColor,
      );
    }
    return const Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 5, top: 5),
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Center(
            child: _getIcon(),
          ),
        ));
  }
}
