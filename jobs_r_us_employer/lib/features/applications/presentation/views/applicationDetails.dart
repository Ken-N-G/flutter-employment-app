import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/core/utils/androidAPILevelChecker.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/presentation/widgets/solicitorProfilePicture.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/widgets/educationForm.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/widgets/experienceForm.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/widgets/otherExperienceForm.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/educationModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/eventExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/workingExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:permission_handler/permission_handler.dart';
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
      var solicitorProvider =
          Provider.of<SolicitorProvider>(context, listen: false);
      var applicationProvider = Provider.of<ApplicationProvider>(context, listen: false);
      

      fullNameController.text = solicitorProvider.selectedSolicitor.fullName;
      phoneController.text = solicitorProvider.selectedSolicitor.phoneNumber;
      placeOfResidenceController.text = solicitorProvider.selectedSolicitor.placeOfResidence;
      emailController.text = solicitorProvider.selectedSolicitor.email;
      dateOfBirthController.text = formatter.format(solicitorProvider.selectedSolicitor.dateOfBirth);
      dateOfBirth = solicitorProvider.selectedSolicitor.dateOfBirth;
          
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

      solicitorProvider.updateListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            onStartDateTap: () {},
            onEndDateTap: () {}),
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
            onStartDateTap: () {},
            onEndDateTap: () {}),
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
            onStartDateTap: () {},
            onEndDateTap: () {}),
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
    SolicitorProvider solicitorProvider = Provider.of<SolicitorProvider>(context);
    ApplicationProvider applicationProvider = Provider.of<ApplicationProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Application Details",
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

                        Center(
                          child: SolicitorProfilePicture(
                            profileUrl: solicitorProvider.selectedSolicitor.profileUrl,
                            onProfileTap: () async {
                              await solicitorProvider.getEducation();
                              await solicitorProvider.getWorkingExperiences();
                              await solicitorProvider.getEventExperiences();
                              if (context.mounted) {
                                Navigator.pushNamed(context, ScreenRoutes.solicitorDetails.route);
                              }
                            },
                          ),
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

                        Align(
                          alignment: Alignment.center,
                          child: SecondaryButton(
                            onTap: () {
                              Navigator.pushNamed(context, ScreenRoutes.createInterview.route);
                            },
                            child: Text(
                              "Schedule Interview",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.w700
                              ),  
                            ), 
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
                          defaultInnerLabel: (dateOfBirthController.text.isNotEmpty) ? formatter.format(dateOfBirth!) : "- Select date -",
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

                        const SizedBox(height: 10,),

                        Align(
                          alignment: Alignment.center,
                          child: SecondaryButton(
                            onTap: () async {
                              print("1");
                              if (Platform.isAndroid) {
                                int apiLevel = await AndroidAPILevelChecker.getApiLevel() ?? 26;
                                if (apiLevel < 30) {
                                    if (await Permission.storage.isGranted) {
                                    applicationProvider.getResumeDocument();
                                    print("2");
                                    if (context.mounted) {
                                      Navigator.pushNamed(context, ScreenRoutes.resumePreview.route);
                                    }
                                  } else {
                                    print("3");
                                    Permission.storage.request();
                                    print("4");
                                    if (await Permission.storage.isGranted) {
                                      applicationProvider.getResumeDocument();
                                      if (context.mounted) {
                                        Navigator.pushNamed(context, ScreenRoutes.resumePreview.route);
                                      }
                                    }
                                  }
                                } else {
                                  applicationProvider.getResumeDocument();
                                  print("2");
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, ScreenRoutes.resumePreview.route);
                                  }
                                }
                              } else {
                                applicationProvider.getResumeDocument();
                                if (context.mounted) {
                                  Navigator.pushNamed(context, ScreenRoutes.resumePreview.route);
                                }
                              }
                              print("5");
                            },
                            child: Text(
                              applicationProvider.selectedApplication.resumeUrl.isEmpty ? "No Resume" : "View Resume",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.w700
                              ),  
                            ), 
                          ),
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
        
                AnimatedBuilder(
                  animation: scrollController,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: scrollController.position.userScrollDirection == ScrollDirection.reverse ? 0 : 140,
                        child: Wrap(
                          children: [
                            child!,
                          ],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PrimaryButton(
                          label: "Accept", 
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            bool successfulSet = await applicationProvider.setApplication(applicationProvider.selectedApplication.copyWith(
                              status: ApplicationStatus.approved.status
                            ));
                      
                            if (successfulSet && context.mounted) {
                              notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? ""} has accepted the application for ${jobProvider.selectedJob.title}", NotificationType.application, solicitorProvider.selectedSolicitor.id);
                              Navigator.pop(context);
                            }
                        }),
                                  
                        const SizedBox(height: 20,),
                                  
                        PrimaryButton(
                          label: "Reject", 
                          overrideBackgroundColor: Theme.of(context).colorScheme.error,
                          overrideTextColor: Theme.of(context).colorScheme.onError,
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            bool successfulSet = await applicationProvider.setApplication(applicationProvider.selectedApplication.copyWith(
                              status: ApplicationStatus.rejected.status
                            ));
                      
                            if (successfulSet && context.mounted) {
                              notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? ""} has rejected the application for ${jobProvider.selectedJob.title}", NotificationType.application, solicitorProvider.selectedSolicitor.id);
                              Navigator.pop(context);
                            }
                        }),
                      ],
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