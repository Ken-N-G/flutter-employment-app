import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/widgets/listSection.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/presentation/widgets/educationItem.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/presentation/widgets/experienceItem.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/presentation/widgets/otherExperienceItem.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/educationModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/eventExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/workingExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/presentation/widgets/solicitorProfilePicture.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/errorTextButton.dart';
import 'package:jobs_r_us_employer/general_widgets/headerAndBodySection.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class SolicitorDetails extends StatelessWidget {
  const SolicitorDetails({super.key});

   List<Widget> _setWorkingExperiences(List<WorkingExperienceModel> workingExperience, BuildContext context) {
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

  List<Widget> _setEventExperiences(List<EventExperienceModel> eventExperience, BuildContext context) {
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

  List<Widget> _setEducation(List<EducationModel> education, BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final solicitorProvider = Provider.of<SolicitorProvider>(context);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Applicant Details",
        actions: [
          ErrorTextButton(
            label: "Report", 
            onTap: () {
              Navigator.pushNamed(context, ScreenRoutes.reportProfile.route);
            }
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SolicitorProfilePicture(
                      profileUrl: solicitorProvider.selectedSolicitor.profileUrl,
                    ),
                          
                    const SizedBox(
                      width: 10,
                    ),
                          
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            solicitorProvider.selectedSolicitor.fullName,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700
                            ),  
                          ),
                          
                          const SizedBox(height: 5,),
                      
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              
                              const SizedBox(
                                width: 5,
                              ),
                          
                              Text(
                                (DateTime.now().year - solicitorProvider.selectedSolicitor.dateOfBirth.year).toString(),
                                style: Theme.of(context).textTheme.bodyMedium
                              ),
                            ],
                          ),

                          const SizedBox(height: 5,),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              
                              const SizedBox(
                                width: 5,
                              ),
                                  
                              Flexible(
                                child: Text(
                                  solicitorProvider.selectedSolicitor.placeOfResidence,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30,),

                Text(
                  "Contact Details",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 20,),

                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          
                          const SizedBox(
                            width: 5,
                          ),
                              
                          Flexible(
                            child: Text(
                              solicitorProvider.selectedSolicitor.email,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
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
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          
                          const SizedBox(
                            width: 5,
                          ),
                              
                          Flexible(
                            child: Text(
                             solicitorProvider.selectedSolicitor.phoneNumber,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                          
                const SizedBox(height: 30,),
                          
                HeaderAndBodySection(
                  sectionHeader: "About Me",
                  body: solicitorProvider.selectedSolicitor.aboutMe,
                ),
                          
                const SizedBox(height: 30,),
                          
                ListSection(
                  contentEmpty: solicitorProvider.workingExperiences.isEmpty,
                  sectionHeader: "Working Experiences",
                  children: _setWorkingExperiences(solicitorProvider.workingExperiences, context)
                ),
          
                const SizedBox(height: 30,),
          
                ListSection(
                  contentEmpty: solicitorProvider.educationList.isEmpty,
                  sectionHeader: "Education",
                  children: _setEducation(solicitorProvider.educationList, context)
                ),
          
                const SizedBox(height: 30,),
          
                ListSection(
                  contentEmpty: solicitorProvider.eventExperiences.isEmpty,
                  sectionHeader: "Other Experiences",
                  children: _setEventExperiences(solicitorProvider.eventExperiences, context)
                ),

                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}