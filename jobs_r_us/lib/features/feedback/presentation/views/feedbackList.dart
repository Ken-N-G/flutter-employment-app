import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/feedback/presentation/widgets/feedbackItem.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class FeedbackList extends StatefulWidget {
  const FeedbackList({super.key});

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {

  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Feedbacks",
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(
            height: 5,
          ),
          SecondaryButton(
              child: Text(
                "Add Feedback",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.pushNamed(context, ScreenRoutes.createFeedback.route);
              }),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: feedbackProvider.feedbackStatus ==
                      FeedbackStatus.processing
                  ? const Center(
                      child: CustomLoadingOverlay(),
                    )
                  : feedbackProvider.feedbackList.isNotEmpty
                      ? ListView.builder(
                          itemCount: feedbackProvider.feedbackList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: FeedbackItem(
                                  username:
                                      feedbackProvider.feedbackList[index].name,
                                  profileUrl: feedbackProvider
                                      .feedbackList[index].profileUrl,
                                  feedback: feedbackProvider
                                      .feedbackList[index].feedback,
                                  datePosted: feedbackProvider
                                      .feedbackList[index].datePosted,
                                  endorseText: feedbackProvider
                                      .feedbackList[index].endorsedBy.toString(),
                                  dislikeText: feedbackProvider
                                      .feedbackList[index].dislikedBy.toString(),
                                  onDislikeTap: () {
                                    feedbackProvider.dislikeFeedback(
                                        feedbackProvider.feedbackList[index].id,
                                        authProvider.currentUser!.uid, feedbackProvider.feedbackList[index].jobId);
                                  },
                                  onEndorseTap: () {
                                    feedbackProvider.endorseFeedback(
                                        feedbackProvider.feedbackList[index].id,
                                        authProvider.currentUser!.uid, feedbackProvider.feedbackList[index].jobId);
                                  },
                                  onReportTap: feedbackProvider.feedbackList[index].name != profileProvider.userProfile!.fullName ? () {
                                    feedbackProvider.setSelectedFeedback(feedbackProvider.feedbackList.first.id);
                                    Navigator.pushNamed(context, ScreenRoutes.reportFeedback.route);
                                  } : null,
                                ));
                          })
                      : Center(
                          child: Text(
                          "There are no feedbacks for this job",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.w700),
                        )))
        ]),
      ),
    );
  }
}
