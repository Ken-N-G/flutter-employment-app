import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  UserProfileModel({
    required this.name,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.businessAddress,
    required this.aboutUs,
    required this.visionMission,
    required this.profileUrl,
    required this.type,
    required this.hasVisitedProfilePage,
    required this.hasUploadedProfilePicture,
    required this.hasEditedAboutMe,
    required this.dateJoined,
  });

  String name;
  DateTime dateOfBirth; 
  String email;
  String phoneNumber;
  String businessAddress;
  String aboutUs;
  String visionMission;
  String profileUrl;
  String type;
  bool hasVisitedProfilePage;
  bool hasUploadedProfilePicture;
  bool hasEditedAboutMe;
  DateTime dateJoined;

  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return UserProfileModel(
          name: data?['name'] ?? "-",
          dateOfBirth: data?['dateOfBirth'].toDate() ?? Timestamp.now(),
          email: data?['email'] ?? "-",
          phoneNumber: data?['phoneNumber'] ?? "-",
          businessAddress: data?['businessAddress'] ?? "-",
          aboutUs: data?['aboutUs'] ?? "",
          visionMission: data?['visionMission'] ?? "",
          profileUrl: data?['profileUrl'] ?? "",
          type: data?['type'] ?? "",
          hasVisitedProfilePage: data?['hasVisitedProfilePage'] ?? false,
          hasUploadedProfilePicture: data?['hasUploadedProfilePicture'] ?? false,
          hasEditedAboutMe: data?['hasEditedAboutMe'] ?? false,
          dateJoined: data?['dateJoined'].toDate() ?? Timestamp.now(),
        );
    }

  UserProfileModel copyWith({
    String? name,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? businessAddress,
    String? aboutUs,
    String? visionMission,
    String? profileUrl,
    String? type,
    bool? hasVisitedProfilePage,
    bool? hasUploadedProfilePicture,
    bool? hasEditedAboutMe,
    List<String>? followedEmployers,
    DateTime? dateJoined
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessAddress: businessAddress ?? this.businessAddress,
      aboutUs: aboutUs ?? this.aboutUs,
      visionMission: visionMission ?? this.visionMission,
      profileUrl: profileUrl ?? this.profileUrl,
      type: type ?? this.type,
      hasVisitedProfilePage: hasVisitedProfilePage ?? this.hasVisitedProfilePage,
      hasUploadedProfilePicture: hasUploadedProfilePicture ?? this.hasUploadedProfilePicture,
      hasEditedAboutMe: hasEditedAboutMe ?? this.hasEditedAboutMe,
      dateJoined: dateJoined ?? this.dateJoined
    );
  }

  Map<String, Object?> toFirestore() => {
    "name" : name,
    "dateOfBirth" : dateOfBirth,
    "email" : email,
    "phoneNumber" : phoneNumber,
    "businessAddress" : businessAddress,
    "aboutUs" : aboutUs,
    "visionMission" : visionMission,
    "profileUrl" : profileUrl,
    "type" : type,
    "hasVisitedProfilePage" : hasVisitedProfilePage,
    "hasUploadedProfilePicture" : hasUploadedProfilePicture,
    "hasEditedAboutMe" : hasEditedAboutMe,
    "dateJoined" : dateJoined
  };
}