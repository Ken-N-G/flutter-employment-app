import 'package:flutter/material.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/feedback/model/feedbackModel.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class CreateFeedback extends StatefulWidget {
  const CreateFeedback({super.key});

  @override
  State<CreateFeedback> createState() => _CreateFeedbackState();
}

class _CreateFeedbackState extends State<CreateFeedback> with WidgetsBindingObserver {

  late bool _hideSaveButton;
  late TextEditingController feedbackController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hideSaveButton = false;
    feedbackController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    feedbackController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    setState(() {
      if (View.of(context).viewInsets.bottom > 0.0) {
        _hideSaveButton = true;
      } else {
        _hideSaveButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FeedbackProvider feedbackProvider = Provider.of<FeedbackProvider>(context);
    JobProvider jobProvider = Provider.of<JobProvider>(context, listen: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Create Feedback",
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          
                          CustomTextFormField(
                            label: "Feedback",
                            maxLines: null,
                            maxLength: 300,
                            keyboardInput: TextInputType.multiline,
                            controller: feedbackController,
                            validator: (input) => feedbackProvider.validateFeedback(input),
                          ),
                              
                          const SizedBox(height: 20,),

                          feedbackProvider.feedbackStatus == DataStatus.failed ?
                            Text(
                              feedbackProvider.feedbackError.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ) :
                            Container(),      
                        ],
                      ),
                    ),
                  ),
                ),
        
                Visibility(
                  visible: !_hideSaveButton,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: PrimaryButton(
                        label: "Save Feedback", 
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final feedback = FeedbackModel(
                              id: UniqueKey().toString(), 
                              solicitorId: authProvider.currentUser!.uid, 
                              name: profileProvider.userProfile!.fullName,
                              profileUrl: profileProvider.userProfile!.profileUrl,
                              jobId: jobProvider.selectedJob.id,
                              feedback: feedbackController.text.trim(), 
                              datePosted: DateTime.now(), 
                              endorsedBy: 0, 
                              dislikedBy: 0
                            );
                            bool successfulUpload = await feedbackProvider.addFeedback(feedback);
                            if (successfulUpload && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        feedbackProvider.feedbackStatus == FeedbackStatus.processing ?
                  const CustomLoadingOverlay(enableDarkBackground: true,) :
                  Container()
      ],
    );
  }
}