import 'package:flutter/material.dart';

import 'package:yoyo_chatt/src/shared/constants/app_sizes.dart';

/// Primary button based on [ElevatedButton]. Useful for CTAs in the app.
class PrimaryButton extends StatelessWidget {
  /// Create a PrimaryButton.
  /// if [isLoading] is true, a loading indicator will be displayed instead of
  /// the text.
  const PrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.loadingIndicator,
    this.onPressed,
    this.fontSize = Sizes.p20,
  });

  final String text;
  final bool isLoading;
  final Widget? icon;
  final Widget? loadingIndicator;
  final VoidCallback? onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    const progress = SizedBox(
      height: Sizes.p16,
      width: Sizes.p16,
      child: CircularProgressIndicator(),
    );

    if (icon != null) {
      return SizedBox(
        height: 50,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: icon!,
          label: isLoading
              ? loadingIndicator ?? progress
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      );
    }

    return SizedBox(
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        child: isLoading
            ? loadingIndicator ?? progress
            : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                // style: context.textTheme.titleMedium?.copyWith(
                //   fontSize: Sizes.p20,
                //   color: context.colorScheme.onPrimary,
                //   fontWeight: FontWeight.w500,
                // ),
              ),
      ),
    );
  }
}
