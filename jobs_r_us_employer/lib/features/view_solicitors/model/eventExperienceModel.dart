import 'package:cloud_firestore/cloud_firestore.dart';

class EventExperienceModel {
  EventExperienceModel({
    required this.id,
    required this.positionHeld,
    required this.event,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  String id;
  String positionHeld;
  String event;
  String location;
  DateTime startDate;
  DateTime endDate;

  factory EventExperienceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options) {
      final data = snapshot.data();
      return EventExperienceModel(
        id: data?['id'] ?? "",
        positionHeld: data?['positionHeld'] ?? "-",
        event: data?['event'] ?? "-",
        location: data?['location'] ?? "-",
        startDate: data?['startDate'].toDate() ?? Timestamp.now(),
        endDate: data?['endDate'].toDate() ?? Timestamp.now(),
      );
  }

  factory EventExperienceModel.fromJson(Map<String, dynamic>? json) {
      return EventExperienceModel(
        id: json?['id'] ?? "",
        positionHeld: json?['positionHeld'] ?? "-",
        event: json?['event'] ?? "-",
        location: json?['location'] ?? "-",
        startDate: json?['startDate'].toDate() ?? Timestamp.now(),
        endDate: json?['endDate'].toDate() ?? Timestamp.now(),
      );
  }


  EventExperienceModel copyWith({
    String? id,
    String? positionHeld,
    String? event,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EventExperienceModel(
      id: id ?? this.id,
      positionHeld: positionHeld ?? this.positionHeld,
      event: event ?? this.event,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "positionHeld" : positionHeld,
    "event" : event,
    "location" : location,
    "startDate" : startDate,
    "endDate" : endDate,
  };
}