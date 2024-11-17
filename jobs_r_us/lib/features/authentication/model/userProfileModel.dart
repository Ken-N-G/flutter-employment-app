import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  UserProfileModel({
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.placeOfResidence,
    required this.aboutMe,
    required this.resumeUrl,
    required this.profileUrl,
    required this.subscribedTag,
    required this.hasVisitedProfilePage,
    required this.hasUploadedProfilePicture,
    required this.hasEditedAboutMe,
    required this.followedEmployers
  });

  String fullName;
  DateTime dateOfBirth; 
  String email;
  String phoneNumber;
  String placeOfResidence;
  String aboutMe;
  String resumeUrl;
  String profileUrl;
  String subscribedTag;
  bool hasVisitedProfilePage;
  bool hasUploadedProfilePicture;
  bool hasEditedAboutMe;
  List<String> followedEmployers;

  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return UserProfileModel(
          fullName: data?['fullName'] ?? "-",
          dateOfBirth: data?['dateOfBirth'].toDate() ?? Timestamp.now(),
          email: data?['email'] ?? "-",
          phoneNumber: data?['phoneNumber'] ?? "-",
          placeOfResidence: data?['placeOfResidence'] ?? "-",
          aboutMe: data?['aboutMe'] ?? "",
          resumeUrl: data?['resumeUrl'] ?? "",
          profileUrl: data?['profileUrl'] ?? "",
          subscribedTag: data?['subscribedTag'] ?? "",
          hasVisitedProfilePage: data?['hasVisitedProfilePage'] ?? false,
          hasUploadedProfilePicture: data?['hasUploadedProfilePicture'] ?? false,
          hasEditedAboutMe: data?['hasEditedAboutMe'] ?? false,
          followedEmployers: data?['followedEmployers'] is Iterable ? List.from(data?['followedEmployers']) : [],
        );
    }

  UserProfileModel copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? placeOfResidence,
    String? aboutMe,
    String? resumeUrl,
    String? profileUrl,
    String? subscribedTag,
    bool? hasVisitedProfilePage,
    bool? hasUploadedProfilePicture,
    bool? hasEditedAboutMe,
    List<String>? followedEmployers
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      placeOfResidence: placeOfResidence ?? this.placeOfResidence,
      aboutMe: aboutMe ?? this.aboutMe,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
      subscribedTag: subscribedTag ?? this.subscribedTag,
      hasVisitedProfilePage: hasVisitedProfilePage ?? this.hasVisitedProfilePage,
      hasUploadedProfilePicture: hasUploadedProfilePicture ?? this.hasUploadedProfilePicture,
      hasEditedAboutMe: hasEditedAboutMe ?? this.hasEditedAboutMe,
      followedEmployers: followedEmployers ?? this.followedEmployers,
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
    "subscribedTag" : subscribedTag,
    "hasVisitedProfilePage" : hasVisitedProfilePage,
    "hasUploadedProfilePicture" : hasUploadedProfilePicture,
    "hasEditedAboutMe" : hasEditedAboutMe,
    "followedEmployers" : followedEmployers
  };
}