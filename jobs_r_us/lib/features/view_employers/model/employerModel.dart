import 'package:cloud_firestore/cloud_firestore.dart';

class EmployerModel {
  EmployerModel({
    required this.id,
    required this.name,
    required this.dateJoined,
    required this.email,
    required this.phoneNumber,
    required this.businessAddress,
    required this.type,
    required this.profileUrl,
    required this.aboutUs,
    required this.visionMission,
  });

  String id;
  String name;
  DateTime dateJoined; 
  String email;
  String phoneNumber;
  String businessAddress;
  String type;
  String profileUrl;
  String aboutUs;
  String visionMission;

  factory EmployerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return EmployerModel(
          id: snapshot.id,
          name: data?['name'] ?? "-",
          dateJoined: data?['dateJoined'].toDate() ?? Timestamp.now(),
          email: data?['email'] ?? "-",
          phoneNumber: data?['phoneNumber'] ?? "-",
          businessAddress: data?['businessAddress'] ?? "-",
          type: data?['type'] ?? "",
          profileUrl: data?['profileUrl'] ?? "",
          aboutUs: data?['aboutUs'] ?? "",
          visionMission: data?['visionMission'] ?? "",
        );
    }

  EmployerModel copyWith({
    String? id,
    String? name,
    DateTime? dateJoined,
    String? email,
    String? phoneNumber,
    String? businessAddress,
    String? type,
    String? profileUrl,
    String? aboutUs,
    String? visionMission,
  }) {
    return EmployerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateJoined: dateJoined ?? this.dateJoined,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessAddress: businessAddress ?? this.businessAddress,
      type: type ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      aboutUs: aboutUs ?? this.aboutUs,
      visionMission: visionMission ?? this.visionMission,
    );
  }

  Map<String, dynamic> toFirestore() => {
    "id" : id,
    "name" : name,
    "dateJoined" : dateJoined,
    "email" : email,
    "phoneNumber" : phoneNumber,
    "businessAddress" : businessAddress,
    "type" : type,
    "profileUrl" : profileUrl,
    "aboutUs" : aboutUs,
    "visionMission" : visionMission,
  };
}