import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryTextButton.dart';

class EditableTextSection extends StatelessWidget {
  const EditableTextSection({
    super.key,
    required this.contentEmpty,
    required this.onEditTap,
    required this.body,
    required this.sectionHeader
  });

  final bool contentEmpty;
  final String sectionHeader;
  final String body;
  final Function() onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              sectionHeader,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            contentEmpty ?
              Container() :
              SecondaryButton(
                onTap: onEditTap,
                child: Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              )
          ],
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
                    "You have not filled this section!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          
                  const SizedBox(height: 5,),
          
                  SecondaryTextButton(
                    backgroundColor: Colors.transparent,
                    label: "Add",
                    onTap: onEditTap
                  )
                ],
              ),
            ),
          ) :
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}