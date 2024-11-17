import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/job_postings/model/jobPostModel.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/jobCard.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/shortJobCard.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/secondaryTextButton.dart';
import 'package:jobs_r_us/general_widgets/shadowAndPaddingContainer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.onCompleteProfileTap
  });

  final Function() onCompleteProfileTap;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Widget setRecentlyViewed(JobProvider jobProvider, FeedbackProvider feedbackProvider, EmployerProvider employerProvider) {
    if (jobProvider.selectedJob.id.isEmpty) {
      return Container();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Recently Viewed",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: JobCard(
              employerName: jobProvider.selectedJob.employerName,
              title: jobProvider.selectedJob.title,
              type: jobProvider.selectedJob.type,
              tag: jobProvider.selectedJob.tag,
              location: jobProvider.selectedJob.location,
              datePosted: jobProvider.selectedJob.datePosted,
              workingHours: jobProvider.selectedJob.workingHours,
              salary: jobProvider.selectedJob.salary,
              onCardTap: () async {
                await feedbackProvider.getFeedback(jobProvider.selectedJob.id);
                if (context.mounted) {
                  Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                }
              },
              onApplyTap: () {
                jobProvider.setSelectedJob(jobProvider.selectedJob.id);
                Navigator.pushNamed(context, ScreenRoutes.apply.route);
              },
            ),
        ),
        const SizedBox(height: 30,),
      ],
    );
  }

  Widget setFollowedEmployers(JobProvider jobProvider, FeedbackProvider feedbackProvider, EmployerProvider employerProvider, ProfileProvider profileProvider, AuthProvider authProvider) {
    if (profileProvider.userProfile?.followedEmployers.isEmpty ?? true) {
      return Container();
    }

    List<JobPostModel> allJobs = jobProvider.allJobsList;
    List<JobPostModel> followedJobs = [];

    for (var id in profileProvider.userProfile?.followedEmployers ?? []) {
      followedJobs = followedJobs + allJobs.where((element) => element.employerId == id && element.isOpen).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "From People You Follow",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SecondaryTextButton(label: "See all", onTap: () {
                Navigator.pushNamed(context, ScreenRoutes.jobMarket.route);
              })
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(left: 20),
            itemExtent: MediaQuery.of(context).size.width * 0.8,
            scrollDirection: Axis.horizontal,
            itemCount: followedJobs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ShortJobCard(
                  employerName: followedJobs[index].employerName,
                  title: followedJobs[index].title,
                  type: followedJobs[index].type,
                  tag: followedJobs[index].tag,
                  location: followedJobs[index].location,
                  datePosted: followedJobs[index].datePosted,
                  workingHours: followedJobs[index].workingHours,
                  salary: followedJobs[index].salary,
                  onCardTap: () async {
                    await feedbackProvider.getFeedback(followedJobs[index].id);
                    await employerProvider.setSelectedEmployer(followedJobs[index].employerId, authProvider.currentUser?.uid ?? "");
                    jobProvider.setSelectedJob(followedJobs[index].id);
                    if (context.mounted) {
                      Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                    }
                  },
                  enableOverflow: true,
                )
              );
            },
          ),
        ),

        const SizedBox(height: 30,),
      ],
    );
  }

  Widget setRecommended(JobProvider jobProvider, FeedbackProvider feedbackProvider, EmployerProvider employerProvider, ProfileProvider profileProvider, AuthProvider authProvider) {
    if (profileProvider.userProfile?.subscribedTag.isEmpty ?? true) {
      return Ink(
      padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Try This Job!",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary),
              ),

              const SizedBox(height: 20,),

              jobProvider.jobStatus == JobStatus.retrieving ?
                const ShadowAndPaddingContainer(
                  child: CustomLoadingOverlay(),
                ) :
                JobCard(
                  employerName: jobProvider.availableJobsList.first.employerName,
                  title: jobProvider.availableJobsList.first.title,
                  type: jobProvider.availableJobsList.first.type,
                  tag: jobProvider.availableJobsList.first.tag,
                  location: jobProvider.availableJobsList.first.location,
                  datePosted: jobProvider.availableJobsList.first.datePosted,
                  workingHours: jobProvider.availableJobsList.first.workingHours,
                  salary: jobProvider.availableJobsList.first.salary,
                  onCardTap: () async {
                    await feedbackProvider.getFeedback(jobProvider.availableJobsList.first.id);
                    await employerProvider.setSelectedEmployer(jobProvider.availableJobsList.first.employerId, authProvider.currentUser?.uid ?? "");
                    jobProvider.setSelectedJob(jobProvider.availableJobsList.first.id);
                    if (context.mounted) {
                      Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                    }
                  },
                  onApplyTap: () {
                    jobProvider.setSelectedJob(jobProvider.availableJobsList.first.id);
                    Navigator.pushNamed(context, ScreenRoutes.apply.route);
                  },
                ),
            ],
          ),
        ),
    );
    }

    final recommendedJob = jobProvider.allJobsList.where((element) => element.tag == profileProvider.userProfile?.subscribedTag,).first;

    return Ink(
      padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recommended for You!",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary),
              ),

              const SizedBox(height: 20,),

              jobProvider.jobStatus == JobStatus.retrieving ?
                const ShadowAndPaddingContainer(
                  child: CustomLoadingOverlay(),
                ) :
                JobCard(
                  employerName: recommendedJob.employerName,
                  title: recommendedJob.title,
                  type: recommendedJob.type,
                  tag: recommendedJob.tag,
                  location: recommendedJob.location,
                  datePosted: recommendedJob.datePosted,
                  workingHours: recommendedJob.workingHours,
                  salary: recommendedJob.salary,
                  onCardTap: () async {
                    await feedbackProvider.getFeedback(recommendedJob.id);
                    await employerProvider.setSelectedEmployer(recommendedJob.employerId, authProvider.currentUser?.uid ?? "");
                    jobProvider.setSelectedJob(recommendedJob.id);
                    if (context.mounted) {
                      Navigator.pushNamed(context, ScreenRoutes.postingDetails.route);
                    }
                  },
                  onApplyTap: () {
                    jobProvider.setSelectedJob(recommendedJob.id);
                    Navigator.pushNamed(context, ScreenRoutes.apply.route);
                  },
                ),
            ],
          ),
        ),
    );
  }


  Widget setRecentlyAdded(JobProvider jobProvider, FeedbackProvider feedbackProvider, EmployerProvider employerProvider, AuthProvider authProvider) {
    int availableJobs = jobProvider.availableJobsList.where((element) => element.isOpen,).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Newly Added",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SecondaryTextButton(label: "See all", onTap: () {
                Navigator.pushNamed(context, ScreenRoutes.jobMarket.route);
              })
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(left: 20),
            itemExtent: MediaQuery.of(context).size.width * 0.8,
            scrollDirection: Axis.horizontal,
            itemCount: availableJobs < 3 ? availableJobs : 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ShortJobCard(
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
                  enableOverflow: true,
                )
              );
            },
          ),
        ),

        const SizedBox(height: 30,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final employerProvider = Provider.of<EmployerProvider>(context, listen: false);
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: profileProvider.hasEditedAboutMe && profileProvider.hasUploadedProfilePicture && profileProvider.hasVisitedProfilePage ?
                  setRecommended(jobProvider, feedbackProvider, employerProvider, profileProvider, authProvider) :
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: widget.onCompleteProfileTap,
                    child: Ink(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Complete Your Profile!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Make applying easier with a completed profile.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Image(
                              height: 150,
                              width: 150,
                              image: AssetImage("assets/images/Resume-rafiki.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )

              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ShadowAndPaddingContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 80
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                  child: Icon(
                                    Icons.work_rounded,
                                    size: 32,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Job\nMarket",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, ScreenRoutes.jobMarket.route);
                          },
                        ),
                      ),
                      Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 80
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: Icon(
                                    Icons.supervisor_account_rounded,
                                    size: 32,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Employers",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, ScreenRoutes.employers.route);
                          },
                        ),
                      ),
                      Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 80
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: Icon(
                                    Icons.workspace_premium_rounded,
                                    size: 32,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Career\nArticles",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, ScreenRoutes.careerMaterials.route);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: jobProvider.jobStatus == JobStatus.retrieving ?
          const Center(
            child: CustomLoadingOverlay(),
          ) :
          Ink(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                setRecentlyViewed(jobProvider, feedbackProvider, employerProvider),

                setFollowedEmployers(jobProvider, feedbackProvider, employerProvider, profileProvider, authProvider),

                setRecentlyAdded(jobProvider, feedbackProvider, employerProvider, authProvider),
              ],
            ),
          )
        )
      ]),
    );
  }
}
