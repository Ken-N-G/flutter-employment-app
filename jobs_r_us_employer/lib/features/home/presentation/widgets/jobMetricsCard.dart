import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/general_widgets/shadowAndPaddingContainer.dart';

class JobMetricsCard extends StatelessWidget {
  JobMetricsCard({
    super.key,
    required this.title,
    required this.datePosted,
    required this.numberOfApplicants,
    this.enableOverflow = false,
    this.isOpen = false,
    required this.onCardTap
  });

  final bool enableOverflow;
  final Function() onCardTap;

  final String title;
  final DateTime datePosted;
  final int numberOfApplicants;
  final bool isOpen;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
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
      
            Text(
              title,
              overflow: enableOverflow ? TextOverflow.ellipsis : null,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
      
            const SizedBox(
              height: 5,
            ),
      
            Text(
              "Total Applicants",
              style:
                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700
                  ),
            ),
      
            const SizedBox(
              height: 10,
            ),
      
            Text(
              numberOfApplicants.toString(),
              style:
                  Theme.of(context).textTheme.bodyMedium
            ),
          ],
        ),
      ),
    );
  }
}