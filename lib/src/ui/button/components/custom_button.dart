import 'package:dhis2_flutter_toolkit/src/ui/button/enum/custom_button_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.label = '',
    this.iconData,
    this.svgIconSrc = '',
    this.borderRadius = 10.0,
    this.isTrailingIcon = false,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.buttonType = CustomButtonType.textButton,
    this.iconColor,
    this.labelColor,
    this.buttonPrimaryColor,
    this.buttonMargin = const EdgeInsets.symmetric(
      horizontal: 10.0,
    ),
    this.buttonPaading = const EdgeInsets.symmetric(
      horizontal: 15.0,
      vertical: 5.0,
    ),
    this.onTap,
  });

  final String label;
  final Color? labelColor;
  final String svgIconSrc;
  final IconData? iconData;
  final double borderRadius;
  final CustomButtonType buttonType;
  final bool isTrailingIcon;
  final bool isFullWidth;
  final bool isDisabled;
  final Color? iconColor;
  final Color? buttonPrimaryColor;
  final EdgeInsetsGeometry buttonPaading;
  final EdgeInsetsGeometry buttonMargin;

  final OnPressed? onTap;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  BorderRadius get borderRadius => BorderRadius.circular(widget.borderRadius);

  EdgeInsetsGeometry get buttonMargin => widget.buttonMargin;

  EdgeInsetsGeometry get buttonPaading => widget.buttonPaading;

  Color get labelColor => widget.isDisabled
      ? Colors.black38
      : widget.labelColor ?? Theme.of(context).colorScheme.inversePrimary;

  Color get iconColor => widget.isDisabled
      ? Colors.black38
      : widget.iconColor ?? Theme.of(context).colorScheme.inversePrimary;

  Color get buttonPrimaryColor => widget.isDisabled
      ? Colors.grey.withOpacity(0.1)
      : widget.buttonPrimaryColor ?? Theme.of(context).colorScheme.primary;

  BoxDecoration get decoration => BoxDecoration(
        color: widget.buttonType == CustomButtonType.primaryButton
            ? buttonPrimaryColor
            : Colors.transparent,
        borderRadius: borderRadius,
        border: Border.all(
          width: 1.3,
          color: widget.buttonType == CustomButtonType.textButton
              ? Colors.transparent
              : buttonPrimaryColor.withOpacity(
                  widget.buttonType == CustomButtonType.outlineButton
                      ? 0.4
                      : widget.isDisabled
                          ? 0.3
                          : 1.0,
                ),
        ),
      );

  Widget get label => Visibility(
        visible: widget.label.isNotEmpty,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0,
          ),
          child: Text(
            widget.label,
            style: const TextStyle().copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget get buttonIcon => Visibility(
        visible: widget.iconData != null || widget.svgIconSrc.isNotEmpty,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0,
          ),
          child: widget.svgIconSrc.isNotEmpty
              ? SvgPicture.asset(
                  widget.svgIconSrc,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  widget.iconData,
                  color: iconColor,
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: widget.isDisabled || widget.onTap == null
          ? null
          : () => widget.onTap!(context),
      child: Container(
        margin: buttonMargin,
        padding: buttonPaading,
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children:
              widget.isTrailingIcon ? [label, buttonIcon] : [buttonIcon, label],
        ),
      ),
    );
  }
}
