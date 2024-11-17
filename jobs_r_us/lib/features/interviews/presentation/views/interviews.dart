import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us/features/interviews/presentation/widgets/interviewCard.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:provider/provider.dart';

class Interviews extends StatefulWidget {
  const Interviews({super.key});

  @override
  State<Interviews> createState() => _InterviewsState();
}

class _InterviewsState extends State<Interviews> {
  
  InterviewStatus filter = InterviewStatus.all;
  List<String> statusFilters = [
    "All",
    "Awaiting Schedule from You",
    "Awaiting Interview",
    "Happening Now",
    "Completed",
    "Archived",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final interviewProvider =
          Provider.of<InterviewProvider>(context, listen: false);
      interviewProvider.resetSearch();
      interviewProvider.getInterviews();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final employerProvider = Provider.of<EmployerProvider>(context, listen: false);
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: Row(
            children: [
              CustomDropdownMenu(
                initialSelection: statusFilters.first,
                entries: <DropdownMenuEntry<String>>[
                  DropdownMenuEntry(
                      value: statusFilters[0], label: statusFilters[0]),
                  DropdownMenuEntry(
                      value: statusFilters[1], label: statusFilters[1]),
                  DropdownMenuEntry(
                      value: statusFilters[2], label: statusFilters[2]),
                  DropdownMenuEntry(
                      value: statusFilters[3], label: statusFilters[3]),
                  DropdownMenuEntry(
                      value: statusFilters[4], label: statusFilters[4]),
                  DropdownMenuEntry(
                      value: statusFilters[5], label: statusFilters[5]),
                ],
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  switch (value) {
                    case "All":
                      filter = InterviewStatus.all;
                      break;
                    case "Awaiting Schedule from You":
                      filter = InterviewStatus.pendingSchedule;
                      break;
                    case "Awaiting Interview":
                      filter = InterviewStatus.awaitingInterview;
                      break;
                    case "Happening Now":
                      filter = InterviewStatus.happeningNow;
                      break;
                    case "Completed":
                      filter = InterviewStatus.completed;
                      break;
                    case "Archived":
                      filter = InterviewStatus.archived;
                      break;
                  }
                },
              ),

              const SizedBox(
                width: 10,
              ),
              SecondaryButton(
                  child: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await employerProvider.getAllEmployers();
                    await jobProvider.getAllJobs();
                    interviewProvider.getInterviewsWithQuery(filter);
                  })
            ],
          ),
        ),



        Expanded(
          child: interviewProvider.interviewList.isNotEmpty
              ? interviewProvider.interviewStatus == InterStatus.processing
                  ? const Center(
                      child: CustomLoadingOverlay(),
                    )
                  : interviewProvider.searchStatus == InterStatus.unloaded
                      ? ListView.builder(
                          itemCount:
                              interviewProvider.interviewList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: InterviewCard(
                                employerName: interviewProvider.interviewList[index].employerName,
                                jobTitle: interviewProvider.interviewList[index].jobTitle,
                                status: interviewProvider
                                    .interviewList[index].status,
                                selectedDate: interviewProvider
                                    .interviewList[index].status != InterviewStatus.pendingSchedule.status ? interviewProvider
                                    .interviewList[index].selectedDate : null,
                                onCardTap: () async {
                                  interviewProvider.selectedInterview = interviewProvider.interviewList[index];
                                  jobProvider.setSelectedJob(interviewProvider.selectedInterview.jobId);
                                  await employerProvider.setSelectedEmployer(jobProvider.selectedJob.employerId, interviewProvider.selectedInterview.solicitorId);
                                  feedbackProvider.getFeedback(jobProvider.selectedJob.id);
                                  if (context.mounted) {
                                    Navigator.pushNamed(context,
                                      ScreenRoutes.interviewDetails.route);
                                  }
                                },
                              ),
                            );
                          })
                      : interviewProvider.searchStatus ==
                              InterStatus.processing
                          ? const Center(
                              child: CustomLoadingOverlay(),
                            )
                          : interviewProvider
                                  .searchedInterviewList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: interviewProvider
                                      .searchedInterviewList.length,
                                  itemBuilder: (context, index) {

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: InterviewCard(
                                        employerName: interviewProvider.searchedInterviewList[index].employerName,
                                        jobTitle: interviewProvider.searchedInterviewList[index].jobTitle,
                                        status: interviewProvider
                                            .searchedInterviewList[index]
                                            .status,
                                        selectedDate: interviewProvider
                                    .searchedInterviewList[index].status != InterviewStatus.pendingSchedule.status ? interviewProvider
                                    .searchedInterviewList[index].selectedDate : null,
                                        onCardTap: () async {
                                          interviewProvider
                                                  .selectedInterview =
                                              interviewProvider
                                                  .searchedInterviewList[index];
                                          jobProvider.setSelectedJob(interviewProvider.selectedInterview.jobId);
                                          await employerProvider.setSelectedEmployer(jobProvider.selectedJob.employerId,  interviewProvider.selectedInterview.solicitorId);
                                          feedbackProvider.getFeedback(jobProvider.selectedJob.id);
                                          if (context.mounted) {
                                            Navigator.pushNamed(context,
                                              ScreenRoutes.interviewDetails.route);
                                          }
                                        },
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    "There are interviews that you are searching for",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
              : Center(
                  child: Text(
                    "You have not received any interviews",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ))
      ]),
    );
  }
}