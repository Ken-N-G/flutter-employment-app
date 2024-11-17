import 'package:flutter/material.dart';

class SolicitorProfilePicture extends StatelessWidget {
  const SolicitorProfilePicture({
    super.key,
    this.profileUrl,
    this.onProfileTap,
    this.size = 120,
  });

  final Function()? onProfileTap;
  final String? profileUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: (profileUrl != null && profileUrl!.isNotEmpty) ? Colors.transparent : Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: onProfileTap,
          child: (profileUrl != null && profileUrl!.isNotEmpty) ?
           Image.network(
            fit: BoxFit.cover,
            profileUrl!,
            height: size,
            width: size,
            errorBuilder: (context, error, stackTrace) {
              return Ink(
                height: size,
                width: size,
                child: Icon(
                  Icons.supervisor_account_rounded,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: size / 1.3,
                )
              );
            },
          ) :
          Ink(
            height: size,
            width: size,
            child: Icon(
              Icons.supervisor_account_rounded,
              color: Theme.of(context).colorScheme.onSecondary,
              size: size / 1.3,
            )
          ) 
        ),
      ),
    );
  }
}