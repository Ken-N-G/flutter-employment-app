import 'package:flutter/material.dart';

class ShadowAndPaddingContainer extends StatelessWidget {
  const ShadowAndPaddingContainer({
    super.key, 
    this.child,
    this.height,
    this.width
  }
);

  final Widget? child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 0.1,
              offset: const Offset(0.0, 2)
          ),
        ]
      ),
      child: child,
    );
  }
}