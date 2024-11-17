import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/jobCard.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/general_widgets/customDropDownMenu.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customSearchField.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class JobMarket extends StatefulWidget {
  const JobMarket({super.key});

  @override
  State<JobMarket> createState() => _JobMarketState();
}

class _JobMarketState extends State<JobMarket> {

  List<String> searchFilters = ["Date Posted", "Salary", "Title"];
  List<String> orderFilters = ["Descending", "Ascending",];
  List<String> typeFilters = ["All", "Part Time", "Full Time"];
  JobSearchOrder filter = JobSearchOrder.datePosted;
  JobType typeFilter = JobType.all;
  bool isDescending = true;

  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    Future.microtask(() {
      var jobProvider = Provider.of<JobProvider>(context, listen: false);
      jobProvider.resetSearch();
      jobProvider.getAllJobs();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final employerProvider = Provider.of<EmployerProvider>(context, listen: false);
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          jobProvider.resetSearch();
          Navigator.pop(context);
        },
        title: "Job Market",
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomSearchField(
                          hintText: "Search jobs",
                          controller: searchController,
                          onSubmitted: (searchKey) async {
                            await employerProvider.getAllEmployers();
                            jobProvider.getJobsWithQuery(searchKey.trim(), filter, typeFilter, isDescending);
                          },
                        ),
                      ),
                          
                      const SizedBox(width: 10,),
                          
                      SecondaryButton(
                        child: Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await employerProvider.getAllEmployers();
                          jobProvider.getJobsWithQuery(searchController.text.trim(), filter, typeFilter, isDescending);
                        }
                      )
                    ]
                  ),
                          
                  const SizedBox(height: 10,),
                          
                  Row(
                    children: [
                      CustomDropdownMenu(
                        initialSelection: searchFilters.first,
                        entries: <DropdownMenuEntry<String>>[
                          DropdownMenuEntry(
                            value: searchFilters[0],
                            label: searchFilters[0]
                          ),
                          
                          DropdownMenuEntry(
                            value: searchFilters[1],
                            label: searchFilters[1]
                          ),
                          
                          DropdownMenuEntry(
                            value: searchFilters[2],
                            label: searchFilters[2]
                          ),
                        ],
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          switch (value) {
                            case "Title":
                              filter = JobSearchOrder.title;
                              break;
                            case "Salary":
                              filter = JobSearchOrder.salary;
                              break;
                            case "Date Posted":
                              filter = JobSearchOrder.datePosted;
                              break;
                          }
                        },
                      ),
                          
                      const SizedBox(width: 10,),
                          
                      CustomDropdownMenu(
                        initialSelection: orderFilters.first,
                        entries: <DropdownMenuEntry<String>>[
                          DropdownMenuEntry(
                            value: orderFilters[0],
                            label: orderFilters[0]
                          ),
                          
                          DropdownMenuEntry(
                            value: orderFilters[1],
                            label: orderFilters[1]
                          ),
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
                    ]
                  ),
                          
                  const SizedBox(height: 10,),
                          
                  CustomDropdownMenu(
                    initialSelection: typeFilters.first,
                    entries: <DropdownMenuEntry<String>>[
                      DropdownMenuEntry(
                        value: typeFilters[0],
                        label: typeFilters[0]
                      ),
                      
                      DropdownMenuEntry(
                        value: typeFilters[1],
                        label: typeFilters[1]
                      ),
                      
                      DropdownMenuEntry(
                        value: typeFilters[2],
                        label: typeFilters[2]
                      ),
                    ],
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      switch (value) {
                        case "All":
                          typeFilter = JobType.all;
                          break;
                        case "Part Time":
                          typeFilter = JobType.partTime;
                          break;
                        case "Full Time":
                          typeFilter = JobType.fullTime;
                          break;
                      }
                    },
                  ),
                ],
              ),
            ),
        
            const SizedBox(height: 30,),
        
          Expanded(
            child: jobProvider.jobStatus == JobStatus.retrieving ?
              const Center(
                child: CustomLoadingOverlay(),
              ) :  
              jobProvider.searchStatus == JobStatus.unloaded ? ListView.builder(
                itemCount: jobProvider.availableJobsList.length,
                itemBuilder: (context, index) {
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: JobCard(
                      employerName: jobProvider.availableJobsList[index].employerName,
                      title: jobProvider.availableJobsList[index].title,
                      type: jobProvider.availableJobsList[index].type,
                      tag: jobProvider.availableJobsList[index].tag,
                      location: jobProvider.availableJobsList[index].location,
                      datePosted: jobProvider.availableJobsList[index].datePosted,
                      workingHours: jobProvider.availableJobsList[index].workingHours,
                      salary: jobProvider.availableJobsList[index].salary,
                      onCardTap: () async {
                        await feedbackProvider.getFeedback(jobProvider.availableJobsList[index].id);
                        await employerProvider.setSelectedEmployer(jobProvider.availableJobsList[index].employerId, authProvider.currentUser?.uid ?? "");
                        jobProvider.setSelectedJob(jobProvider.availableJobsList[index].id);
                        if (context.mounted) {
                          Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                        }
                      },
                      onApplyTap: () {
                        employerProvider.setSelectedEmployer(jobProvider.availableJobsList[index].employerId, authProvider.currentUser?.uid ?? "");
                        jobProvider.setSelectedJob(jobProvider.allJobsList[index].id);
                        Navigator.pushNamed(context, ScreenRoutes.apply.route);
                      },
                    ),
                  );
                }
              ) : jobProvider.searchStatus == JobStatus.retrieving ? 
                const Center(
                  child: CustomLoadingOverlay(),
                ) : jobProvider.searchedJobsList.isNotEmpty ? ListView.builder(
                itemCount: jobProvider.searchedJobsList.length,
                itemBuilder: (context, index) {
                
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: JobCard(
                      employerName: jobProvider.searchedJobsList[index].employerName,
                      title: jobProvider.searchedJobsList[index].title,
                      type: jobProvider.searchedJobsList[index].type,
                      tag: jobProvider.searchedJobsList[index].tag,
                      location: jobProvider.searchedJobsList[index].location,
                      datePosted: jobProvider.searchedJobsList[index].datePosted,
                      workingHours: jobProvider.searchedJobsList[index].workingHours,
                      salary: jobProvider.searchedJobsList[index].salary,
                      onCardTap: () async {
                        await feedbackProvider.getFeedback(jobProvider.searchedJobsList[index].id);
                        await employerProvider.setSelectedEmployer(jobProvider.searchedJobsList[index].employerId, authProvider.currentUser?.uid ?? "");
                        jobProvider.setSelectedJob(jobProvider.searchedJobsList[index].id);
                        if (context.mounted) {
                          Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                        }
                      },
                      onApplyTap: () {
                        employerProvider.setSelectedEmployer(jobProvider.searchedJobsList[index].employerId, authProvider.currentUser?.uid ?? "");
                        jobProvider.setSelectedJob(jobProvider.searchedJobsList[index].id);
                        Navigator.pushNamed(context, ScreenRoutes.apply.route);
                      },
                    ),
                  ); 
                }
              ) : Center(
                child: Text(
                  "There are no jobs that match your search",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}