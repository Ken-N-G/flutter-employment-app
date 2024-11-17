import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.message,
    required this.notificationType,
    required this.datePosted,
  });

  String id;
  String receiverId;
  String senderId ;
  String message;
  String notificationType;
  DateTime datePosted; 


  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return NotificationModel(
        id: data?['id'] ?? "",
        receiverId: data?['receiverId'] ?? "",
        senderId: data?['senderId'] ?? "",
        message: data?['message'] ?? "",
        notificationType: data?['notificationType'] ?? "",
        datePosted: data?['datePosted'].toDate() ?? Timestamp.now(),

      );
    }

  NotificationModel copyWith({
    String? id,
    String? receiverId,
    String? senderId,
    String? message,
    String? notificationType,
    DateTime? datePosted,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      datePosted: datePosted ?? this.datePosted,
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "receiverId" : receiverId,
    "senderId" : senderId,
    "message" : message,
    "notificationType" : notificationType,
    "datePosted" : datePosted,
  };
}