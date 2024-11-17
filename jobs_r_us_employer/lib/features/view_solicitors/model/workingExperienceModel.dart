import 'package:cloud_firestore/cloud_firestore.dart';

class WorkingExperienceModel {
  WorkingExperienceModel({
    required this.id,
    required this.positionHeld,
    required this.employer,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  String id;
  String positionHeld;
  String employer;
  String location;
  DateTime startDate;
  DateTime endDate;

  factory WorkingExperienceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options) {
      final data = snapshot.data();
      return WorkingExperienceModel(
        id: data?['id'] ?? "",
        positionHeld: data?['positionHeld'] ?? "-",
        employer: data?['employer'] ?? "-",
        location: data?['location'] ?? "-",
        startDate: data?['startDate'].toDate() ?? Timestamp.now(),
        endDate: data?['endDate'].toDate() ?? Timestamp.now(),
      );
  }

  factory WorkingExperienceModel.fromJson(Map<String, dynamic>? json) {
    return WorkingExperienceModel(
      id: json?['id'] ?? "",
      positionHeld: json?['positionHeld'] ?? "-",
      employer: json?['employer'] ?? "-",
      location: json?['location'] ?? "-",
      startDate: json?['startDate'].toDate() ?? Timestamp.now(),
      endDate: json?['endDate'].toDate() ?? Timestamp.now(),
    );
  }

  WorkingExperienceModel copyWith({
    String? id,
    String? positionHeld,
    String? employer,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return WorkingExperienceModel(
      id: id ?? this.id,
      positionHeld: positionHeld ?? this.positionHeld,
      employer: employer ?? this.employer,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "positionHeld" : positionHeld,
    "employer" : employer,
    "location" : location,
    "startDate" : startDate,
    "endDate" : endDate,
  };
}