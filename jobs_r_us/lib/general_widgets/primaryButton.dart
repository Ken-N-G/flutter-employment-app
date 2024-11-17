import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
      super.key,
      required this.label,
      required this.onTap,
      this.width = double.infinity,
      this.overrideBackgroundColor,
      this.overrideTextColor,
      this.overrideTextStyle
    }
  );

  final String label;
  final Function() onTap;
  final double? width;
  final Color? overrideBackgroundColor;
  final Color? overrideTextColor;
  final TextStyle? overrideTextStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (overrideBackgroundColor == null) ? Theme.of(context).colorScheme.primary : overrideBackgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: (overrideTextStyle == null) ? Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: (overrideTextColor == null) ? Theme.of(context).colorScheme.onPrimary : overrideTextColor) : overrideTextStyle!.copyWith(
                    color: (overrideTextColor == null) ? Theme.of(context).colorScheme.onPrimary : overrideTextColor
                  )
                  
            ),
          ],
        ),
      ),
    );
  }
}
