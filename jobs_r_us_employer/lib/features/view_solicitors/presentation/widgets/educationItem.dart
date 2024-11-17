import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EducationItem extends StatelessWidget {
  EducationItem({
    super.key,
    required this.lastHighestQualification,
    required this.institution,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  final String lastHighestQualification;
  final String institution;
  final String location;
  final DateTime startDate;
  final DateTime endDate;

  final DateFormat formatter = DateFormat('dd-MMM-yyyy'); 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lastHighestQualification,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700
          ),
        ),
                      
        const SizedBox(height: 10,),

        Row(
          children: [
            Icon(
              Icons.school_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            
            const SizedBox(
              width: 5,
            ),
  
            Text(
              institution,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        const SizedBox(height: 5,),
                      
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: Theme.of(context).colorScheme.outline,
            ),
            
            const SizedBox(
              width: 5,
            ),
  
            Text(
              location,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline
              ),
            ),
          ],
        ),

        const SizedBox(height: 5,),

        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              color: Theme.of(context).colorScheme.outline,
            ),
            
            const SizedBox(
              width: 5,
            ),
  
            Text(
              "${formatter.format(startDate)} ke ${formatter.format(endDate)}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline
              ),
            ),
          ],
        ),
      ],
    );
  }
}