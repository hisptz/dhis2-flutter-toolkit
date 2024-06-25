import 'package:flutter/material.dart';

import '../components/d2_app_action_sheet_modal_container.dart';
import '../components/d2_app_confirmation_container.dart';

/// Utility class for showing modals in an application.
class D2AppModalUtil {
  /// Shows an action sheet modal with a custom container.
  ///
  /// This method uses [showModalBottomSheet] from Flutter's Material library to
  /// display the action sheet.
  ///
  /// Parameters:
  /// - [context] The BuildContext required for the showModalBottomSheet method.
  /// - [actionSheetContainer] The widget that represents the content of the action
  ///   sheet.
  /// - [title] The title of the action sheet.
  /// - [titleColor] The color for the title of the action sheet.
  /// - [initialHeightRatio] The initial height ratio of the action sheet. Defaults
  ///   to 0.3.
  /// - [minHeightRatio] The minimum height ratio of the action sheet. Defaults to
  ///   0.1.
  /// - [maxHeightRatio] The maximum height ratio of the action sheet. Defaults to
  ///   0.85.
  /// - [topBorderRadius] The top border radius of the action sheet. Defaults to
  ///   20.0.
  static Future showActionSheetModal(
    BuildContext context, {
    required Widget actionSheetContainer,
    String title = '',
    Color titleColor = const Color(0xFF619E51),
    double initialHeightRatio = 0.3,
    double minHeightRatio = 0.1,
    double maxHeightRatio = 0.85,
    double topBorderRadius = 20.0,
  }) {
    // Ensures that the maxHeightRatio is not greater than 0.85 if it's less than
    // the initialHeightRatio.
    maxHeightRatio = maxHeightRatio > 0 ? maxHeightRatio : 0.85;

    // showModalBottomSheet is a Flutter method that displays a bottom sheet,
    // which is a piece of secondary content that slides up from the bottom of
    // the screen.
    return showModalBottomSheet(
      context: context, // The BuildContext required for showModalBottomSheet.
      isDismissible: false, // Whether the user can dismiss the bottom sheet by
      // dragging it down.
      isScrollControlled: true, // Whether the bottom sheet can be scrolled.
      backgroundColor: Colors.transparent, // Transparent background color.
      builder: (context) => D2AppActionSheetModalContainer(
        title: title,
        titleColor: titleColor,
        actionSheetContainer: actionSheetContainer,
        initialHeightRatio: initialHeightRatio,
        minHeightRatio: minHeightRatio,
        maxHeightRatio: maxHeightRatio,
        topBorderRadius: topBorderRadius,
      ),
    );
  }

  /// Shows a pop-up confirmation dialog with customizable properties.
  ///
  /// This function is used to display a dialog with a title, border radius,
  /// padding, margin, theme color, confirmation button theme color,
  /// action button alignment, confirmation content, custom confirmation
  /// action buttons, and an onConfirm callback.
  ///
  /// Parameters:
  /// - [context] The BuildContext required for showDialog method.
  /// - [title] The title of the dialog.
  /// - [cancelActionLabel] Label for the cancel action button.
  /// - [confirmActionLabel] Label for the confirm action button.
  /// - [borderRadius] Border radius of the dialog. Defaults to 16.0.
  /// - [confirmationContainerPadding] Padding of the dialog content. Defaults to 5.0.
  /// - [confirmationContainerMargin] Margin of the dialog content. Defaults to 16.0.
  /// - [themColor] Theme color of the dialog. Defaults to Color(0xFF619E51).
  /// - [confirmationButtomThemColor] Theme color of the confirmation button. Defaults to Color(0xFF619E51).
  /// - [actionButtomAlignment] Alignment of the action buttons. Defaults to MainAxisAlignment.center.
  /// - [confirmationContent] Widget representing the content of the confirmation dialog.
  /// - [customConfirmationActionButtons] List of custom action buttons.
  /// - [onConfirm] Callback for the confirm action.
  static void showPopUpConfirmation(
    BuildContext context, {
    String title = '',
    String cancelActionLabel = 'Cancel',
    String confirmActionLabel = 'Confirm',
    double borderRadius = 16.0,
    double confirmationContainerPadding = 5.0,
    double confirmationContainerMargin = 16.0,
    Color themColor = const Color(0xFF619E51),
    Color confirmationButtomThemColor = const Color(0xFF619E51),
    MainAxisAlignment actionButtomAlignment = MainAxisAlignment.center,
    Widget? confirmationContent,
    List<Widget> customConfirmationActionButtons = const [],
    VoidCallback? onConfirm,
  }) async {
    double width = MediaQuery.of(context).size.width;

    // Display the dialog using showDialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a SimpleDialog with a custom shape, padding,
        // margin, background color, and alignment
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          insetPadding: EdgeInsets.all(confirmationContainerMargin),
          titlePadding: title.isNotEmpty
              ? EdgeInsets.all(confirmationContainerPadding)
              : const EdgeInsets.all(0.0),
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          // Display the title if it is not empty
          title: Visibility(
            visible: title.isNotEmpty,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                vertical: confirmationContainerPadding,
              ),
              child: Text(
                title,
                style: const TextStyle().copyWith(
                  color: themColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // Add padding to the content
          contentPadding: EdgeInsets.all(confirmationContainerPadding),
          children: [
            // Display the confirmation content if it is not null
            Visibility(
              visible: confirmationContent != null,
              child: Container(
                width: width,
                margin: EdgeInsets.symmetric(
                  horizontal: confirmationContainerPadding,
                  vertical: confirmationContainerMargin,
                ),
                child: confirmationContent,
              ),
            ),
            // Display the custom confirmation action buttons or a default row of buttons
            D2AppConfirmationContainer(
              width: width,
              cancelActionLabel: cancelActionLabel,
              confirmActionLabel: confirmActionLabel,
              themColor: themColor,
              confirmationButtomThemColor: confirmationButtomThemColor,
              actionButtomAlignment: actionButtomAlignment,
              customConfirmationActionButtons: customConfirmationActionButtons,
              confirmationContainerPadding: confirmationContainerPadding,
              onConfirm: onConfirm,
            )
          ],
        );
      },
    );
  }
}
