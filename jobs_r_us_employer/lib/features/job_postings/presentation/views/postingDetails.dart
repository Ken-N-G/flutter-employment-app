import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_r_us_employer/features/job_postings/presentation/widgets/mapBottomModalSheet.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
// import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us_employer/features/feedback/presentation/widgets/feedbackItem.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryTextButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class PostingDetails extends StatelessWidget {
  const PostingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Job Details",
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                                      
                          Text(
                            jobProvider.selectedJob.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          !jobProvider.selectedJob.isOpen ? Padding(
                            padding: const EdgeInsets.only(top: 10),
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
                                      
                          const SizedBox(height: 20,),
                                      
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.secondary
                              ),
                              child: Text(
                                jobProvider.selectedJob.tag,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondary
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30,),

                    PrimaryButton(
                            label: "See Applicants", 
                            onTap: () {
                              Navigator.pushNamed(context, ScreenRoutes.applications.route);
                          }),
                
                    const SizedBox(height: 30,),
                
                    Row(
                      children: [
                        Text(
                          "Rp ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        
                        Text(
                          "~${jobProvider.selectedJob.salary} ",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700
                          ),
                        ),
            
                        Text(
                          "per month",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 10,),
            
                     Row(
                      children: [
                        Icon(
                          Icons.timer_rounded,
                          color: Theme.of(context).colorScheme.outline,
                        ),
            
                        const SizedBox(width: 5,),
                        
                        Text(
                          "${jobProvider.selectedJob.workingHours} per week",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),  
            
                    const SizedBox(height: 10,),
            
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded ,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                                      
                              const SizedBox(width: 5,),
                              
                              Expanded(
                                child: Text(
                                  jobProvider.selectedJob.location,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10,),

                        Visibility(
                          visible: jobProvider.selectedJob.latitude != 0.0 && jobProvider.selectedJob.longitude != 0.0,
                          child: SecondaryButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.map_rounded,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                          
                                const SizedBox(width: 10,),
                          
                                Text(
                                  "Show in Map",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontWeight: FontWeight.w700
                                  ),  
                                ),
                              ],
                            ),
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await showModalBottomSheet<void>(
                                enableDrag: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return MapBottomModalSheet(
                                    address: jobProvider.selectedJob.location,
                                    initialPosition: LatLng(jobProvider.selectedJob.latitude, jobProvider.selectedJob.longitude)
                                  );
                                }
                              );
                            }),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30,),
            
                    Text(
                      "Job Description",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            
                    const SizedBox(height: 20,),
            
                    Text(
                      jobProvider.selectedJob.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
            
                    const SizedBox(height: 30,),
            
                    Text(
                      "Requirement",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            
                    const SizedBox(height: 20,),
            
                    Text(
                      jobProvider.selectedJob.requirements,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
            
                    const SizedBox(height: 30,),
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Feedback",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
            
                        SecondaryTextButton(
                          label: "See all", 
                          onTap: () {
                            Navigator.pushNamed(context, ScreenRoutes.feedbackList.route);
                          }
                        )
                      ],
                    ),
            
                    const SizedBox(height: 20,),
            
                    feedbackProvider.feedbackList.isNotEmpty ?
                      FeedbackItem(
                        username: feedbackProvider.feedbackList.first.name,
                        profileUrl: feedbackProvider.feedbackList.first.profileUrl,
                        feedback: feedbackProvider.feedbackList.first.feedback,
                        datePosted: feedbackProvider.feedbackList.first.datePosted,
                        endorseText: feedbackProvider.feedbackList.first.endorsedBy.toString(),
                        dislikeText: feedbackProvider.feedbackList.first.dislikedBy.toString(),
                        onDislikeTap: null,
                        onEndorseTap: null,
                        onReportTap: () {
                          feedbackProvider.setSelectedFeedback(feedbackProvider.feedbackList.first.id);
                          Navigator.pushNamed(context, ScreenRoutes.reportFeedback.route);
                        },
                      ) :
                      Text(
                        "No feedback has been given for this job",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
            
                    const SizedBox(height: 100,),    
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                child: PrimaryButton(
                  overrideBackgroundColor: jobProvider.selectedJob.isOpen ? Theme.of(context).colorScheme.error : null,
                  overrideTextColor: jobProvider.selectedJob.isOpen ? Theme.of(context).colorScheme.onError : null,
                  label: jobProvider.selectedJob.isOpen ? "Close Job" : "Open Job", 
                  onTap: () {
                    jobProvider.selectedJob = jobProvider.selectedJob.copyWith(
                      isOpen: !jobProvider.selectedJob.isOpen
                    );
                    if (jobProvider.selectedJob.isOpen) {
                      jobProvider.availableJobsList.removeWhere((element) => element.id == jobProvider.selectedJob.id);
                      jobProvider.setJob(jobProvider.selectedJob, false);
                      notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? "One of your followed employers"} has closed ${jobProvider.selectedJob.title}", NotificationType.job, "");
                    } else {
                      jobProvider.availableJobsList.add(jobProvider.selectedJob);
                      jobProvider.setJob(jobProvider.selectedJob, false);
                      notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? "One of your followed employers"} has opened ${jobProvider.selectedJob.title}", NotificationType.job, "");
                    }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}