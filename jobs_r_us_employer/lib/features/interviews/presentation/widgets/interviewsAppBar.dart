import 'package:flutter/material.dart';

class InterviewsAppBar extends StatelessWidget {
  const InterviewsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        children: [
          Text(
            "Wawancara Anda",
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}