import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customSecureTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryTextButton.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime? dateOfBirth;

  DateFormat formatter = DateFormat("d MMM yyyy");

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController placeOfResidenceController;
  late TextEditingController dateOfBirthController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late bool obscureText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    placeOfResidenceController = TextEditingController();
    dateOfBirthController = TextEditingController();
    obscureText = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    placeOfResidenceController.dispose();
    dateOfBirthController.dispose();
  }

  void _showDateTime() {
    showDatePicker(
      context: context, 
      initialDate: (dateOfBirth != null) ? dateOfBirth : DateTime.now(),
      firstDate: DateTime(120), 
      lastDate: DateTime.now()
    ).then((value) => setState(() {
      dateOfBirth = value;
      if (dateOfBirth != null) {
        dateOfBirthController.text = formatter.format(dateOfBirth!);
      } else {
        dateOfBirthController.text = "";
      }
    }));
  }

  

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final employerProvider = Provider.of<SolicitorProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                    
                        const SizedBox(height: 20),
                    
                        CustomTextFormField(
                          keyboardInput: TextInputType.name,
                          controller: fullNameController,
                          validator: (name) => authProvider.validateName(name!.trim()),
                          label: "Full Name or Business Name"
                        ),
                    
                        const SizedBox(height: 20),
                    
                        CustomFieldButton(
                          label: "Date of Birth",
                          controller: dateOfBirthController,
                          validator: (dateOfBirth) => authProvider.validateDateOfBirth(dateOfBirth),
                          defaultInnerLabel: (dateOfBirthController.text.isNotEmpty) ? formatter.format(dateOfBirth!) : "Pilih Tanggal",
                          suffixIcon: const Icon(
                            Icons.calendar_month_rounded
                          ),
                          onFieldTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _showDateTime();
                          },
                        ),
                                
                        const SizedBox(height: 20),
                    
                        CustomTextFormField(
                          keyboardInput: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (email) => authProvider.validateEmail(email!.trim()),
                          label: "Email"
                        ),
                                
                        const SizedBox(height: 20),
                    
                        CustomSecureTextFormField(
                          keyboardInput: TextInputType.visiblePassword,
                          label: "Password",
                          controller: passwordController,
                          validator: (password) => authProvider.validatePassword(password!.trim()),
                          obscureText: obscurePassword,
                          helperText: "Include numbers or special characters such as 1 or @",
                          onRevealTap: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                                
                        const SizedBox(height: 20),
                    
                        CustomTextFormField(
                          prefixLabel: "+62",
                          keyboardInput: TextInputType.phone,
                          controller: phoneController,
                          validator: (phoneNumber) => authProvider.validatePhoneNumber(phoneNumber!.trim()),
                          label: "Phone Number"
                        ),
                                
                        const SizedBox(height: 20),
                    
                        CustomTextFormField(
                          keyboardInput: TextInputType.streetAddress,
                          controller: placeOfResidenceController,
                          validator: (place) => authProvider.validateBusinessAddress(place!.trim()),
                          label: "Business Address"
                        ),
                                
                        const SizedBox(height: 20),
                                
                       Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                                
                            SecondaryTextButton(
                              label: "Sign in here", 
                              onTap: () {
                                Navigator.pop(context);
                              }
                            )
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                    
                        authProvider.authStatus == AuthStatus.failed ?
                                Text(
                                  authProvider.registrationError.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ) :
                                Container(),
                                
                        const SizedBox(height: 30),
                                
                        PrimaryButton(
                          label: "Register", 
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              bool successfulRegister = await authProvider.registerUser(fullNameController.text.trim(), emailController.text.trim(), passwordController.text.trim(), dateOfBirth!, phoneController.text.trim(), placeOfResidenceController.text.trim());
                              if (successfulRegister && context.mounted) {
                                jobProvider.getAllJobs();
                                employerProvider.getAllSolicitors();
                                Navigator.pushNamed(context, ScreenRoutes.main.route);
                              }
                            }
                          }
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            authProvider.authStatus == AuthStatus.authenticating ?
              const CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
          ],
        ),
      ),
    );
  }
}