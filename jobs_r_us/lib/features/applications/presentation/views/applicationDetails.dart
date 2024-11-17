import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/educationForm.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/experienceForm.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/otherExperienceForm.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/job_postings/presentation/widgets/shortJobCard.dart';
import 'package:jobs_r_us/features/profile/model/educationModel.dart';
import 'package:jobs_r_us/features/profile/model/eventExperienceModel.dart';
import 'package:jobs_r_us/features/profile/model/workingExperienceModel.dart';
import 'package:jobs_r_us/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class ApplicationDetails extends StatefulWidget {
  const ApplicationDetails({super.key});

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> with WidgetsBindingObserver {
  late ScrollController scrollController;

  DateFormat formatter = DateFormat("d MMM yyyy");

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeOfResidenceController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  DateTime? dateOfBirth;

  List<WorkingExperienceModel> workingModelList = [];
  List<TextEditingController> workingPositionHeldControllers = [];
  List<TextEditingController> workingEmployerControllers = [];
  List<TextEditingController> workingLocationControllers = [];
  List<TextEditingController> workingStartDateControllers = [];
  List<TextEditingController> workingEndDateControllers = [];
  List<DateTime?> workingStartDates = [];
  List<DateTime?> workingEndDates = [];

  List<EventExperienceModel> eventModelList = [];
  List<TextEditingController> eventPositionHeldControllers = [];
  List<TextEditingController> eventNameControllers = [];
  List<TextEditingController> eventLocationControllers = [];
  List<TextEditingController> eventStartDateControllers = [];
  List<TextEditingController> eventEndDateControllers = [];
  List<DateTime?> eventStartDates = [];
  List<DateTime?> eventEndDates = [];

  List<EducationModel> educationModelList = [];
  List<TextEditingController> institutionControllers = [];
  List<TextEditingController> qualificationControllers = [];
  List<TextEditingController> locationControllers = [];
  List<TextEditingController> startDateControllers = [];
  List<TextEditingController> endDateControllers = [];
  List<DateTime?> educationStartDates = [];
  List<DateTime?> educationEndDates = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      var applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);

      fullNameController.text = applicationProvider.selectedApplication.fullName;
      phoneController.text = applicationProvider.selectedApplication.phoneNumber;
      placeOfResidenceController.text = applicationProvider.selectedApplication.placeOfResidence;
      emailController.text = applicationProvider.selectedApplication.email;
      dateOfBirthController.text = formatter.format(applicationProvider.selectedApplication.dateOfBirth);
      dateOfBirth = applicationProvider.selectedApplication.dateOfBirth;

          
      for (var item in applicationProvider.workingExperiences) {
        workingModelList.add(item.copyWith());
      }
      for (var item in workingModelList) {
        addWorkingControllers(item);
        addWorkingDates(item);
      }

      for (var item in applicationProvider.eventExperiences) {
        eventModelList.add(item.copyWith());
      }
      for (var item in eventModelList) {
        addEventControllers(item);
        addEventDates(item);
      }

      for (var item in applicationProvider.education) {
        educationModelList.add(item.copyWith());
      }
      for (var item in educationModelList) {
        addEducationControllers(item);
        addEducationDates(item);
      }

      applicationProvider.updateListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    for (int x = workingModelList.length - 1; x > -1; x--) {
      removeWorkingControllers(x);
    }
    for (int x = eventModelList.length - 1; x > -1; x--) {
      removeEventControllers(x);
    }
    for (int x = eventModelList.length - 1; x > -1; x--) {
      removeEducationControllers(x);
    }
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    placeOfResidenceController.dispose();
    dateOfBirthController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void addWorkingControllers(WorkingExperienceModel? item) {
    if (item != null) {
      workingPositionHeldControllers
          .add(TextEditingController(text: item.positionHeld));
      workingEmployerControllers
          .add(TextEditingController(text: item.employer));
      workingLocationControllers
          .add(TextEditingController(text: item.location));
      workingStartDateControllers
          .add(TextEditingController(text: formatter.format(item.startDate)));
      workingEndDateControllers
          .add(TextEditingController(text: formatter.format(item.endDate)));
    } else {
      workingPositionHeldControllers.add(TextEditingController());
      workingEmployerControllers.add(TextEditingController());
      workingLocationControllers.add(TextEditingController());
      workingStartDateControllers.add(TextEditingController());
      workingEndDateControllers.add(TextEditingController());
    }
  }

  void removeWorkingControllers(int index) {
    workingPositionHeldControllers[index].dispose();
    workingPositionHeldControllers.removeAt(index);

    workingEmployerControllers[index].dispose();
    workingEmployerControllers.removeAt(index);

    workingLocationControllers[index].dispose();
    workingLocationControllers.removeAt(index);

    workingStartDateControllers[index].dispose();
    workingStartDateControllers.removeAt(index);

    workingEndDateControllers[index].dispose();
    workingEndDateControllers.removeAt(index);
  }

  void removeWorkingDates(int index) {
    workingStartDates.removeAt(index);
    workingEndDates.removeAt(index);
  }

  void addWorkingDates(WorkingExperienceModel? item) {
    if (item != null) {
      workingStartDates.add(item.startDate);
      workingEndDates.add(item.endDate);
    } else {
      workingStartDates.add(null);
      workingEndDates.add(null);
    }
  }

  Widget _setWorkingExperiences(ApplicationProvider provider) {
    List<Widget> entries = [];

    if(provider.workingExperiences.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Empty",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    for (int x = 0; x < workingModelList.length; x++) {
      entries.add(Row(
        children: [
          Text(
            "Entry ${(x + 1).toString()}",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ExperienceForm(
          readOnly: true,
          positionHeldController: workingPositionHeldControllers[x],
          employerController: workingEmployerControllers[x],
          locationController: workingLocationControllers[x],
          startDateController: workingStartDateControllers[x],
          endDateController: workingEndDateControllers[x],
          startDate: workingStartDates[x],
          endDate: workingEndDates[x],
          onStartDateTap: () async {},
          onEndDateTap: () async {}
        ),
      ));
    }

    return Column(
      children: entries,
    );
  }

  void removeEventDates(int index) {
    eventStartDates.removeAt(index);
    eventEndDates.removeAt(index);
  }

  void removeEventControllers(int index) {
    eventPositionHeldControllers[index].dispose();
    eventPositionHeldControllers.removeAt(index);

    eventNameControllers[index].dispose();
    eventNameControllers.removeAt(index);

    eventLocationControllers[index].dispose();
    eventLocationControllers.removeAt(index);

    eventStartDateControllers[index].dispose();
    eventStartDateControllers.removeAt(index);

    eventEndDateControllers[index].dispose();
    eventEndDateControllers.removeAt(index);
  }

  void addEventControllers(EventExperienceModel? item) {
    if (item != null) {
      eventPositionHeldControllers
          .add(TextEditingController(text: item.positionHeld));
      eventNameControllers.add(TextEditingController(text: item.event));
      eventLocationControllers.add(TextEditingController(text: item.location));
      eventStartDateControllers
          .add(TextEditingController(text: formatter.format(item.startDate)));
      eventEndDateControllers
          .add(TextEditingController(text: formatter.format(item.endDate)));
    } else {
      eventPositionHeldControllers.add(TextEditingController());
      eventNameControllers.add(TextEditingController());
      eventLocationControllers.add(TextEditingController());
      eventStartDateControllers.add(TextEditingController());
      eventEndDateControllers.add(TextEditingController());
    }
  }

  void addEventDates(EventExperienceModel? item) {
    if (item != null) {
      eventStartDates.add(item.startDate);
      eventEndDates.add(item.endDate);
    } else {
      eventStartDates.add(null);
      eventEndDates.add(null);
    }
  }

  Widget _setOtherExperiences(ApplicationProvider provider) {
    List<Widget> entries = [];

    if(provider.eventExperiences.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Empty",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    for (int x = 0; x < eventModelList.length; x++) {
      entries.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Entry ${(x + 1).toString()}",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: OtherExperienceForm(
          readOnly: true,
          positionHeldController: eventPositionHeldControllers[x],
          eventController: eventNameControllers[x],
          locationController: eventLocationControllers[x],
          startDateController: eventStartDateControllers[x],
          endDateController: eventEndDateControllers[x],
          startDate: eventStartDates[x],
          endDate: eventEndDates[x],
          onStartDateTap: () async {},
          onEndDateTap: () async {},
        ),
      ));
    }

    return Column(
      children: entries,
    );
  }

  void addEducationDates(EducationModel? item) {
    if (item != null) {
      educationStartDates.add(item.startDate);
      educationEndDates.add(item.endDate);
    } else {
      educationStartDates.add(null);
      educationEndDates.add(null);
    }
  }

  void addEducationControllers(EducationModel? item) {
    if (item != null) {
      institutionControllers.add(TextEditingController(text: item.institution));
      qualificationControllers
          .add(TextEditingController(text: item.lastHighestQualification));
      locationControllers.add(TextEditingController(text: item.location));
      startDateControllers
          .add(TextEditingController(text: formatter.format(item.startDate)));
      endDateControllers
          .add(TextEditingController(text: formatter.format(item.endDate)));
    } else {
      institutionControllers.add(TextEditingController());
      qualificationControllers.add(TextEditingController());
      locationControllers.add(TextEditingController());
      startDateControllers.add(TextEditingController());
      endDateControllers.add(TextEditingController());
    }
  }

  void addEducationItem() {
    setState(() {
      EducationModel newItem = EducationModel(
        id: UniqueKey().toString(),
        institution: "",
        lastHighestQualification: "",
        location: "",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      educationModelList.add(newItem);
      addEducationControllers(null);
      addEducationDates(null);
    });
  }

  void removeEducationDates(int index) {
    educationStartDates.removeAt(index);
    educationEndDates.removeAt(index);
  }

  void removeEducationControllers(int index) {
    institutionControllers[index].dispose();
    institutionControllers.removeAt(index);

    qualificationControllers[index].dispose();
    qualificationControllers.removeAt(index);

    locationControllers[index].dispose();
    locationControllers.removeAt(index);

    startDateControllers[index].dispose();
    startDateControllers.removeAt(index);

    endDateControllers[index].dispose();
    endDateControllers.removeAt(index);
  }

  Widget _setEducation(ApplicationProvider provider) {
    List<Widget> entries = [];

    if(provider.education.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Empty",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    for (int x = 0; x < educationModelList.length; x++) {
      entries.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Entry ${(x + 1).toString()}",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: EducationForm(
          readOnly: true,
          institutionController: institutionControllers[x],
          qualificationsController: qualificationControllers[x],
          locationController: locationControllers[x],
          startDateController: startDateControllers[x],
          endDateController: endDateControllers[x],
          startDate: educationStartDates[x],
          endDate: educationEndDates[x],
          onStartDateTap: () async {},
          onEndDateTap: () async {},
        ),
      ));
    }

    return Column(
      children: entries,
    );
  }

  Color setPrimaryColor(String status) {
    if (status == ApplicationStatus.submitted.status) {
      return ApplicationStatus.submitted.color;
    } else if (status == ApplicationStatus.pendingInterview.status) {
      return ApplicationStatus.pendingInterview.color;
    } else if (status == ApplicationStatus.pendingReview.status) {
      return ApplicationStatus.pendingReview.color;
    } else if (status == ApplicationStatus.approved.status) {
      return ApplicationStatus.approved.color; 
    } else if (status == ApplicationStatus.accepted.status) {
      return ApplicationStatus.accepted.color; 
    } else if (status == ApplicationStatus.rejected.status) {
      return ApplicationStatus.rejected.color;
    } else {
      return ApplicationStatus.archived.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider = Provider.of<ApplicationProvider>(context);
    JobProvider jobProvider = Provider.of<JobProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Your Application",
          ),
          body: SafeArea(
            child: Stack(
              children: [
        
                SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                
                        ShortJobCard(
                          employerName: jobProvider.selectedJob.employerName,
                          title: jobProvider.selectedJob.title,
                          type: jobProvider.selectedJob.type,
                          tag: jobProvider.selectedJob.tag,
                          location: jobProvider.selectedJob.location,
                          datePosted: jobProvider.selectedJob.datePosted,
                          workingHours: jobProvider.selectedJob.workingHours,
                          salary: jobProvider.selectedJob.salary,
                          isOpen: !jobProvider.selectedJob.isOpen,
                          onCardTap: () {
                            Navigator.pushNamed(context, ScreenRoutes.postingDetailsWithoutApply.route);
                          }
                        ),
                
                        const SizedBox(height: 30,),
                
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: setPrimaryColor(applicationProvider.selectedApplication.status).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                applicationProvider.selectedApplication.status,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: setPrimaryColor(applicationProvider.selectedApplication.status)
                                ),
                              ),
                
                              const SizedBox(height: 10,),
                
                              Text(
                                "Last updated at ${applicationProvider.selectedApplication.dateUpdated}",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).colorScheme.outline
                                ),
                              ),
                            ],
                          ),
                        ),
                
                        const SizedBox(height: 30,),
                
                        Text(
                          "Personal Information",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                
                        const SizedBox(height: 20,),
                
                        CustomTextFormField(
                          keyboardInput: TextInputType.name,
                          controller: fullNameController,
                          label: "Full Name",
                          readOnly: true,
                        ),
                    
                        const SizedBox(height: 10),
                    
                        CustomFieldButton(
                          label: "Date of Birth",
                          controller: dateOfBirthController,
                          defaultInnerLabel: (dateOfBirthController.text.isNotEmpty) ? formatter.format(dateOfBirth!) : "Select date",
                          suffixIcon: const Icon(
                            Icons.calendar_month_rounded
                          ),
                          onFieldTap: null,
                        ),
                    
                        const SizedBox(height: 10),
                    
                        CustomTextFormField(
                          keyboardInput: TextInputType.emailAddress,
                          controller: emailController,
                          label: "Email",
                          readOnly: true,
                        ),
                                
                        const SizedBox(height: 10),
                    
                        CustomTextFormField(
                          prefixLabel: "+62",
                          keyboardInput: TextInputType.phone,
                          controller: phoneController,
                          label: "Phone Number",
                          readOnly: true,
                        ),
                                
                        const SizedBox(height: 10),
                    
                        CustomTextFormField(
                          keyboardInput: TextInputType.streetAddress,
                          controller: placeOfResidenceController,
                          label: "Place of Residence",
                          readOnly: true,
                        ),
                
                        const SizedBox(height: 30,),
                
                        Text(
                          "Working Experiences",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                
                        const SizedBox(height: 20,),
                
                        _setWorkingExperiences(applicationProvider),
                
                        const SizedBox(height: 30,),
                
                        Text(
                          "Education",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                
                        const SizedBox(height: 20,),
                
                        _setEducation(applicationProvider),
                
                        const SizedBox(height: 30,),
                
                        Text(
                          "Other Experiences",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                
                        const SizedBox(height: 20,),
                
                        _setOtherExperiences(applicationProvider),
                
                        const SizedBox(height: 130,),
                      ],
                    ),
                  ),
                ),
        
                Visibility(
                  visible: (applicationProvider.selectedApplication.status == ApplicationStatus.approved.status),
                  child: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeIn,
                          height: scrollController.position.userScrollDirection == ScrollDirection.reverse ? 0 : 140,
                          child: Wrap(
                            children: [
                              child!
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: Column(
                        children: [
                          PrimaryButton(
                            label: "Accept Job Offering", 
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await applicationProvider.setApplication(applicationProvider.selectedApplication.copyWith(
                                status: ApplicationStatus.accepted.status
                              ), null, null, null);
                              await applicationProvider.getAllApplications();
                          }),
                          
                          const SizedBox(height: 20),
                                            
                          PrimaryButton(
                            label: "Reject Job Offering", 
                            overrideBackgroundColor: Theme.of(context).colorScheme.error,
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await applicationProvider.setApplication(applicationProvider.selectedApplication.copyWith(
                                status: ApplicationStatus.denied.status
                              ), null, null, null);
                              await applicationProvider.getAllApplications();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        applicationProvider.applyStatus == ApplyStatus.uploading ?
              const CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
      ],
    );
  }
}