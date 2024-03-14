import 'package:flutter/material.dart';

class D2AppActionSheetModalContainer extends StatelessWidget {
  // Parameters:
  // - actionSheetContainer: The widget that represents the content of the action
  //   sheet.
  // - initialHeightRatio: The initial height ratio of the action sheet.
  // - minHeightRatio: The minimum height ratio of the action sheet.
  // - maxHeightRatio: The maximum height ratio of the action sheet.
  // - topBorderRadius: The top border radius of the action sheet.
  const D2AppActionSheetModalContainer({
    super.key,
    required this.actionSheetContainer,
    required this.initialHeightRatio,
    required this.minHeightRatio,
    required this.maxHeightRatio,
    required this.topBorderRadius,
  });

  final Widget actionSheetContainer;
  final double initialHeightRatio;
  final double minHeightRatio;
  final double maxHeightRatio;
  final double topBorderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // A GestureDetector widget that detects gestures and triggers callbacks
      // when a gesture is recognized.
      behavior: HitTestBehavior.opaque, // Makes the GestureDetector opaque.
      onTap: () => Navigator.of(context).pop(), // Closes the bottom sheet.
      child: GestureDetector(
        // Another GestureDetector that does not react to taps.
        onTap: () {},
        child: DraggableScrollableSheet(
          // A scrollable sheet that can be dragged to reveal or hide its content.
          initialChildSize: initialHeightRatio, // Initial height ratio.
          maxChildSize: maxHeightRatio < initialHeightRatio
              ? initialHeightRatio
              : maxHeightRatio, // Maximum height ratio.
          minChildSize: minHeightRatio < initialHeightRatio
              ? minHeightRatio
              : initialHeightRatio, // Minimum height ratio.
          builder: (
            BuildContext context,
            ScrollController scrollController,
          ) {
            // The builder function that returns the content of the sheet.
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ), // Adds padding to the bottom of the sheet to avoid covering
              // the on-screen keyboard.
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background color.
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(topBorderRadius),
                  ), // Top border radius.
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 1.0,
                  ), // Horizontal margin for the inner container.
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topBorderRadius),
                    ), // Top border radius for the inner container.
                  ),
                  child:
                      actionSheetContainer, // Dynamic widget for content of a specific action sheet
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
