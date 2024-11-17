import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/feedback/presentation/widgets/feedbackItem.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/mapBottomModalSheet.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/features/view_employers/presentation/widgets/employerProfilePicture.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/secondaryTextButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class PostingDetails extends StatelessWidget {
  const PostingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final employerProvider = Provider.of<EmployerProvider>(context);
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final employer = employerProvider.allEmployerList.where((element) => element.id.contains(jobProvider.selectedJob.employerId)).first;

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
                          EmployerProfilePicture(
                            profileUrl: employerProvider.selectedEmployer.profileUrl,
                            onProfileTap: () {
                              Navigator.pushNamed(context, ScreenRoutes.employerDetails.route);
                            },
                          ),
                                      
                          const SizedBox(height: 10,),
                                      
                          Text(
                            employer.name,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700
                            )
                          ),
                                      
                          const SizedBox(height: 10,),
                                      
                          Text(
                            jobProvider.selectedJob.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                                      
                          const SizedBox(height: 20,),
                                      
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.secondary
                              ),
                              child: InkWell(
                                onTap: () {
                                  profileProvider.setUserProfile(
                                    subscribedTag: jobProvider.selectedJob.tag
                                  );
                                },
                                child: Text(
                                  jobProvider.selectedJob.tag,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondary
                                  ),
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                
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
                      "Requirements",
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
                        onDislikeTap: () {
                          feedbackProvider.dislikeFeedback(feedbackProvider.feedbackList.first.id, authProvider.currentUser!.uid, feedbackProvider.feedbackList.first.jobId);
                        },
                        onEndorseTap: () {
                          feedbackProvider.endorseFeedback(feedbackProvider.feedbackList.first.id, authProvider.currentUser!.uid, feedbackProvider.feedbackList.first.jobId);
                        },
                        onReportTap: feedbackProvider.feedbackList.first.name != profileProvider.userProfile!.fullName ? () {
                          feedbackProvider.setSelectedFeedback(feedbackProvider.feedbackList.first.id);
                          Navigator.pushNamed(context, ScreenRoutes.reportFeedback.route);
                        } : null
                      ) :
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              "There is no feedback given for this job",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        
                            const SizedBox(height: 5,),
                        
                            SecondaryButton(
                              onTap: () {
                                Navigator.pushNamed(context, ScreenRoutes.createFeedback.route);
                              },
                              child: Text(
                                "Add Feedback",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.w700
                                ),  
                              ), 
                            )
                          ],
                        ),
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
                  label: "Apply Now", 
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoutes.apply.route);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}