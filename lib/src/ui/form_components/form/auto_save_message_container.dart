import 'package:flutter/material.dart';

class AutoSaveMessageContainer extends StatelessWidget {
  const AutoSaveMessageContainer({
    super.key,
    required this.onDeleteAutoSavedData,
    required this.onContinue,
    required this.formColor,
    this.autoSaveMessage,
  });

  final String? autoSaveMessage;
  final Color formColor;
  final Function onDeleteAutoSavedData;
  final Function onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          autoSaveMessage ??
              'Would you like to continue with the auto-saved data available?',
          textAlign: TextAlign.center,
        )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FilledButton(
                  style: const ButtonStyle().copyWith(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(Colors.grey[600]),
                    textStyle: WidgetStateProperty.all(
                      const TextStyle().copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: onDeleteAutoSavedData(),
                  child: Container(
                    alignment: Alignment.center,
                    width: 30.0,
                    child: Text(
                      'Skip',
                      style: const TextStyle().copyWith(),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FilledButton(
                  style: const ButtonStyle().copyWith(
                    backgroundColor: WidgetStateProperty.all(formColor),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    textStyle: WidgetStateProperty.all(
                      const TextStyle().copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: onContinue(),
                  child: Container(
                    alignment: Alignment.center,
                    width: 60.0,
                    child: Text(
                      'Continue',
                      style: const TextStyle().copyWith(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
