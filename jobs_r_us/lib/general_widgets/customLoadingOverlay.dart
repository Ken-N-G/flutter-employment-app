import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  const CustomLoadingOverlay({
    super.key,
    this.enableDarkBackground = false,
  });

  final bool enableDarkBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: enableDarkBackground ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3) : Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}