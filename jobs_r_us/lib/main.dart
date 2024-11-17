import 'package:flutter/material.dart';
import 'package:jobs_r_us/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobs_r_us/features/career_materials/domain/careerProvider.dart';
import 'package:jobs_r_us/features/career_materials/presentation/views/careerArticle.dart';
import 'package:jobs_r_us/features/career_materials/presentation/views/careerMaterials.dart';
import 'package:jobs_r_us/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us/features/feedback/presentation/views/createFeedback.dart';
import 'package:jobs_r_us/features/feedback/presentation/views/feedbackList.dart';
import 'package:jobs_r_us/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us/features/interviews/presentation/views/pickInterviewTimeSlot.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/job_postings/presentation/views/postingDetailsWithoutButton.dart';
import 'package:jobs_r_us/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us/features/notifications/presentation/views/notifications.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/profile/presentation/views/addEducationListSection.dart';
import 'package:jobs_r_us/features/profile/presentation/views/addExperienceListSection.dart';
import 'package:jobs_r_us/features/profile/presentation/views/addOtherExperienceListSection.dart';
import 'package:jobs_r_us/features/profile/presentation/views/editEducationListSection.dart';
import 'package:jobs_r_us/features/profile/presentation/views/editExperienceListSection.dart';
import 'package:jobs_r_us/features/report/domain/reportProvider.dart';
import 'package:jobs_r_us/features/report/presentation/views/reportFeedback.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'features/profile/presentation/views/editOtherExperienceListSection.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/core/theme/theme.dart';
import 'package:jobs_r_us/features/applications/presentation/views/applicationDetails.dart';
import 'package:jobs_r_us/features/applications/presentation/views/apply.dart';
import 'package:jobs_r_us/features/authentication/presentation/views/signIn.dart';
import 'package:jobs_r_us/features/interviews/presentation/views/interviewDetails.dart';
import 'package:jobs_r_us/features/job_postings/presentation/views/jobMarket.dart';
import 'package:jobs_r_us/features/job_postings/presentation/views/postingDetails.dart';
import 'package:jobs_r_us/features/navigationWrapper.dart';
import 'package:jobs_r_us/features/profile/presentation/views/editAboutMeSection.dart';
import 'package:jobs_r_us/features/profile/presentation/views/editProfileSection.dart';
import 'package:jobs_r_us/features/profile/presentation/views/options.dart';
import 'package:jobs_r_us/features/authentication/presentation/views/register.dart';
import 'package:jobs_r_us/features/report/presentation/views/reportAccount.dart';
import 'package:jobs_r_us/features/view_employers/presentation/views/employerDetails.dart';
import 'package:jobs_r_us/features/view_employers/presentation/views/employers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (context) => ProfileProvider(), 
          update: (context, auth, previousProfileProvider) => previousProfileProvider!..update(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ApplicationProvider>(
          create: (context) => ApplicationProvider(), 
          update: (context, auth, previousApplicationProvider) => previousApplicationProvider!..update(auth),
        ),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => EmployerProvider()),
        ChangeNotifierProxyProvider<AuthProvider, InterviewProvider>(
          create: (context) => InterviewProvider(), 
          update: (context, auth, previousInterviewProvider) => previousInterviewProvider!..update(auth),
        ),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => CareerProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProxyProvider2<AuthProvider, ProfileProvider, NotificationsProvider>(
          create: (context) => NotificationsProvider(), 
          update: (context, auth, prof, previousNotificationsProvider) => previousNotificationsProvider!..update(auth, prof),
        ),
      ],
      child: MaterialApp(
        title: 'Jobs R Us',
        theme: primaryTheme,
        initialRoute: ScreenRoutes.signIn.route,
        routes: {
          ScreenRoutes.onboarding.route : (context) => Container(),
          ScreenRoutes.signIn.route : (context) => const SignIn(),
          ScreenRoutes.register.route : (context) => const Register(),
          ScreenRoutes.main.route : (context) => const NavigationWrapper(),
          ScreenRoutes.jobMarket.route : (context) => const JobMarket(),
          ScreenRoutes.postingDetails.route : (context) => const PostingDetails(),
          ScreenRoutes.apply.route : (context) => const Apply(),
          ScreenRoutes.employers.route : (context) => const Employers(),
          ScreenRoutes.employerDetails.route : (context) => const EmployerDetails(),
          ScreenRoutes.applicationDetails.route : (context) => const ApplicationDetails(),
          ScreenRoutes.interviewDetails.route : (context) => const InterviewDetails(),
          ScreenRoutes.options.route : (context) => const Options(),
          ScreenRoutes.editProfileTextSection.route : (context) => const EditAboutMeSection(),
          ScreenRoutes.editExperienceListSection.route : (context) => const EditExperienceSection(),
          ScreenRoutes.editEducationListSection.route : (context) => const EditEducationSection(),
          ScreenRoutes.addExperienceListSection.route : (context) => const AddExperienceListSection(),
          ScreenRoutes.addEducationListSection.route : (context) => const AddEducationListSection(),
          ScreenRoutes.editProfile.route : (context) => const EditProfileSection(),
          ScreenRoutes.addOtherExperienceListSection.route : (context) => const AddOtherExperienceListSection(),
          ScreenRoutes.editOtherExperienceListSection.route : (context) => const EditOtherExperienceSection(),
          ScreenRoutes.postingDetailsWithoutApply.route : (context) => const PostingDetailsWithoutApply(),
          ScreenRoutes.reportProfile.route : (context) => const ReportUser(),
          ScreenRoutes.careerMaterials.route : (context) => const CareerMaterials(),
          ScreenRoutes.careerArticle.route : (context) => CareerArticle(),
          ScreenRoutes.feedbackList.route : (context) => const FeedbackList(),
          ScreenRoutes.createFeedback.route : (context) => const CreateFeedback(),
          ScreenRoutes.pickTimeSlot.route : (context) => const PickInterviewTimeSlot(),
          ScreenRoutes.notifications.route : (context) => const Notifications(),
          ScreenRoutes.reportFeedback.route : (context) => const ReportFeedback(),
        },
      ),
    );
  }
}
