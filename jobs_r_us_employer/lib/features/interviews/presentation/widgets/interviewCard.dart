import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/shadowAndPaddingContainer.dart';

class InterviewCard extends StatelessWidget {
  InterviewCard({
    super.key,
    required this.onCardTap,
    required this.status,
    required this.employerName,
    required this.selectedDate,
    required this.jobTitle,
  });

  final Function() onCardTap;
  final String status;
  final String employerName;
  final DateTime? selectedDate;
  final String jobTitle;

  final DateFormat formatter = DateFormat("d MMM yyyy").add_jm();

  Color setPrimaryColor(String status) {
    if (status == InterviewStatus.pendingSchedule.status) {
      return InterviewStatus.pendingSchedule.color;
    } else if (status == InterviewStatus.awaitingInterview.status) {
      return InterviewStatus.awaitingInterview.color;
    } else if (status == InterviewStatus.happeningNow.status) {
      return InterviewStatus.happeningNow.color;
    } else if (status == InterviewStatus.completed.status) {
      return InterviewStatus.completed.color; 
    }  else {
      return InterviewStatus.archived.color;
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
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: setPrimaryColor(status).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(
                    status == InterviewStatus.pendingSchedule.status ? "Awaiting Schedule from Interviewee" : status,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: setPrimaryColor(status)
                    ),
                  ),
                ),
              ),
      
            Text(
              "Interview with $employerName",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 10,),
      
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                
                const SizedBox(
                  width: 5,
                ),
      
                Text(
                  selectedDate != null ?
                  formatter.format(selectedDate!) :
                  "Awaiting Schedule",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700
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
                  Icons.description_rounded,
                  color: Theme.of(context).colorScheme.outline,
                  size: 18,
                ),
                
                const SizedBox(
                  width: 5,
                ),
      
                Text(
                  jobTitle,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.outline
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