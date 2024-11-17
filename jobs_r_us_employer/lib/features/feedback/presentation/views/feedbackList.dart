import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us_employer/features/feedback/presentation/widgets/feedbackItem.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
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

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Feedback",
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(
            height: 5,
          ),
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
                                      .feedbackList[index].endorsedBy
                                      .toString(),
                                  dislikeText: feedbackProvider
                                      .feedbackList[index].dislikedBy
                                      .toString(),
                                  onDislikeTap: null,
                                  onEndorseTap: null,
                                  onReportTap: () {
                                    feedbackProvider.setSelectedFeedback(feedbackProvider.feedbackList.first.id);
                                    Navigator.pushNamed(context, ScreenRoutes.reportFeedback.route);
                                  },
                                ));
                          })
                      : Center(
                          child: Text(
                          "There is no feedback for this job",
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
