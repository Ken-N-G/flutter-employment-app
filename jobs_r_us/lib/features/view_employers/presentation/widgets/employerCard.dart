import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/view_employers/presentation/widgets/employerProfilePicture.dart';
import 'package:jobs_r_us/general_widgets/shadowAndPaddingContainer.dart';

class EmployerCard extends StatelessWidget {
  EmployerCard({
    super.key,
    required this.name,
    required this.profileUrl,
    required this.type,
    required this.address ,
    required this.dateJoined,
    required this.onCardTap
  });

  final Function() onCardTap;
  final String name;
  final String profileUrl;
  final String type;
  final String address;
  final DateTime dateJoined;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onCardTap,
      child: ShadowAndPaddingContainer(
        width: double.infinity,
        child: Row(
          children: [
            EmployerProfilePicture(
              size: 90,
              profileUrl: profileUrl,
              onProfileTap: null,
            ),

            const SizedBox(width: 10,),

            Column(
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
                      Icons.location_city_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    
                    const SizedBox(
                      width: 5,
                    ),

                    Text(
                      type,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ],
                ),

                const SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    
                    const SizedBox(
                      width: 5,
                    ),

                    Text(
                      address,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                Row(
                  children: [
                    Text(
                      "Joined at ",
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    
                    Text(
                      formatter.format(dateJoined),
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}