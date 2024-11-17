import 'package:flutter/material.dart';

class ErrorTextButton extends StatelessWidget {
  const ErrorTextButton({
    super.key,
    required this.label,
    required this.onTap
  });

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}