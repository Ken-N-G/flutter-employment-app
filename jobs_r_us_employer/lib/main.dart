import 'package:jobs_r_us_employer/features/applications/presentation/views/applications.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/views/resumePreviewPage.dart';
import 'package:jobs_r_us_employer/features/interviews/presentation/views/createInterview.dart';
import 'package:jobs_r_us_employer/features/job_postings/presentation/views/createJob.dart';
import 'package:jobs_r_us_employer/features/notifications/presentation/views/notifications.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/views/editAboutUsSection.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/views/editProfileSection.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/views/editVisionAndMissionSection.dart';
import 'package:jobs_r_us_employer/features/report/presentation/views/reportAccount.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/presentation/views/solicitorDetails.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobs_r_us_employer/features/feedback/domain/feedbackProvider.dart';
import 'package:jobs_r_us_employer/features/feedback/presentation/views/feedbackList.dart';
import 'package:jobs_r_us_employer/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us_employer/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/features/report/domain/reportProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/domain/solicitorProvider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/core/theme/theme.dart';
import 'package:jobs_r_us_employer/features/applications/presentation/views/applicationDetails.dart';
import 'package:jobs_r_us_employer/features/authentication/presentation/views/signIn.dart';
import 'package:jobs_r_us_employer/features/interviews/presentation/views/interviewDetails.dart';
import 'package:jobs_r_us_employer/features/job_postings/presentation/views/postingDetails.dart';
import 'package:jobs_r_us_employer/features/navigationWrapper.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/views/options.dart';
import 'package:jobs_r_us_employer/features/authentication/presentation/views/register.dart';
import 'package:jobs_r_us_employer/features/report/presentation/views/reportFeedback.dart';


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
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
        ChangeNotifierProxyProvider<AuthProvider, JobProvider>(
          create: (context) => JobProvider(), 
          update: (context, auth, previousJobProvider) => previousJobProvider!..update(auth),
        ),
        ChangeNotifierProvider(create: (_) => SolicitorProvider()),
        ChangeNotifierProxyProvider<AuthProvider, InterviewProvider>(
          create: (context) => InterviewProvider(), 
          update: (context, auth, previousInterviewProvider) => previousInterviewProvider!..update(auth),
        ),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProxyProvider<AuthProvider, NotificationsProvider>(
          create: (context) => NotificationsProvider(), 
          update: (context, auth, previousNotificationsProvider) => previousNotificationsProvider!..update(auth),
        ),
        
      ],
      child: MaterialApp(
        title: 'Jobs R Us',
        theme: primaryTheme,
        initialRoute: ScreenRoutes.signIn.route,
        routes: {
          ScreenRoutes.signIn.route : (context) => const SignIn(),
          ScreenRoutes.register.route : (context) => const Register(),
          ScreenRoutes.main.route : (context) => const NavigationWrapper(),
          ScreenRoutes.postingDetails.route : (context) => const PostingDetails(),
          ScreenRoutes.solicitorDetails.route : (context) => const SolicitorDetails(),
          ScreenRoutes.applicationDetails.route : (context) => const ApplicationDetails(),
          ScreenRoutes.interviewDetails.route : (context) => const InterviewDetails(),
          ScreenRoutes.options.route : (context) => const Options(),
          ScreenRoutes.reportFeedback.route : (context) => const ReportFeedback(),
          ScreenRoutes.reportProfile.route : (context) => const ReportUser(),
          ScreenRoutes.feedbackList.route : (context) => const FeedbackList(),
          ScreenRoutes.editVisionAndMissionSection.route : (context) => const EditVisionAndMissionSection(),
          ScreenRoutes.createJob.route : (context) => const CreateJob(),
          ScreenRoutes.applications.route : (context) => const Applications(),
          ScreenRoutes.createInterview.route : (context) => const CreateInterview(),
          ScreenRoutes.editProfile.route : (context) => const EditProfileSection(),
          ScreenRoutes.editProfileTextSection.route : (context) => const EditAboutUsSection(),
          ScreenRoutes.notifications.route : (context) => const Notifications(),
          ScreenRoutes.resumePreview.route : (context) => const ResumePreview()
        },
      ),
    );
  }
}
