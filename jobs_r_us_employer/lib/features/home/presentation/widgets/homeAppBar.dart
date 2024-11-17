import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar(
    {super.key,
    this.profileUrl,
    required this.alias,
    required this.onProfileTap,
    required this.onNotificationsTap,
  });

  final String? profileUrl;
  final String alias;
  final Function() onProfileTap;
  final Function() onNotificationsTap;

  Widget _setProfilePicture(String? profileUrl, BuildContext context) {
    if (profileUrl != null) {
      if (profileUrl.isNotEmpty) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary
          ),
          child: Image.network(
            fit: BoxFit.cover,
            profileUrl,
            width: 48,
            height: 48,
          ),
        );
      } else {
        return SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            Icons.person_rounded,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        );
      }
    } else {
      return SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          Icons.person_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: (profileUrl == null || profileUrl!.isEmpty) ? Theme.of(context).colorScheme.secondary : Colors.transparent,
          shape: (profileUrl == null || profileUrl!.isEmpty) ? const CircleBorder() : null,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onProfileTap,
            child: _setProfilePicture(profileUrl, context),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome,",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            Text(
              alias,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ],
        ),

        const Spacer(),

        SecondaryButton(
          onTap: onNotificationsTap,
          child: 
          Icon(
            Icons.notifications_rounded, 
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        )
      ],
    );
  }
}
