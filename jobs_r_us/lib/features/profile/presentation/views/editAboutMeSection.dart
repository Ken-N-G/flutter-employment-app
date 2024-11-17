import 'package:flutter/material.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class EditAboutMeSection extends StatefulWidget {
  const EditAboutMeSection({super.key});

  @override
  State<EditAboutMeSection> createState() => _EditAboutMeSectionState();
}

class _EditAboutMeSectionState extends State<EditAboutMeSection> with WidgetsBindingObserver {

  late bool _hideSaveButton;
  late TextEditingController aboutMeController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hideSaveButton = false;
    aboutMeController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      aboutMeController.text = profileProvider.userProfile!.aboutMe;
    });
  }

  @override
  void dispose() {
    super.dispose();
    aboutMeController.dispose();
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
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Edit About Me",
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
                          
                          CustomTextFormField(
                            label: "About Me",
                            maxLines: null,
                            maxLength: 300,
                            keyboardInput: TextInputType.multiline,
                            controller: aboutMeController,
                            validator: (input) => profileProvider.validateAboutMe(input),
                          ),
                              
                          const SizedBox(height: 20,),

                          profileProvider.userStatus == DataStatus.failed ?
                            Text(
                              profileProvider.userError.toString(),
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
                  visible: !_hideSaveButton,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: PrimaryButton(
                        label: "Save", 
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            profileProvider.hasEditedAboutMe = true;
                            bool successfulUpload = await profileProvider.setUserProfile(
                              aboutMe: aboutMeController.text.trim()
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

        profileProvider.userStatus == DataStatus.processing ?
                  const CustomLoadingOverlay(enableDarkBackground: true,) :
                  Container()
      ],
    );
  }
}