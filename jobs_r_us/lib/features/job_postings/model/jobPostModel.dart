import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostModel {
  JobPostModel({
    required this.id,
    required this.employerId,
    required this.title,
    required this.type,
    required this.tag,
    required this.location,
    required this.isOpen,
    required this.datePosted,
    required this.workingHours,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.employerName,
    required this.longitude,
    required this.latitude
  });

  String id;
  String employerId;
  String title;
  String type;
  String tag;
  String location;
  bool isOpen;
  DateTime datePosted;
  int workingHours;
  int salary;
  String description;
  String requirements;
  String employerName;
  double longitude;
  double latitude;

  factory JobPostModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return JobPostModel(
        id : data?['id'] ?? "",
        employerId: data?['employerId'] ?? "",
        title: data?['title'] ?? "",
        type: data?['type'] ?? "",
        tag: data?['tag'] ?? "",
        location: data?['location'] ?? "",
        isOpen: data?['isOpen'] ?? true,
        datePosted: data?['datePosted'].toDate() ?? Timestamp.now(),
        workingHours: data?['workingHours'] ?? 0,
        salary: data?['salary'] ?? 0,
        description: data?['description'] ?? "",
        requirements: data?['requirements'] ?? "",
        employerName: data?['employerName'] ?? "",
        longitude: data?['longitude'] ?? 0.0,
        latitude: data?['latitude'] ?? 0.0,

      );
  }

  JobPostModel copyWith({
    String? id,
    String? employerId,
    String? title,
    String? type,
    String? tag,
    String? location,
    bool? isOpen,
    DateTime? datePosted,
    int? workingHours,
    int? salary,
    String? description,
    String? requirements,
    String? employerName,
    double? longitude,
    double? latitude
  }) {
    return JobPostModel(
      id: id ?? this.id,
      employerId: employerId ?? this.employerId,
      title: title ?? this.title,
      type: type ?? this.type,
      tag: tag ?? this.tag,
      location: location ?? this.location,
      isOpen: isOpen ?? this.isOpen,
      datePosted: datePosted ?? this.datePosted,
      workingHours: workingHours ?? this.workingHours,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      employerName: employerName ?? this.employerName,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, Object?> toFirestore() => {
    "id": id,
    "employerId": employerId,
    "title": title,
    "type": type,
    "tag": tag,
    "location": location,
    "isOpen": isOpen,
    "datePosted": datePosted,
    "workingHours": workingHours,
    "salary": salary,
    "description": description,
    "requirements": requirements,
    "employerName": employerName,
    "longitude": longitude,
    "latitude": latitude
  };
}