import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    super.key,
    required this.onSettingsTap
  });

  final Function() onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Your Profile",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary
            ),
          ),

          SecondaryButton(
            onTap: onSettingsTap,
            child: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          )
        ],
      ),
    );
  }
}