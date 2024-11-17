import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/widgets/applicationCard.dart';
import 'package:jobs_r_us_employer/features/home/presentation/widgets/jobMetricsCard.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
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

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final applicationProvider = Provider.of<ApplicationProvider>(context);

    return SafeArea(
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: profileProvider.hasEditedAboutMe && profileProvider.hasUploadedProfilePicture && profileProvider.hasVisitedProfilePage ?
                  Ink(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Let's Connect You with workers",
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
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Image(
                                height: 150,
                                width: 150,
                                image: AssetImage("assets/images/4557388.jpg"),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  
                  :
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
                                  "So that workers can know you better",
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

                applicationProvider.selectedApplication.fullName.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recently Viewed Application",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 20,),

                      ApplicationCard(
                        onCardTap: () {
                          Navigator.pushNamed(context, ScreenRoutes.applicationDetails.route);
                        }, 
                        status: applicationProvider.selectedApplication.status, 
                        solicitorName: applicationProvider.selectedApplication.fullName, 
                        jobTitle: applicationProvider.selectedApplication.jobTitle,
                        dateApplied: applicationProvider.selectedApplication.dateApplied
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ) : Container(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Job Metrics",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                jobProvider.jobStatus == JobStatus.retrieving || jobProvider.metricsStatus == JobStatus.retrieving ? 
                const Center(
                  child: CustomLoadingOverlay(),
                ) :
                SizedBox(
                  height: 99,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.only(left: 20),
                    itemExtent: MediaQuery.of(context).size.width * 0.5,
                    scrollDirection: Axis.horizontal,
                    itemCount: jobProvider.allJobsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: JobMetricsCard(
                          title: jobProvider.allJobsList[index].title,
                          numberOfApplicants: jobProvider.applicantMetricsList[index],
                          datePosted: jobProvider.allJobsList[index].datePosted,
                          enableOverflow: true,
                          onCardTap: () async {
                            jobProvider.setSelectedJob(jobProvider.allJobsList[index].id);
                            await applicationProvider.getAllApplications(jobProvider.selectedJob.id);
                            if (context.mounted) {
                              Navigator.pushNamed(context, ScreenRoutes.applications.route);
                            }
                          },
                        )
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30,),
              ],
            ),
          )
        )
      ]),
    );
  }
}
