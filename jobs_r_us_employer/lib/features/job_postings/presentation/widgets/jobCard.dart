import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/features/job_postings/presentation/widgets/tag.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/shadowAndPaddingContainer.dart';

class JobCard extends StatelessWidget {
  JobCard({
    super.key,
    required this.title,
    required this.type,
    required this.tag,
    required this.location,
    required this.datePosted,
    required this.workingHours,
    required this.salary,
    required this.onCardTap,
    required this.onApplicationsTap,
  });

  final String title;
  final String type;
  final String tag;
  final String location;
  final DateTime datePosted;
  final int workingHours;
  final int salary;

  final Function() onCardTap;
  final Function() onApplicationsTap;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      child: ShadowAndPaddingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
      
                Text(
                  formatter.format(datePosted),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
      
            const SizedBox(
              height: 5,
            ),
      
            Row(
              children: [
                Text(
                  "Rp ",
                  style:
                      Theme.of(context).textTheme.bodySmall,
                ),
      
                Text(
                  "~$salary ",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
      
                Text(
                  "per month",
                  style:
                      Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
      
            const SizedBox(
              height: 10,
            ),

            Tag(
              tag: tag
            ),

            const SizedBox(
              height: 10,
            ),
      
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      
                      const SizedBox(
                        width: 5,
                      ),
                          
                      Flexible(
                        child: Text(
                          "$workingHours per week",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.work_rounded,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      
                      const SizedBox(
                        width: 5,
                      ),
                          
                      Flexible(
                        child: Text(
                          type == "Part" ? "Part Time" : "Full Time",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      
            const SizedBox(
              height: 5,
            ),
      
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Theme.of(context).colorScheme.outline,
                ),
                
                const SizedBox(
                  width: 5,
                ),
                      
                Flexible(
                  child: Text(
                    location,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
      
            const SizedBox(
              height: 20,
            ),
      
            PrimaryButton(
              label: "See Applicants", 
              onTap: onApplicationsTap
            )
          ],
        ),
      ),
    );
  }
}