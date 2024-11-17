import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/educationModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/eventExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/workingExperienceModel.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/solicitorModel.dart';

enum SolicitorStatus { retrieving, failed, unloaded, loaded, uploading, finished}
enum SolicitorDataStatus { processing, finished, failed, unloaded }

class SolicitorProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<SolicitorModel> allSolictorsList = [];

  List<WorkingExperienceModel> workingExperiences = [];

  List<EventExperienceModel> eventExperiences = [];

  List<EducationModel> educationList = [];

  SolicitorStatus solicitorStatus = SolicitorStatus.unloaded;

  SolicitorDataStatus workingExperienceStatus = SolicitorDataStatus.unloaded;

  SolicitorDataStatus eventExperienceStatus = SolicitorDataStatus.unloaded;

  SolicitorDataStatus educationStatus = SolicitorDataStatus.unloaded;

  FirebaseException? solicitorError;

  FirebaseException? workingError;

  FirebaseException? eventError;

  FirebaseException? educationError;

  SolicitorModel selectedSolicitor = SolicitorModel(
    id: "", 
    fullName: "", 
    dateOfBirth: DateTime.now(),
    email: "", 
    phoneNumber: "", 
    placeOfResidence: "", 
    profileUrl: "", 
    aboutMe: "", 
    resumeUrl: "",
  );

   Future<void> getWorkingExperiences() async {
    workingError = null;
    workingExperienceStatus = SolicitorDataStatus.processing;
    notifyListeners();
    try {
        _firebaseFirestore.collection(Collections.solicitors.name).doc(selectedSolicitor.id).collection(Collections.workingExperiences.name).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (WorkingExperienceModel experience, _) => experience.toFirestore()).get().then((snapshot) {
          final docs = snapshot.docs;
          workingExperiences = docs.map((e) => e.data()).toList();
          workingExperienceStatus = SolicitorDataStatus.finished;
          notifyListeners();
        }).onError((error, stackTrace) {
          workingError = error as FirebaseException;
          workingExperienceStatus = SolicitorDataStatus.failed;
          notifyListeners();
        });
    } on FirebaseException catch (e) {
      workingError = e;
      workingExperienceStatus = SolicitorDataStatus.failed;
      notifyListeners();
    }
  }

  Future<void> getEventExperiences() async {
    eventError = null;
    eventExperienceStatus = SolicitorDataStatus.processing;
    notifyListeners();
    try {
        _firebaseFirestore.collection(Collections.solicitors.name).doc(selectedSolicitor.id).collection(Collections.otherExperiences.name).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel experience, _) => experience.toFirestore()).get().then((snapshot) {
          final docs = snapshot.docs;
          eventExperiences = docs.map((e) => e.data()).toList();
          eventExperienceStatus = SolicitorDataStatus.finished;
          notifyListeners();
        }).onError((error, stackTrace) {
          eventError = error as FirebaseException;
          eventExperienceStatus = SolicitorDataStatus.failed;
          notifyListeners();
        });
    } on FirebaseException catch (e) {
      eventError = e;
      eventExperienceStatus = SolicitorDataStatus.failed;
      notifyListeners();
    }
  }

  Future<void> getEducation() async {
    educationError = null;
    educationStatus = SolicitorDataStatus.processing;
    notifyListeners();
    try {
        _firebaseFirestore.collection(Collections.solicitors.name).doc(selectedSolicitor.id).collection(Collections.education.name).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel education, _) => education.toFirestore()).get().then((snapshot) {
          final docs = snapshot.docs;
          educationList = docs.map((e) => e.data()).toList();
          educationStatus = SolicitorDataStatus.finished;
          notifyListeners();
        }).onError((error, stackTrace) {
          educationError = error as FirebaseException;
          educationStatus = SolicitorDataStatus.failed;
          notifyListeners();
        });
    } on FirebaseException catch (e) {
      educationError = e;
      educationStatus = SolicitorDataStatus.failed;
      notifyListeners();
    }
  }

  Future<void> getAllSolicitors() async {
    solicitorStatus = SolicitorStatus.retrieving;
    solicitorError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.solicitors.name).withConverter(fromFirestore: SolicitorModel.fromFirestore, toFirestore: (solicitor, _) => solicitor.toFirestore()).get().then((collection) {
        allSolictorsList = collection.docs.map((e) => e.data()).toList();
        solicitorStatus = SolicitorStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      solicitorError = e;
      solicitorStatus = SolicitorStatus.failed;
    } 
  }

  Future<void> setSelectedSolicitor(String id) async {
    selectedSolicitor = allSolictorsList.where((element) => element.id == id).first;
    notifyListeners();
  }

  void updateListeners() async {
    notifyListeners();
  }
}