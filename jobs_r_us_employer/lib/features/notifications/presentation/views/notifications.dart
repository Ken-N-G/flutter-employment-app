import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/notifications/domain/notificationProvider.dart';
import 'package:jobs_r_us_employer/features/notifications/model/notificationModel.dart';
import 'package:jobs_r_us_employer/features/notifications/presentation/widgets/notificationItem.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  List<Widget> setNotifications(BuildContext context, NotificationsProvider notificationsProvider) {
    if (notificationsProvider.allNotificationsList.isEmpty) {
      return [
        Center(
          child: Text(
            "You have not received a notification",
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodyMedium,
          ),
        )
      ];
    }

    List<Widget> entries = [];
    entries = setTodaysNotification(context, notificationsProvider.todaysNotifications);
    entries = entries + setYesterdaysNotification(context, notificationsProvider.yesterdaysNotifications);
    entries = entries + setMonthsNotification(context, notificationsProvider.thisMonthsNotifcations);
    entries = entries + setPastNotification(context, notificationsProvider.pastNotifications);
    return entries;
  } 

  List<Widget> setTodaysNotification(BuildContext context, List<NotificationModel> notifications) {
    List<Widget> entries = [];
    if (notifications.isEmpty) {
      return entries;
    } 
    entries.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 30),
        child: Text(
            "Today",
            style: Theme.of(context).textTheme.titleLarge,
          ),
      ),
    );

    for (var notification in notifications) {
      entries.add(NotificationItem(
        icon: setIcon(notification.notificationType),
        message: notification.message,
        datePosted: notification.datePosted,
      ));
    }
    entries.add(const SizedBox(height: 30,));
    return entries;
  }

  List<Widget> setYesterdaysNotification(BuildContext context, List<NotificationModel> notifications) {
    List<Widget> entries = [];
    if (notifications.isEmpty) {
      return entries;
    } 
    entries.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 30),
        child: Text(
            "Yesterday",
            style: Theme.of(context).textTheme.titleLarge,
          ),
      ),
    );

    for (var notification in notifications) {
      entries.add(NotificationItem(
        icon: setIcon(notification.notificationType),
        message: notification.message,
        datePosted: notification.datePosted,
      ));
    }
    entries.add(const SizedBox(height: 30,));
    return entries;
  }

  List<Widget> setMonthsNotification(BuildContext context, List<NotificationModel> notifications) {
    List<Widget> entries = [];
    if (notifications.isEmpty) {
      return entries;
    } 
    entries.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 30),
        child: Text(
            "This Month",
            style: Theme.of(context).textTheme.titleLarge,
          ),
      ),
    );

    for (var notification in notifications) {
      entries.add(NotificationItem(
        icon: setIcon(notification.notificationType),
        message: notification.message,
        datePosted: notification.datePosted,
      ));
    }
    entries.add(const SizedBox(height: 30,));
    return entries;
  }

  List<Widget> setPastNotification(BuildContext context, List<NotificationModel> notifications) {
    List<Widget> entries = [];
    if (notifications.isEmpty) {
      return entries;
    } 
    entries.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 30),
        child: Text(
            "Past Notifications",
            style: Theme.of(context).textTheme.titleLarge,
          ),
      ),
    );

    for (var notification in notifications) {
      entries.add(NotificationItem(
        icon: setIcon(notification.notificationType),
        message: notification.message,
        datePosted: notification.datePosted,
      ));
    }
    entries.add(const SizedBox(height: 30,));
    return entries;
  }

  IconData setIcon(String type) {
    switch (type) {
      case "Application":
        return Icons.description_rounded;
      case "Interview":
        return Icons.date_range_rounded;
      case "Job":
        return Icons.work_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Notifications",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: setNotifications(context, notificationsProvider)
                ),
              ),
            ),
          ),
        ),

        notificationsProvider.notificationStatus == NotificationStatus.processing ?
              const CustomLoadingOverlay(enableDarkBackground: true,) :
              Container()
      ],
    );
  }
}
