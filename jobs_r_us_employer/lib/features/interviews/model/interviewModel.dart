import 'package:cloud_firestore/cloud_firestore.dart';

class InterviewModel {
  InterviewModel({
    required this.id,
    required this.solicitorId,
    required this.employerId,
    required this.jobId,
    required this.interviewMethod,
    required this.link,
    required this.additionalPreparations,
    required this.selectedDate,
    required this.lastUpdatedDate,
    required this.status,
    required this.availableDates,
    required this.employerName,
    required this.solicitorName,
    required this.jobTitle
  });

  String id;
  String solicitorId;
  String employerId;
  String jobId;
  String interviewMethod;
  String link;
  String additionalPreparations;
  DateTime selectedDate;
  DateTime lastUpdatedDate;
  String status;
  List<DateTime> availableDates;
  String employerName;
  String solicitorName;
  String jobTitle;

  factory InterviewModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      List<DateTime> dates = [];
      if (data?['availableDates'] is Iterable) {
        List<Timestamp> timestamps = List.from(data?['availableDates']);
        dates = timestamps.map((e) => e.toDate()).toList();
      }
      return InterviewModel(
        id : data?['id'] ?? "",
        solicitorId: data?['solicitorId'] ?? "",
        employerId: data?['employerId'] ?? "",
        jobId: data?['jobId'] ?? "",
        interviewMethod: data?['interviewMethod'] ?? "",
        link: data?['link'] ?? "",
        additionalPreparations: data?['additionalPreparations'] ?? "",
        selectedDate: data?['selectedDate'].toDate() ?? DateTime.now(),
        lastUpdatedDate: data?['lastUpdatedDate'].toDate() ?? DateTime.now(),
        status: data?['status'] ?? "",
        availableDates: dates,
        employerName: data?['employerName'] ?? "",
        solicitorName: data?['solicitorName'] ?? "",
        jobTitle: data?['jobTitle'] ?? ""
      );
  }

  InterviewModel copyWith({
    String? id,
    String? solicitorId,
    String? employerId,
    String? jobId,
    String? interviewMethod,
    String? link,
    String? additionalPreparations,
    DateTime? selectedDate,
    DateTime? lastUpdatedDate,
    String? status,
    List<DateTime>? availableDates,
    String? employerName,
    String? solicitorName,
    String? jobTitle,
  }) {
    return InterviewModel(
      id: id ?? this.id,
      solicitorId: solicitorId ?? this.solicitorId,
      employerId: employerId ?? this.employerId,
      jobId: jobId ?? this.jobId,
      interviewMethod: interviewMethod ?? this.interviewMethod,
      link: link ?? this.link,
      additionalPreparations: additionalPreparations ?? this.additionalPreparations,
      selectedDate: selectedDate ?? this.selectedDate,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      status: status ?? this.status,
      availableDates: availableDates ?? this.availableDates,
      employerName: employerName ?? this.employerName,
      solicitorName: solicitorName ?? this.solicitorName,
      jobTitle: jobTitle ?? this.jobTitle
    );
  }

  Map<String, Object?> toFirestore() => {
    "id": id,
    "solicitorId": solicitorId,
    "employerId" : employerId,
    "jobId": jobId,
    "interviewMethod": interviewMethod,
    "link": link,
    "additionalPreparations": additionalPreparations,
    "selectedDate": selectedDate,
    "lastUpdatedDate": lastUpdatedDate,
    "status": status,
    "availableDates": availableDates,
    "employerName": employerName,
    "solicitorName": solicitorName,
    "jobTitle": jobTitle
  };
}