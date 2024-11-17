import 'package:flutter/rendering.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us_employer/features/interviews/model/interviewModel.dart';
import 'package:jobs_r_us_employer/features/interviews/presentation/widgets/interviewForm.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customDropDownMenu.dart';
import 'package:jobs_r_us_employer/general_widgets/errorButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateInterview extends StatefulWidget {
  const CreateInterview({super.key});

  @override
  State<CreateInterview> createState() => _CreateInterviewState();
}

class _CreateInterviewState extends State<CreateInterview> with WidgetsBindingObserver {
  late ScrollController scrollController;

  late bool _hideSaveButton;
  late TextEditingController methodController;
  late TextEditingController linkController;
  late TextEditingController preparationsController;
  late TextEditingController hoursController;

  late InterviewTypes selectedType;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  List<DateTime?> dates = [];
  List<TimeOfDay?> times = [];
  List<DateTime> availableDates = [];

  List<TextEditingController> dateControllers = [];
  List<TextEditingController> timeControllers = [];

  List<String> types = [
    "Telephone",
    "Google Meet",
    "Zoom"
  ];

  void addNewDates() {
    dates.add(null);
    times.add(null);
    
    dateControllers.add(TextEditingController());
    timeControllers.add(TextEditingController());
  }

  void removeDates(int index) {
    dates.removeAt(index);
    times.removeAt(index);

    dateControllers[index].dispose();
    timeControllers[index].dispose();

    dateControllers.removeAt(index);
    timeControllers.removeAt(index);
  }

