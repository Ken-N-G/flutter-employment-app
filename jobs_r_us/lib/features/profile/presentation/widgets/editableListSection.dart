import 'package:flutter/material.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/secondaryTextButton.dart';

class EditableListSection extends StatelessWidget {
  const EditableListSection({
    super.key,
    required this.contentEmpty,
    required this.onEditTap,
    required this.onAddTap,
    required this.sectionHeader,
    required this.children,
  });

  final bool contentEmpty;
  final String sectionHeader;
  final Function() onEditTap;
  final Function() onAddTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                Row(
                children: [
                  SecondaryButton(
                    onTap: onAddTap,
                    child: Icon(
                      Icons.add_rounded,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),

                  const SizedBox(width: 10,),
                  
                  SecondaryButton(
                    onTap: onEditTap,
                    child: Icon(
                      Icons.edit_rounded,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
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
                    onTap: onAddTap
                  )
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