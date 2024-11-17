import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/job_postings/model/jobPostModel.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/shortJobCard.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/features/view_employers/presentation/widgets/employerProfilePicture.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/headerAndBodySection.dart';
import 'package:jobs_r_us/general_widgets/errorTextButton.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class EmployerDetails extends StatelessWidget {
  const EmployerDetails({super.key});

  Widget setJobs(JobProvider jobProvider, EmployerProvider employerProvider, FeedbackProvider feedbackProvider, BuildContext context) {
    List<JobPostModel> jobsFromEmployer = jobProvider.availableJobsList.where((element) {
      return element.employerId == employerProvider.selectedEmployer.id;
    }).toList();

    if (jobsFromEmployer.isNotEmpty) {
      return SizedBox(
        height: 170,
        child: ListView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.only(left: 20),
          itemExtent: MediaQuery.of(context).size.width * 0.8,
          scrollDirection: Axis.horizontal,
          itemCount: jobsFromEmployer.length,
          itemBuilder: (context, index) {
            var employer = employerProvider.allEmployerList.where((element) => element.id.contains(jobProvider.allJobsList[index].employerId)).toList();
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ShortJobCard(
                employerName: employer.isNotEmpty ? employer.first.name : "-",
                title: jobsFromEmployer[index].title,
                type: jobsFromEmployer[index].type,
                tag: jobsFromEmployer[index].tag,
                location: jobsFromEmployer[index].location,
                datePosted: jobsFromEmployer[index].datePosted,
                workingHours: jobsFromEmployer[index].workingHours,
                salary: jobsFromEmployer[index].salary,
                onCardTap: () async {
                  jobProvider.setSelectedJob(jobsFromEmployer[index].id);
                  await feedbackProvider.getFeedback(jobsFromEmployer[index].id);
                  if (context.mounted) {
                    Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                  }
                },
                enableOverflow: true,
              )
            );
          },
        ),
      );
    } else{
      return Center(
        child: Text(
          "No Jobs Yet",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final employerProvider = Provider.of<EmployerProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Employer Details",
        actions: [
          ErrorTextButton(
            label: "Report", 
            onTap: () {
              Navigator.pushNamed(context, ScreenRoutes.reportProfile.route);
            }
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            EmployerProfilePicture(
                              profileUrl: employerProvider.selectedEmployer.profileUrl,
                            ),
                                  
                            const SizedBox(
                              width: 10,
                            ),
                                  
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employerProvider.selectedEmployer.name,
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w700
                                    ),  
                                  ),
                                  
                                  const SizedBox(height: 5,),
                              
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_city_rounded,
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                      
                                      const SizedBox(
                                        width: 5,
                                      ),
                                  
                                      Text(
                                        employerProvider.selectedEmployer.type,
                                        style: Theme.of(context).textTheme.bodyMedium
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 5,),
                                  
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                      
                                      const SizedBox(
                                        width: 5,
                                      ),
                                  
                                      Text(
                                        employerProvider.selectedEmployer.businessAddress,
                                        style: Theme.of(context).textTheme.bodyMedium
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ), 
                                  
                        const SizedBox(height: 30,),

                        Text(
                          "Contact Details",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),

                        const SizedBox(height: 20,),

                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_rounded,
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                  
                                  const SizedBox(
                                    width: 5,
                                  ),
                                      
                                  Flexible(
                                    child: Text(
                                      employerProvider.selectedEmployer.email,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone_rounded,
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                  
                                  const SizedBox(
                                    width: 5,
                                  ),
                                      
                                  Flexible(
                                    child: Text(
                                    employerProvider.selectedEmployer.phoneNumber,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ), 
                                  
                        const SizedBox(height: 20,),
                                  
                        employerProvider.followStatus == FollowStatus.processing ? 
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CustomLoadingOverlay(),
                        ) : Container(),
                                  
                        PrimaryButton(
                          label: employerProvider.isFollowed ? "Stop Following" : "Follow", 
                          onTap: () async {
                            if (employerProvider.isFollowed) {
                              var followList = profileProvider.userProfile?.followedEmployers ?? [];
                              followList.removeWhere((element) => element == employerProvider.selectedEmployer.id);
                              profileProvider.setUserProfile(
                                followedEmployers: followList
                              );
                            } else {
                              var followList = profileProvider.userProfile?.followedEmployers ?? [];
                              followList.add(employerProvider.selectedEmployer.id);
                              profileProvider.setUserProfile(
                                followedEmployers: followList
                              );
                            }
                            employerProvider.setFollow(authProvider.currentUser?.uid ?? "");
                          }
                        ), 
                                  
                        const SizedBox(height: 30,),
                                  
                        HeaderAndBodySection(
                          sectionHeader: "About Us",
                          body: employerProvider.selectedEmployer.aboutUs,
                        ),
                                  
                        const SizedBox(height: 30,),
                                  
                        HeaderAndBodySection(
                          sectionHeader: "Vision and Mission",
                          body: employerProvider.selectedEmployer.visionMission,
                        ),
                        
                        const SizedBox(height: 30,),
                                  
                        Text(
                          "Jobs from Us",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                                  
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),

                  setJobs(jobProvider, employerProvider, feedbackProvider, context)
                ],
              ),
              
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}