   Future<DateTime?> showDate(DateTime? date) {
    return showDatePicker(
      context: context,
      initialDate: (date != null) ? date : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 120)
    );
  }

  Future<TimeOfDay?> showTime(TimeOfDay? time) {
    return showTimePicker(
      context: context,
      initialTime: (time != null) ? time : TimeOfDay.now(),
    );
  }

  Widget setDates(InterviewProvider provider) {
    List<Widget> entries = [];

    for (int x = 0; x < dates.length; x++) {
      entries.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Time Slot ${(x + 1).toString()}",
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
              setState(() {
                removeDates(x);
              });
            },
          )
        ],
      ));

      entries.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: InterviewForm(
            timeController: timeControllers[x],
            time: times[x],
            timeValidator: (input) => provider.validateTime(input),
            dateController: dateControllers[x],
            date: dates[x],
            dateValidator: (input) => provider.validateDate(input),
            onDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await showDate(
                  dates[x]);
              setState(() {
                dates[x] = newTime;
                if (newTime != null) {
                  dateControllers[x].text =
                      formatter.format(dates[x]!);
                } else {
                  dateControllers[x].text = "";
                }
              });
            },
            onTimeTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await showTime(
                  times[x]);

              setState(() {
                times[x] = newTime;
                if (newTime != null) {
                  if (times[x]!.minute < 10) {
                    timeControllers[x].text = "${times[x]!.hour} : 0${times[x]!.minute}";
                  } else {
                    timeControllers[x].text = "${times[x]!.hour} : ${times[x]!.minute}";
                  }
                } else {
                  timeControllers[x].text = "";
                }
              });
            }),
      ));
    }

    return Column(
      children: entries,
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _hideSaveButton = false;
    methodController = TextEditingController();
    linkController = TextEditingController();
    preparationsController = TextEditingController();
    hoursController = TextEditingController();
    selectedType = InterviewTypes.phoneCall;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    methodController.dispose();
    linkController.dispose();
    preparationsController.dispose();
    hoursController.dispose();
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
    JobProvider jobProvider = Provider.of<JobProvider>(context, listen: false);
    SolicitorProvider solicitorProvider = Provider.of<SolicitorProvider>(context, listen: false);
    InterviewProvider interviewProvider = Provider.of<InterviewProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    ApplicationProvider applicationProvider = Provider.of<ApplicationProvider>(context, listen: false);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Schedule Interview",
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
                          const SizedBox(height: 5,),

                          Text(
                            "Interview Details",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 20,),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Interview Method",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                            
                                const SizedBox(height: 5,),

                                CustomDropdownMenu(
                                  initialSelection: types.first ,
                                  entries: <DropdownMenuEntry<String>>[
                                    DropdownMenuEntry(
                                        value: types[0], label: types[0]),
                                    DropdownMenuEntry(
                                        value: types[1], label: types[1]),
                                    DropdownMenuEntry(
                                        value: types[2], label: types[2]),
                                  ],
                                  onSelected: (String? value) {
                                    setState(() {
                                      switch (value) {
                                      case "Telephone":
                                        selectedType = InterviewTypes.phoneCall;
                                        break;
                                      case "Google Meet":
                                        selectedType = InterviewTypes.google;
                                        break;
                                      case "Zoom":
                                        selectedType = InterviewTypes.zoom;
                                        break;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10,),

                          (selectedType != InterviewTypes.phoneCall) ?
                            CustomTextFormField(
                              label: "Interview Call Link",
                              controller: linkController,
                              validator: (input) => interviewProvider.validateLink(input),
                            ) : Container(),

                          const SizedBox(height: 10,),

                          CustomTextFormField(
                            label: "Additional Preparations",
                            keyboardInput: TextInputType.multiline,
                            maxLength: 300,
                            controller: preparationsController,
                            validator: (input) => interviewProvider.validateAdditonalPreparations(input),
                          ),

                          const SizedBox(height: 30,),

                          Text(
                            "Interview Time Slots",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                              
                          const SizedBox(height: 20,),

                          setDates(interviewProvider),

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
                                setState(() {
                                  addNewDates();
                                });
                              }),

                          interviewProvider.interviewStatus == InterStatus.failed ?
                            Text(
                              interviewProvider.interviewError.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ) :
                            Container(),

                          const SizedBox(height: 100,),      
                        ],
                      ),
                    ),
                  ),
                ),
        
                Visibility(
                  visible: !_hideSaveButton,
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
                      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: PrimaryButton(
                        label: "Create Interview", 
                        onTap: () async {
                          if (formKey.currentState!.validate() && dates.isNotEmpty) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            for (int x = 0; x < dates.length; x++) {
                              final date = DateTime(dates[x]!.year, dates[x]!.month, dates[x]!.day, times[x]!.hour, times[x]!.minute);
                              availableDates.add(date);
                            }
                            availableDates.sort((a, b) {
                              return a.compareTo(b);
                            });
                                        
                            var interviews = InterviewModel(
                              id: UniqueKey().toString(), 
                              solicitorId: solicitorProvider.selectedSolicitor.id, 
                              employerId: authProvider.currentUser?.uid ?? "",
                              jobId: jobProvider.selectedJob.id, 
                              interviewMethod: selectedType.types, 
                              link: selectedType != InterviewTypes.phoneCall ? linkController.text : "", 
                              additionalPreparations: preparationsController.text, 
                              selectedDate: DateTime.now(),
                              lastUpdatedDate: DateTime.now(), 
                              status: InterviewStatus.pendingSchedule.status,
                              availableDates: availableDates,
                              solicitorName: solicitorProvider.selectedSolicitor.fullName,
                              employerName: profileProvider.userProfile?.name ?? "",
                              jobTitle: jobProvider.selectedJob.title
                            );
                            bool successfulUpload = await interviewProvider.setInterview(
                              interviews
                            );
                            applicationProvider.selectedApplication.status = ApplicationStatus.pendingInterview.status;
                            successfulUpload = await applicationProvider.setApplication(applicationProvider.selectedApplication);
                            if (successfulUpload && context.mounted) {
                              notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? ""} sent an interview.", NotificationType.interview, solicitorProvider.selectedSolicitor.id);
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

        interviewProvider.interviewStatus == InterStatus.processing ?
                  const CustomLoadingOverlay(enableDarkBackground: true,) :
                  Container()
      ],
    );
  }
}