import 'package:jobs_r_us_employer/features/feedback/domain/feedbackProvider.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/report/domain/reportProvider.dart';
import 'package:jobs_r_us_employer/features/report/model/feedbackReportModel.dart';
import 'package:jobs_r_us_employer/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class ReportFeedback extends StatefulWidget {
  const ReportFeedback({super.key});

  @override
  State<ReportFeedback> createState() => _ReportFeedbackState();
}

class _ReportFeedbackState extends State<ReportFeedback> with WidgetsBindingObserver {

  late bool _hideSaveButton;

  List<String> offenseTypes = [
    "Defamation",
    "Violation of NDA",
  ];
  var offenseType = OffenseType.defamation;

  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    _hideSaveButton = false;
    descriptionController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Report Feedback",
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

                          Text(
                            "Type of Offense",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 5,),
                              
                          CustomDropdownMenu(
                            initialSelection: offenseTypes.first,
                            entries: <DropdownMenuEntry<String>>[
                              DropdownMenuEntry(value: offenseTypes[0], label: offenseTypes[0]),
                              DropdownMenuEntry(value: offenseTypes[1], label: offenseTypes[1]),
                            ],
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              switch (value) {
                                case "Defamation":
                                  offenseType = OffenseType.defamation;
                                  break;
                                case "Violation of NDA":
                                  offenseType = OffenseType.violationOfNonDisclosure;
                                  break;
                              }
                            },
                          ),
                              
                          const SizedBox(height: 10,),
                      
                          CustomTextFormField(
                            keyboardInput: TextInputType.multiline,
                            maxLines: null,
                            controller: descriptionController,
                            validator: (name) => reportProvider.validateDescription(name!.trim()),
                            maxLength: 300,
                            label: "Description of Offense"
                          ),
                              
                          const SizedBox(height: 100,),    
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
                        overrideBackgroundColor: Theme.of(context).colorScheme.error,
                        label: "Save Report", 
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                              var report = FeedbackReportModel(
                                id: UniqueKey().toString(), 
                                feedbackId: feedbackProvider.selectedFeedback.id, 
                                reporterId: authProvider.currentUser!.uid, 
                                offense: offenseType.offense, 
                                description: descriptionController.text.trim(), 
                                dateReported: DateTime.now()
                              );
                              FocusManager.instance.primaryFocus?.unfocus();
                              bool successfulRegister = await reportProvider.setFeedbackReport(report);
                              if (successfulRegister && context.mounted) {
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

        reportProvider.reportStatus == ReportStatus.processing ?
              CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
      ],
    );
  }
}