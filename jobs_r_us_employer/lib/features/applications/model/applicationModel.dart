import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/educationModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/eventExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/workingExperienceModel.dart';

class ApplicationModel {
  ApplicationModel({
    required this.id,
    required this.solicitorId,
    required this.jobId,
    required this.employerId,
    required this.jobTitle,
    required this.employerName,
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.placeOfResidence,
    required this.resumeUrl,
    required this.dateApplied,
    required this.dateUpdated,
    required this.status,
  });

  String id;
  String solicitorId;
  String jobId;
  String employerId;
  String jobTitle;
  String employerName;
  String fullName;
  DateTime dateOfBirth; 
  String email;
  String phoneNumber;
  String placeOfResidence;
  String resumeUrl;
  DateTime dateApplied;
  DateTime dateUpdated;
  String status;


  factory ApplicationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return ApplicationModel(
        id: data?['id'] ?? "",
        solicitorId: data?['solicitorId'] ?? "",
        jobId: data?['jobId'] ?? "",
        employerId: data?['employerId'] ?? "",
        jobTitle: data?['jobTitle'] ?? "",
        employerName: data?['employerName'] ?? "",
        fullName: data?['fullName'] ?? "",
        dateOfBirth: data?['dateOfBirth'].toDate() ?? Timestamp.now(),
        email: data?['email'] ?? "",
        phoneNumber: data?['phoneNumber'] ?? "",
        placeOfResidence: data?['placeOfResidence'] ?? "",
        resumeUrl: data?['resumeUrl'] ?? "",
        dateApplied: data?['dateApplied'].toDate() ?? Timestamp.now(),
        dateUpdated: data?['dateUpdated'].toDate() ?? Timestamp.now(),
        status: data?['status'] ?? "",
      );
    }

  ApplicationModel copyWith({
    String? id,
    String? solicitorId,
    String? jobId,
    String? employerId,
    String? jobTitle,
    String? employerName,
    String? fullName,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? placeOfResidence,
    String? resumeUrl,
    DateTime? dateApplied,
    DateTime? dateUpdated,
    String? status, 
    List<WorkingExperienceModel>? workingExperiences,
    List<EventExperienceModel>? eventExperiences,
    List<EducationModel>? education
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      solicitorId: solicitorId ?? this.solicitorId,
      jobId: jobId ?? this.jobId,
      employerId: employerId ?? this.employerId,
      jobTitle: jobTitle ?? this.jobTitle,
      employerName: employerName ?? this.employerName,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      placeOfResidence: placeOfResidence ?? this.placeOfResidence,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      dateApplied: dateApplied ?? this.dateApplied,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      status: status ?? this.status
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "solicitorId" : solicitorId,
    "jobId" : jobId,
    "employerId" : employerId,
    "jobTitle" : jobTitle,
    "employerName": employerName,
    "fullName" : fullName,
    "dateOfBirth" : dateOfBirth,
    "email" : email,
    "phoneNumber" : phoneNumber,
    "placeOfResidence" : placeOfResidence,
    "resumeUrl" : resumeUrl,
    "dateApplied" : dateApplied,
    "dateUpdated" : dateUpdated,
    "status" : status,
  };
}