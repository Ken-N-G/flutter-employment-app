import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/applications/presentation/widgets/otherExperienceForm.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/profile/model/eventExperienceModel.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/errorButton.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class EditOtherExperienceSection extends StatefulWidget {
  const EditOtherExperienceSection({super.key});

  @override
  State<EditOtherExperienceSection> createState() => _EditOtherExperienceSectionState();
}

class _EditOtherExperienceSectionState extends State<EditOtherExperienceSection> with WidgetsBindingObserver {
  late ScrollController scrollController;

  late bool _hideSaveButton;

  List<EventExperienceModel> modelList = [];
  List<TextEditingController> positionHeldControllers = [];
  List<TextEditingController> eventControllers = [];
  List<TextEditingController> locationControllers = [];
  List<TextEditingController> startDateControllers = [];
  List<TextEditingController> endDateControllers = [];
  List<DateTime?> startDates = [];
  List<DateTime?> endDates = [];

  DateFormat formatter = DateFormat("d MMM yyyy");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _hideSaveButton = false;
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      for (var item in profileProvider.eventExperiences ?? []) {
        modelList.add(
          item.copyWith()
        );
      }
      for (var item in modelList) {
        addControllers(item);
        addDates(item);
      }
      profileProvider.updateListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    for (int x = modelList.length - 1; x > -1; x--) {
      removeControllers(x);
    }
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

  void addDates(EventExperienceModel? item) {
    if (item != null) {
      startDates.add(item.startDate);
      endDates.add(item.endDate);
    } else {
      startDates.add(null);
      endDates.add(null);
    }
  }

  void addControllers(EventExperienceModel? item) {
    positionHeldControllers.add(addPositionHeldController(item));
    eventControllers.add(addEventController(item));
    locationControllers.add(addLocationController(item));
    startDateControllers.add(addStartDateController(item));
    endDateControllers.add(addEndDateController(item));
  }

  TextEditingController addPositionHeldController(EventExperienceModel? item) {
    if (item != null) {
      return TextEditingController(text: item.positionHeld);
    } else {
      return TextEditingController();
    }
  }

  TextEditingController addEventController(EventExperienceModel? item) {
    if (item != null) {
      return TextEditingController(text: item.event);
    } else {
      return TextEditingController();
    }
  }
  
  TextEditingController addLocationController(EventExperienceModel? item) {
    if (item != null) {
      return TextEditingController(text: item.location);
    } else {
      return TextEditingController();
    }
  }

  TextEditingController addStartDateController(EventExperienceModel? item) {
    if (item != null) {
      return TextEditingController(text: formatter.format(item.startDate));
    } else {
      return TextEditingController();
    }
  }

  TextEditingController addEndDateController(EventExperienceModel? item) {
    if (item != null) {
      return TextEditingController(text: formatter.format(item.endDate));
    } else {
      return TextEditingController();
    }
  }

  void removeDates(int index) {
    startDates.removeAt(index);
    endDates.removeAt(index);
  }

  void removeControllers(int index) {
    removePositionHeldController(index);
    removeEmployerController(index);
    removeLocationController(index);
    removeStartDateController(index);
    removeEndDateController(index);
  }

  void removePositionHeldController(int index) {
    positionHeldControllers[index].dispose();
    positionHeldControllers.removeAt(index);
  }

  void removeEmployerController(int index) {
    eventControllers[index].dispose();
    eventControllers.removeAt(index);
  }
  
  void removeLocationController(int index) {
    locationControllers[index].dispose();
    locationControllers.removeAt(index);
  }

  void removeStartDateController(int index) {
    startDateControllers[index].dispose();
    startDateControllers.removeAt(index);
  }

  void removeEndDateController(int index) {
    endDateControllers[index].dispose();
    endDateControllers.removeAt(index);
  }

  void deleteItem(int index) {
    setState(() {
      modelList.removeAt(index);
      removeControllers(index);
      removeDates(index);
    });
  }

  void addItem() {
    setState(() {
      EventExperienceModel newItem = EventExperienceModel(
        id: UniqueKey().toString(), 
        positionHeld: "", 
        event: "", 
        location: "",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      modelList.add(newItem);
      addControllers(null);
      addDates(null);
    });
  }

  Future<DateTime?> _showStartDateTime(DateTime? startDate, DateTime? endDate) {
    return showDatePicker(
      context: context, 
      initialDate: (startDate != null) ? startDate : DateTime.now(),
      firstDate: DateTime(120), 
      lastDate: (endDate != null) ? endDate : DateTime.now()
    );
  }

  Future<DateTime?> _showEndDateTime(DateTime? endDate, DateTime? startDate) {
    return showDatePicker(
      context: context, 
      initialDate: (endDate != null) ? endDate : startDate,
      firstDate: (startDate != null) ? startDate : DateTime(120), 
      lastDate: DateTime.now()
    );
  }

  Widget _setExperiences(ProfileProvider profileProvider) {
    List<Widget> entries = [];
    
    for (int x = 0; x < modelList.length; x++) {
      entries.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Entry ${(x + 1).toString()}",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700
              ),
            ),

            ErrorButton(
              child: Icon(
                Icons.delete_rounded,
                color: Theme.of(context).colorScheme.onError,
              ),
              onTap: () {
                deleteItem(x);
              },
            )
          ],
        )
      );

      entries.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: OtherExperienceForm(
            positionHeldController: positionHeldControllers[x], 
            positionHeldValidator: (position) => profileProvider.validatePositionHeld(position), 
            eventController: eventControllers[x], 
            eventValidator: (event) => profileProvider.validateEvent(event), 
            locationController: locationControllers[x], 
            locationValidator: (location) => profileProvider.validateLocation(location),
            startDateController: startDateControllers[x], 
            startDateValidator: (date) => profileProvider.validateDate(date), 
            endDateController: endDateControllers[x], 
            endDateValidator: (date) => profileProvider.validateDate(date), 
            startDate: startDates[x], 
            endDate: endDates[x], 
            onStartDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showStartDateTime(startDates[x], endDates[x]);
              setState(() {
                startDates[x] = newTime;
                if (newTime != null) {
                  startDateControllers[x].text = formatter.format(startDates[x]!);
                } else {
                  startDateControllers[x].text = "";
                }
              });
            }, 
            onEndDateTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              var newTime = await _showEndDateTime(endDates[x], startDates[x]);

              setState(() {
                endDates[x] = newTime;
                if (newTime != null) {
                  endDateControllers[x].text = formatter.format(endDates[x]!);
                } else {
                  endDateControllers[x].text = "";
                }
              });
            }
          ),
        )
      );
    }

    return Column(
      children: entries,
    );
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
            title: "Edit Other Experiences",
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
                      
                          _setExperiences(profileProvider),
                      
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
                              addItem();
                            }),
                      
                          const SizedBox(height: 20,),

                          profileProvider.eventExperienceStatus == DataStatus.failed ?
                          Text(
                            profileProvider.eventError.toString(),
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
                        label: "Save", 
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            for (int x = 0; x < modelList.length; x++) {
                              modelList[x].positionHeld = positionHeldControllers[x].text.trim();
                              modelList[x].event = eventControllers[x].text.trim();
                              modelList[x].location = locationControllers[x].text.trim();
                              modelList[x].startDate = startDates[x]!;
                              modelList[x].endDate = endDates[x]!;
                            }
                            bool successfulUpload = await profileProvider.setOtherExperiences(
                              modelList
                            );
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

        profileProvider.eventExperienceStatus == DataStatus.processing ?
                  const CustomLoadingOverlay(enableDarkBackground: true,) :
                  Container()
      ],
    );
  }
}