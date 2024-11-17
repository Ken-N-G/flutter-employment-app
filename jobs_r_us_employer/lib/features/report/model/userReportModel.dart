import 'package:cloud_firestore/cloud_firestore.dart';

class UserReportModel {
  UserReportModel({
    required this.id,
    required this.offenderId,
    required this.reporterId,
    required this.offense,
    required this.description,
    required this.dateReported,
  });

  String id;
  String offenderId;
  String reporterId;
  String offense;
  String description;
  DateTime dateReported; 

  factory UserReportModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return UserReportModel(
        id: data?['id'] ?? "",
        offenderId: data?['offenderId'] ?? "",
        reporterId: data?['reporterId'] ?? "",
        offense: data?['offense'] ?? "",
        description: data?['description'] ?? "",
        dateReported: data?['dateReported'].toDate() ?? Timestamp.now(),
      );
    }

  UserReportModel copyWith({
    String? id,
    String? offenderId,
    String? reporterId,
    String? offense,
    String? description,
    DateTime? dateReported,
  
  }) {
    return UserReportModel(
      id: id ?? this.id,
      offenderId: offenderId ?? this.offenderId,
      reporterId: reporterId ?? this.reporterId,
      offense: offense ?? this.offense,
      description: description ?? this.description,
      dateReported: dateReported ?? this.dateReported,
    );
  }

  Map<String, dynamic> toFirestore() => {
    "id" : id,
    "offenderId" : offenderId,
    "reporterId" : reporterId,
    "offense" : offense,
    "description" : description,
    "dateReported" : dateReported,
  };
}