import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/notifications/model/notificationModel.dart';

enum NotificationStatus { processing, finished, failed, unloaded }
enum NotificationType {
  application("Application"),
  interview("Interview"),
  employer("Employer"),
  job("Job");
  final String type;
  const NotificationType(this.type);
}

class NotificationsProvider extends ChangeNotifier {
  AuthProvider? _authProvider;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; 

  List<NotificationModel> allNotificationsList = [];
  List<NotificationModel> todaysNotifications = [];
  List<NotificationModel> yesterdaysNotifications = [];
  List<NotificationModel> thisMonthsNotifcations = [];
  List<NotificationModel> pastNotifications = [];

  NotificationStatus notificationStatus = NotificationStatus.unloaded;

  FirebaseException? notificationError;


  void update(AuthProvider authProvider) {
    if (authProvider.currentUser != null) {
      _authProvider = authProvider;
      getNotifications();
    }
  }

  Future<bool> setNotifications(String message, NotificationType topic, String receiverId) async {
    notificationStatus = NotificationStatus.processing;
    notificationError = null;
    notifyListeners();
    try {
      final notification = NotificationModel(
        id: UniqueKey().toString(), 
        receiverId: topic != NotificationType.employer && topic != NotificationType.job ? receiverId : "followers", 
        senderId: _authProvider?.currentUser?.uid ?? "", 
        message: message, 
        notificationType: topic.type, 
        datePosted: DateTime.now()
      );
      await _firebaseFirestore.collection(Collections.notifications.name).doc(notification.id).withConverter(fromFirestore: NotificationModel.fromFirestore, toFirestore: (interviewModel, _) => interviewModel.toFirestore()).set(notification);
      notificationStatus = NotificationStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      notificationError = e;
      notificationStatus = NotificationStatus.failed;
      notifyListeners();
      return false;
    } 
  }

  Future<void> getNotifications() async {
    notificationStatus = NotificationStatus.processing;
    notificationError = null;
    notifyListeners();
    allNotificationsList = [];
    todaysNotifications = [];
    yesterdaysNotifications = [];
    thisMonthsNotifcations = [];
    pastNotifications = [];
    try {
      _firebaseFirestore.collection(Collections.notifications.name).withConverter(fromFirestore: NotificationModel.fromFirestore, toFirestore: (interviewModel, _) => interviewModel.toFirestore()).where("receiverId", isEqualTo: _authProvider!.currentUser!.uid).orderBy("datePosted", descending: true).get().then((collection) {
        allNotificationsList = collection.docs.map((e) => e.data()).toList();
        var now = DateTime.now();
        for (var notification in allNotificationsList) {
          var days = now.difference(notification.datePosted).inDays;
          if (days == 0) {
            todaysNotifications.add(notification);
          } else if (days == 1) {
            yesterdaysNotifications.add(notification);
          } else if (days < now.day) {
            thisMonthsNotifcations.add(notification);
          } else {
            pastNotifications.add(notification);

          }
        }
        notificationStatus = NotificationStatus.finished;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      notificationError = e;
      notificationStatus = NotificationStatus.failed;
      notifyListeners();
    } 
  }
}