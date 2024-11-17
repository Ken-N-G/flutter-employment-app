import 'package:cloud_firestore/cloud_firestore.dart';

class EducationModel {
  EducationModel({
    required this.id,
    required this.institution,
    required this.lastHighestQualification,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  String id;
  String institution;
  String lastHighestQualification;
  String location;
  DateTime startDate;
  DateTime endDate;

  factory EducationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return EducationModel(
        id : data?['id'] ?? "",
        institution: data?['institution'] ?? "-",
        lastHighestQualification: data?['lastHighestQualification'] ?? "-",
        location: data?['location'] ?? "-",
        startDate: data?['startDate'].toDate() ?? Timestamp.now(),
        endDate: data?['startDate'].toDate() ?? Timestamp.now(),
      );
  }

  factory EducationModel.fromJson(Map<String, dynamic>? json) {
    return EducationModel(
      id : json?['id'] ?? "",
      institution: json?['institution'] ?? "-",
      lastHighestQualification: json?['lastHighestQualification'] ?? "-",
      location: json?['location'] ?? "-",
      startDate: json?['startDate'].toDate() ?? Timestamp.now(),
      endDate: json?['startDate'].toDate() ?? Timestamp.now(),
    );
  }

  EducationModel copyWith({
    String? id,
    String? institution,
    String? lastHighestQualification,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EducationModel(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      lastHighestQualification: lastHighestQualification ?? this.lastHighestQualification,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "institution" : institution,
    "lastHighestQualification" : lastHighestQualification,
    "location" : location,
    "startDate" : startDate,
    "endDate" : endDate,
  };
}