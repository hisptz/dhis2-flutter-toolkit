import 'package:flutter/material.dart';

class D2AppConfirmationContainer extends StatelessWidget {
  const D2AppConfirmationContainer({
    super.key,
    required this.width,
    required this.cancelActionLabel,
    required this.confirmActionLabel,
    required this.themColor,
    required this.confirmationButtomThemColor,
    required this.confirmationContainerPadding,
    required this.actionButtomAlignment,
    required this.customConfirmationActionButtons,
    this.onConfirm,
  });

  final String cancelActionLabel;
  final String confirmActionLabel;

  final Color themColor;
  final Color confirmationButtomThemColor;
  final double width;
  final double confirmationContainerPadding;
  final MainAxisAlignment actionButtomAlignment;
  final List<Widget> customConfirmationActionButtons;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(
        vertical: confirmationContainerPadding,
      ),
      child: Row(
        mainAxisAlignment: actionButtomAlignment,
        children: customConfirmationActionButtons.isNotEmpty
            ? customConfirmationActionButtons
            : [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: OutlinedButton(
                    style: const ButtonStyle().copyWith(
                      foregroundColor: MaterialStatePropertyAll(themColor),
                      side: MaterialStatePropertyAll(
                        const BorderSide().copyWith(
                          color: themColor,
                        ),
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle().copyWith(
                          color: themColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelActionLabel),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: FilledButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor: MaterialStateProperty.all(
                          confirmationButtomThemColor),
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle().copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: Text(confirmActionLabel),
                  ),
                ),
              ],
      ),
    );
  }
}
