import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us/features/applications/model/applicationModel.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/educationForm.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/experienceForm.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/otherExperienceForm.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/profile/model/educationModel.dart';
import 'package:jobs_r_us/features/profile/model/eventExperienceModel.dart';
import 'package:jobs_r_us/features/profile/model/workingExperienceModel.dart';
import 'package:jobs_r_us/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us/general_widgets/errorButton.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> with WidgetsBindingObserver {
  late ScrollController scrollController;
  
  DateFormat formatter = DateFormat("d MMM yyyy");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  late bool _hideApplyButton;

  @override
  void initState() {
    super.initState();
    _hideApplyButton = false;
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      var profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      fullNameController.text = profileProvider.userProfile!.fullName;
      phoneController.text = profileProvider.userProfile!.phoneNumber;
      placeOfResidenceController.text = profileProvider.userProfile!.placeOfResidence;
      emailController.text = profileProvider.userProfile!.email;
      dateOfBirthController.text = formatter.format(profileProvider.userProfile!.dateOfBirth);
      dateOfBirth = profileProvider.userProfile!.dateOfBirth;

          
      for (var item in profileProvider.workingExperiences ?? []) {
        workingModelList.add(item.copyWith());
      }
      for (var item in workingModelList) {
        addWorkingControllers(item);
        addWorkingDates(item);
      }

      for (var item in profileProvider.eventExperiences ?? []) {
        eventModelList.add(item.copyWith());
      }
      for (var item in eventModelList) {
        addEventControllers(item);
        addEventDates(item);
      }

      for (var item in profileProvider.educationList ?? []) {
        educationModelList.add(item.copyWith());
      }
      for (var item in educationModelList) {
        addEducationControllers(item);
        addEducationDates(item);
      }

      profileProvider.updateListeners();
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

  @override
  void didChangeMetrics() {
    setState(() {
      if (View.of(context).viewInsets.bottom > 0.0) {
        _hideApplyButton = true;
      } else {
        _hideApplyButton = false;
      }
    });
  }

  Future<DateTime?> _showStartDateTime(DateTime? startDate, DateTime? endDate) {
    return showDatePicker(
        context: context,
        initialDate: (startDate != null) ? startDate : DateTime.now(),
        firstDate: DateTime(120),
        lastDate: (endDate != null) ? endDate : DateTime.now());
  }

  Future<DateTime?> _showEndDateTime(DateTime? endDate, DateTime? startDate) {
    return showDatePicker(
        context: context,
        initialDate: (endDate != null) ? endDate : startDate,
        firstDate: (startDate != null) ? startDate : DateTime(120),
        lastDate: DateTime.now());
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

  void deleteWorkingItem(int index) {
    setState(() {
      workingModelList.removeAt(index);
      removeWorkingControllers(index);
      removeWorkingDates(index);
    });
  }

  void addWorkingItem() {
    setState(() {
      WorkingExperienceModel newItem = WorkingExperienceModel(
        id: UniqueKey().toString(),
        positionHeld: "",
        employer: "",
        location: "",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      workingModelList.add(newItem);
      addWorkingControllers(null);
      addWorkingDates(null);
    });
  }

  Widget _setWorkingExperiences(ProfileProvider profileProvider) {
    List<Widget> entries = [];

    for (int x = 0; x < workingModelList.length; x++) {
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
          ErrorButton(
            child: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.onError,
            ),
            onTap: () {
              deleteWorkingItem(x);
            },
          )
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ExperienceForm(
            positionHeldController: workingPositionHeldControllers[x],
            positionHeldValidator: (position) =>
                profileProvider.validatePositionHeld(position),
            employerController: workingEmployerControllers[x],
            employerValidator: (employer) =>
                profileProvider.validateEmployer(employer),
            locationController: workingLocationControllers[x],
            locationValidator: (location) =>
                profileProvider.validateLocation(location),
            startDateController: workingStartDateControllers[x],
            startDateValidator: (date) => profileProvider.validateDate(date),
            endDateController: workingEndDateControllers[x],
            endDateValidator: (date) => profileProvider.validateDate(date),
            startDate: workingStartDates[x],
            endDate: workingEndDates[x],
            onStartDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showStartDateTime(
                  workingStartDates[x], workingEndDates[x]);
              setState(() {
                workingStartDates[x] = newTime;
                if (newTime != null) {
                  workingStartDateControllers[x].text =
                      formatter.format(workingStartDates[x]!);
                } else {
                  workingStartDateControllers[x].text = "";
                }
              });
            },
            onEndDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showEndDateTime(
                  workingEndDates[x], workingStartDates[x]);

              setState(() {
                workingEndDates[x] = newTime;
                if (newTime != null) {
                  workingEndDateControllers[x].text =
                      formatter.format(workingEndDates[x]!);
                } else {
                  workingEndDateControllers[x].text = "";
                }
              });
            }),
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

  void deleteEventItem(int index) {
    setState(() {
      eventModelList.removeAt(index);
      removeEventControllers(index);
      removeEventDates(index);
    });
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

  void addEventItem() {
    setState(() {
      EventExperienceModel newItem = EventExperienceModel(
        id: UniqueKey().toString(),
        positionHeld: "",
        event: "",
        location: "",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      eventModelList.add(newItem);
      addEventControllers(null);
      addEventDates(null);
    });
  }

  Widget _setOtherExperiences(ProfileProvider profileProvider) {
    List<Widget> entries = [];

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
          ErrorButton(
            child: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.onError,
            ),
            onTap: () {
              deleteEventItem(x);
            },
          )
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: OtherExperienceForm(
            positionHeldController: eventPositionHeldControllers[x],
            positionHeldValidator: (position) =>
                profileProvider.validatePositionHeld(position),
            eventController: eventNameControllers[x],
            eventValidator: (event) => profileProvider.validateEvent(event),
            locationController: eventLocationControllers[x],
            locationValidator: (location) =>
                profileProvider.validateLocation(location),
            startDateController: eventStartDateControllers[x],
            startDateValidator: (date) => profileProvider.validateDate(date),
            endDateController: eventEndDateControllers[x],
            endDateValidator: (date) => profileProvider.validateDate(date),
            startDate: eventStartDates[x],
            endDate: eventEndDates[x],
            onStartDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showStartDateTime(
                  eventStartDates[x], eventEndDates[x]);
              setState(() {
                eventStartDates[x] = newTime;
                if (newTime != null) {
                  eventStartDateControllers[x].text =
                      formatter.format(eventStartDates[x]!);
                } else {
                  eventStartDateControllers[x].text = "";
                }
              });
            },
            onEndDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime =
                  await _showEndDateTime(eventEndDates[x], eventStartDates[x]);

              setState(() {
                eventEndDates[x] = newTime;
                if (newTime != null) {
                  eventEndDateControllers[x].text =
                      formatter.format(eventEndDates[x]!);
                } else {
                  eventEndDateControllers[x].text = "";
                }
              });
            }),
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

  void deleteEducationItem(int index) {
    setState(() {
      educationModelList.removeAt(index);
      removeEducationControllers(index);
      removeEducationDates(index);
    });
  }

  Widget _setEducation(ProfileProvider profileProvider) {
    List<Widget> entries = [];

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
          ErrorButton(
            child: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.onError,
            ),
            onTap: () {
              deleteEducationItem(x);
            },
          )
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: EducationForm(
            institutionController: institutionControllers[x],
            institutionValidator: (institution) =>
                profileProvider.validateInstitution(institution),
            qualificationsController: qualificationControllers[x],
            qualificationsValidator: (qualification) =>
                profileProvider.validateQualification(qualification),
            locationController: locationControllers[x],
            locationValidator: (location) =>
                profileProvider.validateLocation(location),
            startDateController: startDateControllers[x],
            startDateValidator: (date) => profileProvider.validateDate(date),
            endDateController: endDateControllers[x],
            endDateValidator: (date) => profileProvider.validateDate(date),
            startDate: educationStartDates[x],
            endDate: educationEndDates[x],
            onStartDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showStartDateTime(
                  educationStartDates[x], educationEndDates[x]);
              setState(() {
                educationStartDates[x] = newTime;
                if (newTime != null) {
                  startDateControllers[x].text =
                      formatter.format(educationStartDates[x]!);
                } else {
                  startDateControllers[x].text = "";
                }
              });
            },
            onEndDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showEndDateTime(
                  educationEndDates[x], educationStartDates[x]);

              setState(() {
                educationEndDates[x] = newTime;
                if (newTime != null) {
                  endDateControllers[x].text =
                      formatter.format(educationEndDates[x]!);
                } else {
                  endDateControllers[x].text = "";
                }
              });
            }),
      ));
    }

    return Column(
      children: entries,
    );
  }

  void addDataToModels() {
    for (int x = 0; x < workingModelList.length; x++) {
      workingModelList[x].positionHeld = workingPositionHeldControllers[x].text;

      workingModelList[x].employer = workingEmployerControllers[x].text;

      workingModelList[x].location = workingLocationControllers[x].text;

      workingModelList[x].startDate = workingStartDates[x]!;

      workingModelList[x].endDate = workingEndDates[x]!;
    }

    for (int x = 0; x < eventModelList.length; x++) {
      eventModelList[x].positionHeld = eventPositionHeldControllers[x].text;

      eventModelList[x].event = eventNameControllers[x].text;

      eventModelList[x].location = eventLocationControllers[x].text;

      eventModelList[x].startDate = eventStartDates[x]!;

      eventModelList[x].endDate = eventEndDates[x]!;
    }

    for (int x = 0; x < educationModelList.length; x++) {
      educationModelList[x].institution = institutionControllers[x].text;

      educationModelList[x].lastHighestQualification = qualificationControllers[x].text;

      educationModelList[x].location = locationControllers[x].text;

      educationModelList[x].startDate = educationStartDates[x]!;

      educationModelList[x].endDate = educationEndDates[x]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ApplicationProvider applicationProvider = Provider.of<ApplicationProvider>(context);
    JobProvider jobProvider = Provider.of<JobProvider>(context, listen: false);
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Review Your Application",
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal Information",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            keyboardInput: TextInputType.name,
                            controller: fullNameController,
                            validator: (name) => authProvider.validateFullName(name!.trim()),
                            label: "Full Name",
                            readOnly: true,
                          ),
                      
                          const SizedBox(height: 10),
                      
                          CustomFieldButton(
                            label: "Date of Birth",
                            controller: dateOfBirthController,
                            validator: (dateOfBirth) => authProvider.validateDateOfBirth(dateOfBirth),
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
                            validator: (email) => authProvider.validateEmail(email!.trim()),
                            label: "Email",
                            readOnly: true,
                          ),
                                  
                          const SizedBox(height: 10),
                      
                          CustomTextFormField(
                            prefixLabel: "+62",
                            keyboardInput: TextInputType.phone,
                            controller: phoneController,
                            validator: (phoneNumber) => authProvider.validatePhoneNumber(phoneNumber!.trim()),
                            label: "Phone Number",
                            readOnly: true,
                          ),
                                  
                          const SizedBox(height: 10),
                      
                          CustomTextFormField(
                            keyboardInput: TextInputType.streetAddress,
                            controller: placeOfResidenceController,
                            validator: (place) => authProvider.validatePlaceOfResidence(place!.trim()),
                            label: "Place of Residence",
                            readOnly: true,
                          ),
                      
                          const SizedBox(
                            height: 30,
                          ),
                      
                          Text(
                            "Working Experiences",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _setWorkingExperiences(profileProvider),
                          SecondaryButton(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Add",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                ),
                              ),
                              onTap: () {
                                addWorkingItem();
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Education",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _setEducation(profileProvider),
                          SecondaryButton(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Add",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                ),
                              ),
                              onTap: () {
                                addEducationItem();
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Other Experiences",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _setOtherExperiences(profileProvider),
                          SecondaryButton(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Add",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                ),
                              ),
                              onTap: () {
                                addEventItem();
                              }),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                Visibility(
                  visible: !_hideApplyButton,
                  child: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: scrollController.position.userScrollDirection == ScrollDirection.reverse ? 0 : 75,
                          child: Wrap(
                            children: [
                              child!
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: PrimaryButton(
                          label: "Submit Application",
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              addDataToModels();
                              final application = ApplicationModel(
                                id: UniqueKey().toString(), 
                                solicitorId: authProvider.currentUser!.uid, 
                                jobId: jobProvider.selectedJob.id, 
                                jobTitle: jobProvider.selectedJob.title, 
                                employerId: jobProvider.selectedJob.employerId,
                                fullName: fullNameController.text,
                                employerName: jobProvider.selectedJob.employerName, 
                                dateOfBirth: dateOfBirth!, 
                                email: emailController.text, 
                                phoneNumber: phoneController.text, 
                                placeOfResidence: placeOfResidenceController.text, 
                                resumeUrl: profileProvider.userProfile!.resumeUrl,
                                dateApplied: DateTime.now(),
                                dateUpdated: DateTime.now(),  
                                status: ApplicationStatus.submitted.status, 
                              );
                              bool successful = await applicationProvider.setApplication(
                                application,
                                workingModelList,
                                eventModelList,
                                educationModelList
                              );
                              notificationsProvider.setNotifications("${profileProvider.userProfile?.fullName ?? ""} has sent you an application for ${jobProvider.selectedJob.title}", NotificationType.application, jobProvider.selectedJob.employerId);
                              if (successful && context.mounted) {
                                Navigator.popUntil(context,
                                ModalRoute.withName(ScreenRoutes.main.route));
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

        applicationProvider.applyStatus == ApplyStatus.uploading ?
              const CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
      ],
    );
  }
}
