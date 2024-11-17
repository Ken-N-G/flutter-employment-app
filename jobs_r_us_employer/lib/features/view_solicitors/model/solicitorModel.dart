import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitorModel {
  SolicitorModel({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.placeOfResidence,
    required this.aboutMe,
    required this.resumeUrl,
    required this.profileUrl,
  });

  String id;  
  String fullName;
  DateTime dateOfBirth; 
  String email;
  String phoneNumber;
  String placeOfResidence;
  String aboutMe;
  String resumeUrl;
  String profileUrl;

  factory SolicitorModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return SolicitorModel(
        id: snapshot.id,
        fullName: data?['fullName'] ?? "-",
        dateOfBirth: data?['dateOfBirth'].toDate() ?? Timestamp.now(),
        email: data?['email'] ?? "-",
        phoneNumber: data?['phoneNumber'] ?? "-",
        placeOfResidence: data?['placeOfResidence'] ?? "-",
        aboutMe: data?['aboutMe'] ?? "",
        resumeUrl: data?['resumeUrl'] ?? "",
        profileUrl: data?['profileUrl'] ?? "",
      );
    }

  SolicitorModel copyWith({
    String? id,
    String? fullName,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? placeOfResidence,
    String? aboutMe,
    String? resumeUrl,
    String? profileUrl,
  }) {
    return SolicitorModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      placeOfResidence: placeOfResidence ?? this.placeOfResidence,
      aboutMe: aboutMe ?? this.aboutMe,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }

  Map<String, Object?> toFirestore() => {
    "fullName" : fullName,
    "dateOfBirth" : dateOfBirth,
    "email" : email,
    "phoneNumber" : phoneNumber,
    "placeOfResidence" : placeOfResidence,
    "aboutMe" : aboutMe,
    "resumeUrl" : resumeUrl,
    "profileUrl" : profileUrl,
  };
}