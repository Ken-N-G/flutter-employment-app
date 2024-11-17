import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/tag.dart';
import 'package:jobs_r_us/general_widgets/shadowAndPaddingContainer.dart';

class ShortJobCard extends StatelessWidget {
  ShortJobCard({
    super.key,
    required this.employerName,
    required this.title,
    required this.type,
    required this.tag,
    required this.location,
    required this.datePosted,
    required this.workingHours,
    required this.salary,
    this.enableOverflow = false,
    required this.onCardTap,
    this.isOpen = false
  });

  final Function() onCardTap;

  final bool enableOverflow;

  final String title;
  final DateTime datePosted;
  final int salary;
  final int workingHours;
  final String location;
  final String type;
  final String employerName;
  final String tag;
  final bool isOpen;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(20),
      child: ShadowAndPaddingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isOpen ? Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 94, 94, 94).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Text(
                  "This job has been closed",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color.fromARGB(255, 94, 94, 94)
                  ),
                ),
              ),
            ) : Container(),

            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: enableOverflow ? TextOverflow.ellipsis : null,
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
                Expanded(
                  child: Row(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                        Icons.supervisor_account_rounded,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      
                      const SizedBox(
                        width: 5,
                      ),
                        
                      Text(
                        employerName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}