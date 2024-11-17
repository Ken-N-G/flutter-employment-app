import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/experienceForm.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/profile/model/workingExperienceModel.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class AddExperienceListSection extends StatefulWidget {
  const AddExperienceListSection({super.key});

  @override
  State<AddExperienceListSection> createState() => _AddExperienceListSectionState();
}

class _AddExperienceListSectionState extends State<AddExperienceListSection> with WidgetsBindingObserver {
  
  late bool _hideAddButton;
  late TextEditingController positionHeldController;
  late TextEditingController employerController;
  late TextEditingController locationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  
  DateTime? startDate;
  DateTime? endDate;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  void initState() {
    super.initState();
    _hideAddButton = false;
    positionHeldController = TextEditingController();
    employerController = TextEditingController();
    locationController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    positionHeldController.dispose();
    employerController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    setState(() {
      if (View.of(context).viewInsets.bottom > 0.0) {
        _hideAddButton = true;
      } else {
        _hideAddButton = false;
      }
    });
  }

  void _showStartDateTime() {
    showDatePicker(
      context: context, 
      initialDate: (startDate != null) ? startDate : DateTime.now(),
      firstDate: DateTime(120), 
      lastDate: (endDate != null) ? endDate! : DateTime.now()
    ).then((value) => setState(() {
      startDate = value;
      if (startDate != null) {
        startDateController.text = formatter.format(startDate!);
      } else {
        startDateController.text = "";
      }
    }));
  }

  void _showEndDateTime() {
    showDatePicker(
      context: context, 
      initialDate: (endDate != null) ? endDate : startDate,
      firstDate: (startDate != null) ? startDate! : DateTime(120), 
      lastDate: DateTime.now()
    ).then((value) => setState(() {
      endDate = value;
      if (value != null) {
        endDateController.text = formatter.format(endDate!);
      } else {
        endDateController.text = "";
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Add Working Experience",
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
                      
                          ExperienceForm(
                            positionHeldController: positionHeldController, 
                            positionHeldValidator: (position) => profileProvider.validatePositionHeld(position), 
                            employerController: employerController, 
                            employerValidator: (employer) => profileProvider.validateEmployer(employer), 
                            locationController: locationController, 
                            locationValidator: (location) => profileProvider.validateLocation(location),
                            startDateController: startDateController, 
                            startDateValidator: (date) => profileProvider.validateDate(date), 
                            endDateController: endDateController, 
                            endDateValidator: (date) => profileProvider.validateDate(date), 
                            startDate: startDate, 
                            endDate: endDate, 
                            onStartDateTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _showStartDateTime();
                            }, 
                            onEndDateTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _showEndDateTime();
                            }
                          ),
                      
                          const SizedBox(height: 20,),

                          profileProvider.workingExperienceStatus == DataStatus.failed ?
                            Text(
                              profileProvider.workingError.toString(),
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
                  visible: !_hideAddButton,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: PrimaryButton(
                        label: "Add", 
                        onTap: () async {
                          var newItem = WorkingExperienceModel(
                              id: UniqueKey().toString(), 
                              positionHeld: positionHeldController.text.trim(), 
                              employer: employerController.text.trim(), 
                              location: locationController.text.trim(), 
                              startDate: startDate!, 
                              endDate: endDate!,
                            );
                            bool successfulUpload = await profileProvider.setWorkingExperiences([newItem]);
                          if (successfulUpload && context.mounted) {
                            Navigator.pop(context);
                          }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        profileProvider.workingExperienceStatus == DataStatus.processing ?
              const CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
      ],
    );
  }
}