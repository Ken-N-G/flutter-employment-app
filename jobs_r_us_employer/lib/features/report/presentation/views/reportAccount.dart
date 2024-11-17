import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/report/domain/reportProvider.dart';
import 'package:jobs_r_us_employer/features/report/model/userReportModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class ReportUser extends StatefulWidget {
  const ReportUser({super.key});

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> with WidgetsBindingObserver {

  late bool _hideSaveButton;

  List<String> offenseTypes = [
    "Fraud",
    "Unjust Behavior",
  ];
  var offenseType = OffenseType.fraud;

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
    final solicitorProvider = Provider.of<SolicitorProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Report Applicant",
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
                                case "Fraud":
                                  offenseType = OffenseType.fraud;
                                  break;
                                case "Unjust Behavior":
                                  offenseType = OffenseType.unfairDecision;
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
                              var report = UserReportModel(
                                id: UniqueKey().toString(), 
                                offenderId: solicitorProvider.selectedSolicitor.id, 
                                reporterId: authProvider.currentUser!.uid, 
                                offense: offenseType.offense, 
                                description: descriptionController.text.trim(), 
                                dateReported: DateTime.now()
                              );
                              FocusManager.instance.primaryFocus?.unfocus();
                              bool successfulRegister = await reportProvider.setUserReport(report);
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
              const CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
      ],
    );
  }
}