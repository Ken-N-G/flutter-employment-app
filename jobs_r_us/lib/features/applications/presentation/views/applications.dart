import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/applicationCard.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customSearchField.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:provider/provider.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  late TextEditingController searchController;

  List<String> orderFilters = [
    "Descending",
    "Ascending",
  ];
  List<String> statusFilters = [
    "All",
    ApplicationStatus.submitted.status,
    ApplicationStatus.pendingInterview.status,
    ApplicationStatus.pendingReview.status,
    ApplicationStatus.approved.status,
    ApplicationStatus.accepted.status,
    ApplicationStatus.rejected.status,
    ApplicationStatus.denied.status,
    ApplicationStatus.archived.status
  ];
  ApplicationStatus filter = ApplicationStatus.all;
  bool isDescending = true;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    Future.microtask(() {
      final applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      applicationProvider.getAllApplications();
      applicationProvider.resetSearch();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final employerProvider = Provider.of<EmployerProvider>(context);
    final applicationProvider = Provider.of<ApplicationProvider>(context);
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);

    return SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: CustomSearchField(
                  hintText: "Search application",
                  controller: searchController,
                  onSubmitted: (searchKey) async {
                    await employerProvider.getAllEmployers();
                    applicationProvider.getApplicationsWithQuery(
                        searchKey.trim(), filter, isDescending);
                  },
                ),
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
                    applicationProvider.getApplicationsWithQuery(
                        searchController.text.trim(), filter, isDescending);
                  })
            ]),
            const SizedBox(
              height: 10,
            ),
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
                DropdownMenuEntry(
                    value: statusFilters[6], label: statusFilters[6]),
                DropdownMenuEntry(
                    value: statusFilters[7], label: statusFilters[7]),
                    DropdownMenuEntry(
                    value: statusFilters[7], label: statusFilters[8]),
              ],
              onSelected: (String? value) {
                // This is called when the user selects an item.
                switch (value) {
                  case "All":
                    filter = ApplicationStatus.all;
                    break;
                  case "Submitted":
                    filter = ApplicationStatus.submitted;
                    break;
                  case "Awaiting Interview":
                    filter = ApplicationStatus.pendingInterview;
                    break;
                  case "Pending Review":
                    filter = ApplicationStatus.pendingReview;
                    break;
                  case "Approved":
                    filter = ApplicationStatus.approved;
                    break;
                  case "Accepted":
                    filter = ApplicationStatus.accepted;
                    break;
                  case "Rejected":
                    filter = ApplicationStatus.rejected;
                    break;
                  case "Denied":
                    filter = ApplicationStatus.denied;
                    break;
                  case "Archived":
                    filter = ApplicationStatus.archived;
                    break;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomDropdownMenu(
              initialSelection: orderFilters.first,
              entries: <DropdownMenuEntry<String>>[
                DropdownMenuEntry(
                    value: orderFilters[0], label: orderFilters[0]),
                DropdownMenuEntry(
                    value: orderFilters[1], label: orderFilters[1]),
              ],
              onSelected: (String? value) {
                // This is called when the user selects an item.
                switch (value) {
                  case "Descending":
                    isDescending = false;
                    break;
                  case "Ascending":
                    isDescending = true;
                    break;
                }
              },
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Expanded(
          child: applicationProvider.allApplicationsList.isNotEmpty
              ? applicationProvider.applyStatus == ApplyStatus.retrieving
                  ? const Center(
                      child: CustomLoadingOverlay(),
                    )
                  : applicationProvider.searchStatus == ApplyStatus.unloaded
                      ? ListView.builder(
                          itemCount:
                              applicationProvider.allApplicationsList.length,
                          itemBuilder: (context, index) {

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: ApplicationCard(
                                employerName: applicationProvider
                                    .allApplicationsList[index].employerName,
                                title: applicationProvider
                                    .allApplicationsList[index].jobTitle,
                                status: applicationProvider
                                    .allApplicationsList[index].status,
                                dateApplied: applicationProvider
                                    .allApplicationsList[index].dateApplied,
                                onCardTap: () async {
                                  await applicationProvider.setSelectedApplication(applicationProvider.allApplicationsList[index].id);
                                  jobProvider.setSelectedJob(applicationProvider.selectedApplication.jobId);
                                  await employerProvider.setSelectedEmployer(jobProvider.selectedJob.employerId, applicationProvider.selectedApplication.solicitorId);
                                  feedbackProvider.getFeedback(jobProvider.selectedJob.id);
                                  if (context.mounted) {
                                    Navigator.pushNamed(context,ScreenRoutes.applicationDetails.route);
                                  }
                                },
                              ),
                            );
                          })
                      : applicationProvider.searchStatus ==
                              ApplyStatus.retrieving
                          ? const Center(
                              child: CustomLoadingOverlay(),
                            )
                          : applicationProvider
                                  .searchedApplicationsList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: applicationProvider
                                      .searchedApplicationsList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: ApplicationCard(
                                        employerName: applicationProvider
                                            .searchedApplicationsList[index].employerName,
                                        title: applicationProvider
                                            .searchedApplicationsList[index].jobTitle,
                                        status: applicationProvider
                                            .searchedApplicationsList[index]
                                            .status,
                                        dateApplied: applicationProvider
                                            .searchedApplicationsList[index]
                                            .dateApplied,
                                        onCardTap: () async {
                                          await applicationProvider.setSelectedApplication(applicationProvider.searchedApplicationsList[index].id);
                                          jobProvider.setSelectedJob(applicationProvider.selectedApplication.jobId);
                                          await employerProvider.setSelectedEmployer(jobProvider.selectedJob.employerId, applicationProvider.selectedApplication.solicitorId);
                                          feedbackProvider.getFeedback(jobProvider.selectedJob.id);
                                          if (context.mounted) {
                                            Navigator.pushNamed(context,ScreenRoutes.applicationDetails.route);
                                          }
                                        },
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    "There are no applications that match your search",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
              : Center(
                  child: Text(
                    "You have not made any applications",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ))
    ]));
  }
}
