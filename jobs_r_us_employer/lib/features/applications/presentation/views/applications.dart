import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/widgets/applicationCard.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customSearchField.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
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
    "Submitted",
    "Awaiting Interview",
    "Pending Review",
    "Approved",
    "Accepted",
    "Rejected",
    "Denied",
    "Archived"
  ];
  ApplicationStatus filter = ApplicationStatus.all;
  bool isDescending = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController = TextEditingController();
    Future.microtask(() {
      final applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      final solicitorProvider =
          Provider.of<SolicitorProvider>(context, listen: false);
      final jobProvider = 
          Provider.of<JobProvider>(context, listen: false);
      applicationProvider.resetSearch();
      applicationProvider.getAllApplications(jobProvider.selectedJob.id).then((value) => solicitorProvider.getAllSolicitors());
      solicitorProvider.getAllSolicitors();
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
    final solicitorProvider = Provider.of<SolicitorProvider>(context);
    final applicationProvider = Provider.of<ApplicationProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Applications",
      ),
      body: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: CustomSearchField(
                    hintText: "Search applications",
                    controller: searchController,
                    onSubmitted: (searchKey) async {
                      applicationProvider.getApplicationsWithQuery(
                          searchKey.trim(), filter, isDescending, jobProvider.selectedJob.id);
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
                      applicationProvider.getApplicationsWithQuery(
                          searchController.text.trim(), filter, isDescending, jobProvider.selectedJob.id);
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
                      value: statusFilters[8], label: statusFilters[8]),
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
                    case "Ascending":
                      isDescending = false;
                      break;
                    case "Descending":
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
                                  solicitorName: applicationProvider
                                      .allApplicationsList[index].fullName,
                                  status: applicationProvider
                                      .allApplicationsList[index].status,
                                  dateApplied: applicationProvider
                                      .allApplicationsList[index].dateApplied,
                                  onCardTap: () async {
                                    solicitorProvider.setSelectedSolicitor(applicationProvider.allApplicationsList[index].solicitorId);
                                    final wasStatusUpdated = await applicationProvider.setSelectedApplication(applicationProvider.allApplicationsList[index].id);
                                    if (wasStatusUpdated) {
                                      notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? ""} has updated the application for ${jobProvider.selectedJob.title}", NotificationType.application, solicitorProvider.selectedSolicitor.id);
                                    }
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
                                          solicitorName: applicationProvider
                                              .searchedApplicationsList[index].fullName,
                                          status: applicationProvider
                                              .searchedApplicationsList[index]
                                              .status,
                                          dateApplied: applicationProvider
                                              .searchedApplicationsList[index]
                                              .dateApplied,
                                          onCardTap: () async {
                                            solicitorProvider.setSelectedSolicitor(applicationProvider.searchedApplicationsList[index].solicitorId);
                                            final wasStatusUpdated = await applicationProvider.setSelectedApplication(applicationProvider.searchedApplicationsList[index].id);
                                            if (wasStatusUpdated) {
                                              notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? ""} has updated the application for ${jobProvider.selectedJob.title}", NotificationType.application, solicitorProvider.selectedSolicitor.id);
                                            }
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
                      "You have not received any applications",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ))
      ])),
    );
  }
}
