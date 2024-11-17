import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/widgets/editableTextSection.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _collapsedProfile = true;

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
                              profileProvider.userProfile?.name ?? "-",
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
                                        profileProvider.userProfile?.businessAddress ?? "-",
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
                                      Icons.location_city_rounded,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                    
                                    const SizedBox(
                                      width: 5,
                                    ),
                                        
                                    Flexible(
                                      child: Text(
                                        profileProvider.userProfile?.type ?? "-",
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

                  EditableTextSection(
                    contentEmpty: (profileProvider.userProfile?.aboutUs ?? "").isEmpty, 
                    body: profileProvider.userProfile?.aboutUs ?? "",
                    onEditTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.editProfileTextSection.route);
                    }, 
                    sectionHeader: "About Us"
                  ),

                  const SizedBox(height: 30,),

                  EditableTextSection(
                    contentEmpty: (profileProvider.userProfile?.visionMission ?? "").isEmpty, 
                    body: profileProvider.userProfile?.visionMission ?? "",
                    onEditTap: () {
                      Navigator.pushNamed(context, ScreenRoutes.editVisionAndMissionSection.route);
                    }, 
                    sectionHeader: "Vision and Mission"
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