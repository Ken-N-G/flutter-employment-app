import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/job_postings/model/jobPostModel.dart';
import 'package:jobs_r_us_employer/features/job_postings/presentation/widgets/mapPicker.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customDropDownMenu.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/errorButton.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class CreateJob extends StatefulWidget {
  const CreateJob({super.key});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> with WidgetsBindingObserver {

  late ScrollController scrollController;

  late bool _hideSaveButton;
  late TextEditingController titleController;
  late TextEditingController tagController;
  late TextEditingController salaryController;
  late TextEditingController hoursController;
  late TextEditingController locationController;
  late TextEditingController requirementsController;
  late TextEditingController descriptionController;
  late TextEditingController locationSearchController;
  
  LatLng? jobCoordinates;

  late JobType selectedType;

  List<String> types = [
    "Part Time",
    "Full Time",
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hideSaveButton = false;
    scrollController = ScrollController();
    titleController = TextEditingController();
    tagController = TextEditingController();
    salaryController = TextEditingController();
    hoursController = TextEditingController();
    locationController = TextEditingController();
    requirementsController = TextEditingController();
    descriptionController = TextEditingController();
    locationSearchController = TextEditingController();
    selectedType = JobType.partTime;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    titleController.dispose();
    locationSearchController.dispose();
    tagController.dispose();
    salaryController.dispose();
    hoursController.dispose();
    locationController.dispose();
    requirementsController.dispose();
    descriptionController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    if (context.mounted) {
      setState(() {
      if (View.of(context).viewInsets.bottom > 0.0) {
        _hideSaveButton = true;
      } else {
        _hideSaveButton = false;
      }
    });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    JobProvider jobProvider = Provider.of<JobProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Create Job",
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
                            "Basic Details",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 20,),
                          
                          CustomTextFormField(
                            label: "Job Title",
                            keyboardInput: TextInputType.name,
                            controller: titleController,
                            validator: (input) => jobProvider.validateTitle(input),
                          ),

                          const SizedBox(height: 10,),

                          CustomTextFormField(
                            label: "Job Tag",
                            keyboardInput: TextInputType.name,
                            controller: tagController,
                            validator: (input) => jobProvider.validateTag(input),
                          ),

                          const SizedBox(height: 10,),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Type",
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
                                  ],
                                  onSelected: (String? value) {
                                    setState(() {
                                      switch (value) {
                                      case "Part Time":
                                        selectedType = JobType.partTime;
                                        break;
                                      case "Full Time":
                                        selectedType = JobType.fullTime;
                                        break;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10,),

                          !(selectedType == JobType.fullTime) ?
                            CustomTextFormField(
                              label: "Working Hours per Week",
                              keyboardInput: TextInputType.number,
                              controller: hoursController,
                              validator: (input) => jobProvider.validateHours(input),
                            ) : Container(),

                          const SizedBox(height: 10,),

                          CustomTextFormField(
                            label: "Salary per Month",
                            keyboardInput: TextInputType.number,
                            controller: salaryController,
                            validator: (input) => jobProvider.validateSalary(input),
                          ),

                          const SizedBox(height: 10,),

                          CustomTextFormField(
                            label: "Location",
                            keyboardInput: TextInputType.multiline,
                            controller: locationController,
                            validator: (input) => jobProvider.validateLocation(input),
                          ),

                          const SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SecondaryButton(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.map_rounded,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                              
                                    const SizedBox(width: 10,),
                              
                                    Text(
                                      "Select from Map",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onSecondary,
                                        fontWeight: FontWeight.w700
                                      ),  
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  await showModalBottomSheet<void>(
                                    enableDrag: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MapPicker(
                                        jobCoordinates: jobCoordinates,
                                        onLocationSave: (address, coordinates) {
                                          jobCoordinates = coordinates;
                                          setState(() {
                                            locationController.text = address;
                                          });
                                        },
                                      );
                                    }
                                  );
                                }),

                                Visibility(
                                  visible: jobCoordinates != null,
                                  child: ErrorButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete_rounded,
                                          color: Theme.of(context).colorScheme.onError,
                                        ),
                                  
                                        const SizedBox(width: 10,),
                                                                
                                        Text(
                                          "Manually Select",
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Theme.of(context).colorScheme.onSecondary,
                                            fontWeight: FontWeight.w700
                                          ),  
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        locationController.text = "";
                                        jobCoordinates = null;
                                      });
                                    },
                                  ),
                                )
                            ],
                          ),

                          const SizedBox(height: 30,),

                          Text(
                            "Job Details",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 20,),

                          CustomTextFormField(
                            label: "Job Description",
                            maxLines: null,
                            maxLength: 300,
                            keyboardInput: TextInputType.multiline,
                            controller: descriptionController,
                            validator: (input) => jobProvider.validateDescription(input),
                          ),

                          const SizedBox(height: 10,),

                          CustomTextFormField(
                            label: "Requirements",
                            maxLines: null,
                            maxLength: 500,
                            keyboardInput: TextInputType.multiline,
                            controller: requirementsController,
                            validator: (input) => jobProvider.validateRequirements(input),
                          ),
                              
                          const SizedBox(height: 20,),

                          jobProvider.jobStatus == JobStatus.failed ?
                            Text(
                              jobProvider.jobError.toString(),
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
                        label: "Create Job", 
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var newJob = JobPostModel(
                              id: UniqueKey().toString(), 
                              employerId: authProvider.currentUser?.uid ?? "", 
                              title: titleController.text, 
                              type: selectedType.type, 
                              tag: tagController.text, 
                              location: locationController.text, 
                              isOpen: true, 
                              datePosted: DateTime.now(), 
                              workingHours: selectedType == JobType.fullTime ? 40 : int.parse(hoursController.text), 
                              salary: int.parse(salaryController.text), 
                              description: descriptionController.text, 
                              requirements: requirementsController.text,
                              employerName: profileProvider.userProfile?.name ?? "",
                              longitude: jobCoordinates?.longitude ?? 0.0,
                              latitude: jobCoordinates?.latitude ?? 0.0
                            );
                            bool successfulUpload = await jobProvider.setJob(
                              newJob,
                              true
                            );
                            if (successfulUpload && context.mounted) {
                              notificationsProvider.setNotifications("${profileProvider.userProfile?.name ?? "One of your followers "} has opened a new position.", NotificationType.employer, "");
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

        jobProvider.jobStatus == JobStatus.uploading ?
                  const CustomLoadingOverlay(enableDarkBackground: true,) :
                  Container()
      ],
    );
  }
}