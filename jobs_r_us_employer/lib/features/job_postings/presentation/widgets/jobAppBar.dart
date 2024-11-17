import 'package:flutter/material.dart';

class JobAppBar extends StatelessWidget {
  const JobAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        children: [
          Text(
            "Your Jobs",
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}