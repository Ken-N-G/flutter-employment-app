import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us_employer/features/interviews/presentation/widgets/interviewCard.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
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
    "Awaiting Schedule",
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
    final jobProvider = Provider.of<JobProvider>(context);
    final solicitorProvider = Provider.of<SolicitorProvider>(context);
    final interviewProvider = Provider.of<InterviewProvider>(context);

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
                    case "Awaiting Schedule":
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
                    await solicitorProvider.getAllSolicitors();
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
                            var job = jobProvider.allJobsList
                                .where((element) => element.id.contains(
                                    interviewProvider
                                        .interviewList[index].jobId))
                                .toList();
                            var solicitor = solicitorProvider.allSolictorsList
                                .where((element) =>
                                    element.id.contains(interviewProvider.interviewList[index].solicitorId))
                                .toList();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: InterviewCard(
                                employerName: solicitor.isNotEmpty
                                    ? solicitor.first.fullName
                                    : "-",
                                jobTitle: job.first.title,
                                status: interviewProvider
                                    .interviewList[index].status,
                                selectedDate: interviewProvider
                                    .interviewList[index].status != InterviewStatus.pendingSchedule.status ? interviewProvider
                                    .interviewList[index].selectedDate : null,
                                onCardTap: () async {
                                  interviewProvider.selectedInterview =
                                      interviewProvider
                                          .interviewList[index];
                                  jobProvider.setSelectedJob(interviewProvider.selectedInterview.jobId);
                                  await solicitorProvider.setSelectedSolicitor(interviewProvider.selectedInterview.solicitorId);
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
                                    var job = jobProvider.allJobsList
                                        .where((element) => element.id.contains(
                                            interviewProvider
                                                .searchedInterviewList[index]
                                                .jobId))
                                        .toList();
                                    var solicitor = solicitorProvider
                                        .allSolictorsList
                                        .where((element) => element.id
                                            .contains(interviewProvider.searchedInterviewList[index].solicitorId))
                                        .toList();

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: InterviewCard(
                                        employerName: solicitor.isNotEmpty
                                            ? solicitor.first.fullName
                                            : "-",
                                        jobTitle: job.first.title,
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
                                          await solicitorProvider.setSelectedSolicitor(interviewProvider.selectedInterview.solicitorId);
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
                                    "There are no interviews that matched your search",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
              : Center(
                  child: Text(
                    "You have not scheduled an interview",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ))
      ]),
    );
  }
}