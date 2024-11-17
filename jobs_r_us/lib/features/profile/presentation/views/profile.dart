import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/profile/model/educationModel.dart';
import 'package:jobs_r_us/features/profile/model/eventExperienceModel.dart';
import 'package:jobs_r_us/features/profile/model/workingExperienceModel.dart';
import 'package:jobs_r_us/features/profile/presentation/widgets/editableListSection.dart';
import 'package:jobs_r_us/features/profile/presentation/widgets/editableTextSection.dart';
import 'package:jobs_r_us/features/profile/presentation/widgets/educationItem.dart';
import 'package:jobs_r_us/features/profile/presentation/widgets/experienceItem.dart';
import 'package:jobs_r_us/features/profile/presentation/widgets/otherExperienceItem.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _collapsedProfile = true;

  List<Widget> _setWorkingExperiences(List<WorkingExperienceModel> workingExperience) {
    List<Widget> entries = [];

    for (int x = 0; x < workingExperience.length; x++) {
      entries.add(
        Padding(
          padding: EdgeInsets.only(bottom: x < workingExperience.length - 1 ? 10 : 0, top: x != 0  ? 10 : 0),
          child: ExperienceItem(
            position: workingExperience[x].positionHeld,
            employerOrEvent: workingExperience[x].employer,
            jobLocation: workingExperience[x].location,
            startDate: workingExperience[x].startDate,
            endDate: workingExperience[x].endDate
          )
        )
      );

      if (x < workingExperience.length - 1) {
        entries.add(
          Divider(
            color: Theme.of(context).colorScheme.outline,
          )
        );
      }
    }

    return entries;
  }

  List<Widget> _setEventExperiences(List<EventExperienceModel> eventExperience) {
    List<Widget> entries = [];
    for (int x = 0; x < eventExperience.length; x++) {
      entries.add(
        Padding(
          padding: EdgeInsets.only(bottom: x < eventExperience.length - 1 ? 10 : 0, top: x != 0  ? 10 : 0),
          child: OtherExperienceItem(
            position: eventExperience[x].positionHeld,
            employerOrEvent: eventExperience[x].event,
            jobLocation: eventExperience[x].location,
            startDate: eventExperience[x].startDate,
            endDate: eventExperience[x].endDate
          )
        )
      );

      if (x < eventExperience.length - 1) {
        entries.add(
          Divider(
            color: Theme.of(context).colorScheme.outline,
          )
        );
      }
    }

    return entries;
  }

  List<Widget> _setEducation(List<EducationModel> education) {
    List<Widget> entries = [];
    for (int x = 0; x < education.length; x++) {
      entries.add(
        Padding(
          padding: EdgeInsets.only(bottom: x < education.length - 1 ? 10 : 0, top: x != 0  ? 10 : 0),
          child: EducationItem(
            lastHighestQualification: education[x].lastHighestQualification,
            institution: education[x].institution,
            location: education[x].location,
            startDate: education[x].startDate,
            endDate: education[x].endDate
          )
        )
      );

      if (x < education.length - 1) {
        entries.add(
          Divider(
            color: Theme.of(context).colorScheme.outline,
          )
        );
      }
    }

    return entries;
  }

  Widget _setProfilePicture(String? profileUrl, BuildContext context) {
    if (profileUrl != null && profileUrl.isNotEmpty) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        width: 80,
        height: 80,
        child: Image.network(
          profileUrl,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Ink(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle
        ),
        child: Icon(
          Icons.person_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 64,
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.hasVisitedProfilePage = true;
      profileProvider.setUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return SafeArea(
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Material(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)
            ),
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      _setProfilePicture(profileProvider.userProfile?.profileUrl, context),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileProvider.userProfile?.fullName ?? "-",
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700
                              ),  
                            ),
                            
                            const SizedBox(height: 5,),
                        
                            Text(
                              (DateTime.now().year - (profileProvider.userProfile?.dateOfBirth ?? DateTime.now()).year).toString(),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),  
                            )
                          ],
                        ),
                      ),

                      SecondaryButton(
                        onTap: () {
                          Navigator.pushNamed(context, ScreenRoutes.editProfile.route);
                        },
                        child: Icon(
                          Icons.edit_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10,),

                  _collapsedProfile ?
                    Container() :
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email_rounded,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                    
                                    const SizedBox(
                                      width: 5,
                                    ),
                                        
                                    Flexible(
                                      child: Text(
                                        profileProvider.userProfile?.email ?? "-",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone_rounded,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                    
                                    const SizedBox(
                                      width: 5,
                                    ),
                                        
                                    Flexible(
                                      child: Text(
                                        profileProvider.userProfile?.phoneNumber ?? "-",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10,),

                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                    
                                    const SizedBox(
                                      width: 5,
                                    ),
                                        
                                    Flexible(
                                      child: Text(
                                        profileProvider.userProfile?.placeOfResidence ?? "-",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.label_rounded,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                    
                                    const SizedBox(
                                      width: 5,
                                    ),
                                        
                                    Flexible(
                                      child: Text(
                                        profileProvider.userProfile?.subscribedTag ?? "-",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: _collapsedProfile ? 0.0 : 10,),

                  _collapsedProfile ? 
                    SecondaryButton(
                      onTap: () {
                        setState(() {
                        _collapsedProfile = !_collapsedProfile;
                      });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                  
                          const SizedBox(width: 5,),  
                  
                          Text(
                            "Expand Profile",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.w700
                            ),  
                          ),
                        ],
                      )
                    ) :
                    SecondaryButton(
                    onTap: () {
                      setState(() {
                        _collapsedProfile = !_collapsedProfile;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                          size: 18,
                        ),
                  
                        const SizedBox(width: 5,),  
                  
                        Text(
                          "Collapse Profile",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.w700
                          ),  
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),

        SliverFillRemaining(
          hasScrollBody: false,
          child: Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [

                  profileProvider.resumeName != null ? Column(
                    children: [
                      
                      profileProvider.fileStatus == DataStatus.processing ? 
                        const CustomLoadingOverlay() :
                        Column(
                          children: [
                            Icon(
                              Icons.file_present_rounded,
                              color: Theme.of(context).colorScheme.outline,
                              size: 60,
                            ),
                            
                            const SizedBox(height: 5,),
                            
                            Text(
                              profileProvider.resumeName!,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                      
                      const SizedBox(height: 10,),
                    ],
                  ) : Container(),

                  PrimaryButton(
                    label: (profileProvider.userProfile?.resumeUrl ?? "").isEmpty ?
                    "Upload Resume" :
                    "Re-upload Resume",
                    width: null,
                    overrideTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                    onTap: () async {
                      File? selectedFile = await profileProvider.getPDFFromPhone(context);
                      if (selectedFile != null) {
                        await profileProvider.setResume(selectedFile);
                        await profileProvider.setUserProfile();
                      }
                    },
                  ),

                  const SizedBox(height: 30,),

                  EditableTextSection(
                    contentEmpty: (profileProvider.userProfile?.aboutMe ?? "").isEmpty, 
                    body: profileProvider.userProfile?.aboutMe ?? "",
                    onEditTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.editProfileTextSection.route);
                    }, 
                    sectionHeader: "About Me"
                  ),

                  const SizedBox(height: 30,),

                  EditableListSection(
                    contentEmpty: (profileProvider.workingExperiences ?? []).isEmpty,
                    onEditTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.editExperienceListSection.route);
                    },
                    onAddTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.addExperienceListSection.route);
                    },
                    sectionHeader: "Working Experiences",
                    children: _setWorkingExperiences(profileProvider.workingExperiences ?? [])
                  ),

                  const SizedBox(height: 30,),

                  EditableListSection(
                    contentEmpty: (profileProvider.educationList ?? []).isEmpty,
                    onEditTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.editEducationListSection.route);
                    },
                    onAddTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.addEducationListSection.route);
                    },
                    sectionHeader: "Education",
                    children: _setEducation(profileProvider.educationList ?? [])
                  ),

                  const SizedBox(height: 30,),

                  EditableListSection(
                    contentEmpty: (profileProvider.eventExperiences ?? []).isEmpty,
                    onEditTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.editOtherExperienceListSection.route);
                    }, 
                    onAddTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.addOtherExperienceListSection.route);
                    },
                    sectionHeader: "Other Experiences",
                    children: _setEventExperiences(profileProvider.eventExperiences ?? [])
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}