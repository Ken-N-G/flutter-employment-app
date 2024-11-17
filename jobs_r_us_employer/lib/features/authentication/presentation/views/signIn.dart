import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/customSecureTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryTextButton.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  late TextEditingController emailController;
  late TextEditingController passwordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _obscureText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _obscureText = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }


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
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Welcome, let's connect you with workers",
                          style: Theme.of(context).textTheme.displaySmall,
                          ),
                    
                        const SizedBox(height: 40),
                    
                        CustomTextFormField(
                          keyboardInput: TextInputType.emailAddress,
                          controller: emailController,
                          label: "Email",
                          validator: (email) => authProvider.validateEmail(email!.trim()),
                        ),
                                
                        const SizedBox(height: 20),
                    
                        CustomSecureTextFormField(
                          obscureText: _obscureText,
                          onRevealTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          keyboardInput: TextInputType.visiblePassword,
                          controller: passwordController,
                          label: "Password",
                          validator: (password) => authProvider.validatePasswordOnSignIn(password!.trim()),
                        ),
                                
                        const SizedBox(height: 20),
                                
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                                
                            SecondaryTextButton(
                              label: "Register here", 
                              onTap: () {
                                Navigator.pushNamed(context, ScreenRoutes.register.route);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        authProvider.authStatus == AuthStatus.failed ?
                          Text(
                            authProvider.loginError.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ) :
                          Container(),
                                
                        const SizedBox(height: 30),
                                
                        PrimaryButton(
                          label: "Sign In", 
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              bool successfulSignIn = await authProvider.authenticateUser(emailController.text.trim(), passwordController.text.trim());
                              if (successfulSignIn && context.mounted) {
                                jobProvider.getAllJobs();
                                employerProvider.getAllSolicitors();
                                Navigator.pushNamed(context, ScreenRoutes.main.route);
                              }
                            }
                          }
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            authProvider.authStatus == AuthStatus.authenticating ?
              CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
          ],
        ),
      ),
    );
  }
}