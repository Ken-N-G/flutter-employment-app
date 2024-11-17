import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  FeedbackModel({
    required this.id,
    required this.solicitorId,
    required this.name,
    required this.profileUrl,
    required this.jobId,
    required this.feedback,
    required this.datePosted,
    required this.endorsedBy,
    required this.dislikedBy
  });

  String id;
  String solicitorId;
  String name;
  String profileUrl;
  String jobId;
  String feedback;
  DateTime datePosted;
  int endorsedBy;
  int dislikedBy;

  factory FeedbackModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return FeedbackModel(
        id : data?['id'] ?? "",
        solicitorId: data?['solicitorId'] ?? "",
        name: data?['name'] ?? "",
        profileUrl: data?['profileUrl'] ?? "",
        jobId: data?['jobId'] ?? "",
        feedback: data?['feedback'] ?? "",
        datePosted: data?['datePosted'].toDate() ?? Timestamp.now(),
        endorsedBy: data?['endorsedBy'] ?? 0,
        dislikedBy: data?['dislikedBy'] ?? 0,
      );
  }

  FeedbackModel copyWith({
    String? id,
    String? solicitorId,
    String? name,
    String? profileUrl,
    String? jobId,
    String? offence,
    DateTime? datePosted,
    String? feedback,
    String? description,
    int? endorsedBy,
    int? dislikedBy,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      solicitorId: solicitorId ?? this.solicitorId,
      feedback: feedback ?? this.feedback,
      name: name ?? this.name,
      profileUrl: profileUrl ?? this.profileUrl,
      jobId: offence ?? this.jobId,
      datePosted: datePosted ?? this.datePosted,
      endorsedBy: endorsedBy ?? this.endorsedBy,
      dislikedBy: dislikedBy ?? this.dislikedBy,
    );
  }

  Map<String, Object?> toFirestore() => {
    "id": id,
    "solicitorId": solicitorId,
    "feedback": feedback,
    "name": name,
    "profileUrl": profileUrl,
    "jobId": jobId,
    "datePosted": datePosted,
    "endorsedBy": endorsedBy,
    "dislikedBy": dislikedBy,
  };
}