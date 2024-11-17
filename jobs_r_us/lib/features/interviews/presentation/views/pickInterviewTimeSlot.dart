import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/shadowAndPaddingContainer.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class PickInterviewTimeSlot extends StatelessWidget {
  const PickInterviewTimeSlot({super.key});

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final DateFormat formatter = DateFormat("d MMM yyyy").add_jm();
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Pick Interview Time",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: interviewProvider.selectedInterview.availableDates.isNotEmpty ?
            ListView.builder(
              itemCount: interviewProvider.selectedInterview.availableDates.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ShadowAndPaddingContainer(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatter.format(interviewProvider.selectedInterview.availableDates[index]),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        SecondaryButton(
                          child: Text(
                            "Pick",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.w700
                            ),
                          ), 
                          onTap: () async {
                            var successful = await interviewProvider.updateInterview(interviewProvider.selectedInterview.availableDates[index]);
                            notificationsProvider.setNotifications("${interviewProvider.selectedInterview.solicitorName} has accepted your interview for ${interviewProvider.selectedInterview.jobTitle}", NotificationType.interview, interviewProvider.selectedInterview.employerId);
                            if (successful && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        )
                      ],
                    ),
                  ),
                );
              }
            ) : Container()
        ),
      ),
    );
  }
}