import 'package:flutter/material.dart';

class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.contentEmpty,
    required this.sectionHeader,
    required this.children,
  });

  final bool contentEmpty;
  final String sectionHeader;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          sectionHeader,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 20,),

        contentEmpty ?
          Material(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "This section has not been filled!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
      ],
    );
  }
}