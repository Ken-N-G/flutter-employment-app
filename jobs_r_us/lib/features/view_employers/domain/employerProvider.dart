import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/view_employers/model/employerModel.dart';

enum EmployerStatus { retrieving, failed, unloaded, loaded }
enum FollowStatus { processing, failed, unloaded, finish }
enum EmployerSearchOrder { name, dateJoined }
enum EmployerType { all, micro, small, medium }

class EmployerProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<EmployerModel> allEmployerList = [];
  List<EmployerModel> searchedEmployerList = [];

  EmployerStatus employerStatus = EmployerStatus.unloaded;
  EmployerStatus searchStatus = EmployerStatus.unloaded;
  FollowStatus followStatus = FollowStatus.unloaded;

  FirebaseException? employerError;
  FirebaseException? searchError;
  FirebaseException? followError;

  EmployerModel selectedEmployer = EmployerModel(
    id: "", 
    name: "", 
    dateJoined: DateTime.now(),
    email: "", 
    phoneNumber: "", 
    businessAddress: "", 
    type: "", 
    profileUrl: "", 
    aboutUs: "", 
    visionMission: "",
  );

  bool isFollowed = false;

  EmployerProvider() {
    getAllEmployers();
  }

  Future<void> getAllEmployers() async {
    employerStatus = EmployerStatus.retrieving;
    employerError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.employers.name).orderBy("dateJoined", descending: true).withConverter(fromFirestore: EmployerModel.fromFirestore, toFirestore: (employerModel, _) => employerModel.toFirestore()).get().then((collection) {
        allEmployerList = collection.docs.map((e) => e.data()).toList();
        employerStatus = EmployerStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      employerError = e;
      employerStatus = EmployerStatus.failed;
    } 
  }

  Future<void> getEmployersWithQuery(String searchKey, EmployerSearchOrder orderBy, EmployerType type, bool? descending) async {
    searchStatus = EmployerStatus.retrieving;
    searchError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.employers.name).withConverter(fromFirestore: EmployerModel.fromFirestore, toFirestore: (employerModel, _) => employerModel.toFirestore()).orderBy(orderBy.name, descending: descending ?? true).get().then((collection) {
        if (searchKey.isEmpty && type == EmployerType.all) {
          allEmployerList = collection.docs.map((e) => e.data()).toList();
          resetSearch();
          notifyListeners();
        } else {
          var employers = collection.docs.map((e) => e.data()).toList();
          searchedEmployerList = employers.where((employer) => employer.name.toLowerCase().contains(searchKey.toLowerCase()) && employer.type.toLowerCase().contains(type.name.toLowerCase())).toList();
          searchStatus = EmployerStatus.loaded;
          notifyListeners();
        }
      });
    } on FirebaseException catch (e) {
      searchError = e;
      searchStatus = EmployerStatus.failed;
      notifyListeners();
    } 
  }

  void resetSearch() {
    searchedEmployerList = [];
    searchStatus = EmployerStatus.unloaded;
    notifyListeners();
  }

  Future<void> setSelectedEmployer(String employerId, String solicitorId) async {
    selectedEmployer = allEmployerList.where((element) => element.id == employerId).first;
    followStatus = FollowStatus.processing;
    followError = null;
    try {
      _firebaseFirestore.collection(Collections.employers.name).doc(employerId).collection(Collections.followers.name).doc(solicitorId).get().then((value) {
        isFollowed = value.exists;
        followStatus = FollowStatus.finish;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      followStatus = FollowStatus.failed;
      followError = e;
      notifyListeners();
    }
  }

  void setFollow(String solicitorId) async {
    followStatus = FollowStatus.processing;
    followError = null;
    notifyListeners();
    try {
      if (!isFollowed) {
        await _firebaseFirestore.collection(Collections.employers.name).doc(selectedEmployer.id).collection(Collections.followers.name).doc(solicitorId).set(
          {
            "dateFollowed" : DateTime.now(),
            "solicitorId" : solicitorId
          }
        );
        isFollowed = true;
      } else {
        await _firebaseFirestore.collection(Collections.employers.name).doc(selectedEmployer.id).collection(Collections.followers.name).doc(solicitorId).delete();
        isFollowed = false;
      }
      followStatus = FollowStatus.finish;
      notifyListeners();
    } on FirebaseException catch (e) {
      followError = e;
      followStatus = FollowStatus.failed;
      notifyListeners();
    } 
  }
}