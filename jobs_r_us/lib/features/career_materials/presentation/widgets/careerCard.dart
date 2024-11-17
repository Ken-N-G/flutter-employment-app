import 'package:flutter/material.dart';
import 'package:jobs_r_us/general_widgets/shadowAndPaddingContainer.dart';

class CareerCard extends StatelessWidget {
  CareerCard({
    super.key,
    required this.name,
    required this.author,
    required this.onCardTap
  });

  final Function() onCardTap;
  final String name;
  final String author;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onCardTap,
      child: ShadowAndPaddingContainer(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700
              ),
            ),
            
            const SizedBox(height: 10,),
        
            Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                
                const SizedBox(
                  width: 5,
                ),
        
                Text(
                  author,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}