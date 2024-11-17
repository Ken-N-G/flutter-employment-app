import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/shadowAndPaddingContainer.dart';

class ApplicationCard extends StatelessWidget {
  ApplicationCard({
    super.key,
    required this.onCardTap,
    required this.status,
    required this.solicitorName,
    required this.dateApplied,
    this.jobTitle
  });

  final Function() onCardTap;
  final String status;
  final String solicitorName;
  final DateTime dateApplied;
  final String? jobTitle;

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
              solicitorName,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700
              ),
            ),
            
              SizedBox(
              height: jobTitle != null ? 5 : 0,
            ),

            jobTitle != null ?
            Row(
              children: [
                Icon(
                  Icons.work,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                
                const SizedBox(
                  width: 5,
                ),
      
                Text(
                  jobTitle ?? "",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ) : Container(),
      
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