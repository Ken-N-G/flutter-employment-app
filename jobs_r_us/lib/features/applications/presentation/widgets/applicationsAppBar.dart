import 'package:flutter/material.dart';

class ApplicationsAppBar extends StatelessWidget {
  const ApplicationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        children: [
          Text(
            "Your Applications",
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}