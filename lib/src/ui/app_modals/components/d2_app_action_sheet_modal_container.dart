import 'package:flutter/material.dart';

class D2AppActionSheetModalContainer extends StatelessWidget {
  // Parameters:
  // - title: The title of the action sheet.
  // - titleColor: The color for the title of the action sheet.
  // - actionSheetContainer: The widget that represents the content of the action
  //   sheet.
  // - initialHeightRatio: The initial height ratio of the action sheet.
  // - minHeightRatio: The minimum height ratio of the action sheet.
  // - maxHeightRatio: The maximum height ratio of the action sheet.
  // - topBorderRadius: The top border radius of the action sheet.
  const D2AppActionSheetModalContainer({
    super.key,
    required this.title,
    required this.titleColor,
    required this.actionSheetContainer,
    required this.initialHeightRatio,
    required this.minHeightRatio,
    required this.maxHeightRatio,
    required this.topBorderRadius,
  });

  final String title;
  final Color titleColor;
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
            return ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(topBorderRadius),
              ),
              child: Scaffold(
                appBar: title.isEmpty
                    ? null
                    : AppBar(
                        backgroundColor: Colors.transparent,
                        leading: Container(),
                        leadingWidth: 0.0,
                        elevation: 0.0,
                        scrolledUnderElevation: 0.0,
                        centerTitle: true,
                        titleSpacing: 0.0,
                        title: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: titleColor.withOpacity(0.1),
                                width: 2.0,
                              ),
                            ), // Top border radius.
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 10.0,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              title,
                              style: const TextStyle().copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ), // Adds padding to the bottom of the sheet to avoid covering
                    // the on-screen keyboard.
                    child: actionSheetContainer,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
