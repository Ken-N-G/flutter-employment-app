import 'package:jobs_r_us_employer/features/job_postings/presentation/views/jobs.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/job_postings/presentation/widgets/jobAppBar.dart';
import 'package:jobs_r_us_employer/features/home/presentation/views/home.dart';
import 'package:jobs_r_us_employer/features/home/presentation/widgets/homeAppBar.dart';
import 'package:jobs_r_us_employer/features/interviews/presentation/views/interviews.dart';
import 'package:jobs_r_us_employer/features/interviews/presentation/widgets/interviewsAppBar.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/views/profile.dart';
import 'package:jobs_r_us_employer/features/profile/presentation/widgets/profileAppBar.dart';
import 'package:provider/provider.dart';



class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = 0;
  }

  Color? _setAppBarColor(int pageIndex) {
    switch(pageIndex) {
      case 0:
        return Theme.of(context).colorScheme.primary;
      case 1:
        return Theme.of(context).colorScheme.background;
      case 2:
        return Theme.of(context).colorScheme.background;
      case 3:
        return Theme.of(context).colorScheme.primary;
      default:
        return null;
    }
  }

  Color? _setBackgroundColor(int pageIndex) {
    switch(pageIndex) {
      case 0:
        return Theme.of(context).colorScheme.primary;
      case 1:
        return Theme.of(context).colorScheme.background;
      case 2:
        return Theme.of(context).colorScheme.background;
      case 3:
        return Theme.of(context).colorScheme.background;
      default:
        return null;
    }
  }

  Widget? _setAppBarContent(int pageIndex, NotificationsProvider notificationsProvider) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    switch(pageIndex) {
      case 0:
        return HomeAppBar(
          alias: profileProvider.userProfile?.name ?? "", 
          profileUrl: profileProvider.userProfile?.profileUrl ?? "",
          onProfileTap: () {
            setState(() {
              currentIndex = 3;
            });
          },
          onNotificationsTap: () {
            notificationsProvider.getNotifications();
            Navigator.pushNamed(context, ScreenRoutes.notifications.route);
          },
        );
      case 1:
        return const JobAppBar();
      case 2:
        return const InterviewsAppBar();
      case 3:
        return ProfileAppBar(
          onSettingsTap: () {
            Navigator.pushNamed(context, ScreenRoutes.options.route);
          },
        );
      default:
        return null;
    }
  }

  Widget? _setPage(int pageIndex) {
    switch(pageIndex) {
      case 0:
        return Home(
          onCompleteProfileTap: () {
            setState(() {
              currentIndex = 3;
            });
          },
        );
      case 1:
        return const Jobs();
      case 2:
        return const Interviews();
      case 3:
        return const Profile();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: currentIndex < 2 ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ScreenRoutes.createJob.route);
        },
        child: Icon(
          Icons.add_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ) : null,
      backgroundColor: _setBackgroundColor(currentIndex),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: MediaQuery.paddingOf(context).top),
          color: _setAppBarColor(currentIndex),
          child: _setAppBarContent(currentIndex, notificationsProvider),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.work_rounded),
            label: "Jobs"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_rounded),
            label: "Interviews"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile"
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w700
        ),
        unselectedItemColor: Theme.of(context).colorScheme.outline,
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.outline
        ),
      ),
      body: _setPage(currentIndex)
    );
  }
}