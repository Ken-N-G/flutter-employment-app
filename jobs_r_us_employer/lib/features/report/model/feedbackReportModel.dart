import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackReportModel {
  FeedbackReportModel({
    required this.id,
    required this.feedbackId,
    required this.reporterId,
    required this.offense,
    required this.description,
    required this.dateReported,
  });

  String id;
  String feedbackId;
  String reporterId;
  String offense;
  String description;
  DateTime dateReported; 

  factory FeedbackReportModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return FeedbackReportModel(
        id: data?['id'] ?? "",
        feedbackId: data?['feedbackId'] ?? "",
        reporterId: data?['reporterId'] ?? "",
        offense: data?['offense'] ?? "",
        description: data?['description'] ?? "",
        dateReported: data?['dateReported'].toDate() ?? Timestamp.now(),
      );
    }

  FeedbackReportModel copyWith({
    String? id,
    String? feedbackId,
    String? reporterId,
    String? offense,
    String? description,
    DateTime? dateReported,
  
  }) {
    return FeedbackReportModel(
      id: id ?? this.id,
      feedbackId: feedbackId ?? this.feedbackId,
      reporterId: reporterId ?? this.reporterId,
      offense: offense ?? this.offense,
      description: description ?? this.description,
      dateReported: dateReported ?? this.dateReported,
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "feedbackId" : feedbackId,
    "reporterId" : reporterId,
    "offense" : offense,
    "description" : description,
    "dateReported" : dateReported,
  };
}