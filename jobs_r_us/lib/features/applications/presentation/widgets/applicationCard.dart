import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us/general_widgets/shadowAndPaddingContainer.dart';

class ApplicationCard extends StatelessWidget {
  ApplicationCard({
    super.key,
    required this.onCardTap,
    required this.status,
    required this.title,
    required this.employerName,
    required this.dateApplied,
  });

  final Function() onCardTap;
  final String status;
  final String title;
  final String employerName;
  final DateTime dateApplied;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  Color setPrimaryColor(String status) {
    if (status == ApplicationStatus.submitted.status) {
      return ApplicationStatus.submitted.color;
    } else if (status == ApplicationStatus.pendingInterview.status) {
      return ApplicationStatus.pendingInterview.color;
    } else if (status == ApplicationStatus.pendingReview.status) {
      return ApplicationStatus.pendingReview.color;
    } else if (status == ApplicationStatus.approved.status) {
      return ApplicationStatus.approved.color; 
    } else if (status == ApplicationStatus.accepted.status) {
      return ApplicationStatus.accepted.color; 
    } else if (status == ApplicationStatus.rejected.status) {
      return ApplicationStatus.rejected.color;
    } else {
      return ApplicationStatus.archived.color;
    }
  }

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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: setPrimaryColor(status).withOpacity(0.4),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: setPrimaryColor(status)
                ),
              ),
            ),
      
            const SizedBox(height: 10,),
      
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700
              ),
            ),
            
            const SizedBox(
              height: 5,
            ),
      
            Row(
              children: [
                Icon(
                  Icons.supervisor_account_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                
                const SizedBox(
                  width: 5,
                ),
      
                Text(
                  employerName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
      
            const SizedBox(
              height: 10,
            ),
      
            Text(
              "Applied at ${formatter.format(dateApplied)}",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}