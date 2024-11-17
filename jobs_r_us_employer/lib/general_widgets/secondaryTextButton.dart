import 'package:flutter/material.dart';

class SecondaryTextButton extends StatelessWidget {
  const SecondaryTextButton({
      super.key,
      required this.label,
      required this.onTap,
      this.backgroundColor
    }
  );

  final String label;
  final Function() onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
