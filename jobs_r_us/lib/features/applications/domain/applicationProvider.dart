import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/applications/model/applicationModel.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/features/profile/model/educationModel.dart';
import 'package:jobs_r_us/features/profile/model/eventExperienceModel.dart';
import 'package:jobs_r_us/features/profile/model/workingExperienceModel.dart';

enum ApplyStatus { retrieving, failed, uploading, unloaded, loaded, finished }
enum ApplicationStatus {
  all("", Colors.transparent),
  submitted("Submitted", Colors.indigo),
  pendingInterview("Awaiting Interview", Color.fromARGB(255, 206, 110, 0)),
  pendingReview("Pending Review", Color.fromARGB(255, 141, 97, 81)),
  approved("Approved", Colors.green),
  accepted("Accepted", Colors.green),
  rejected("Rejected", Color.fromARGB(255, 190, 31, 19)),
  denied("Denied", Color.fromARGB(255, 190, 31, 19)),
  archived("Archived", Color.fromARGB(255, 94, 94, 94));
  final String status;
  final Color color;
  const ApplicationStatus(this.status, this.color);
}

class ApplicationProvider with ChangeNotifier {
  AuthProvider? _authProvider;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<ApplicationModel> allApplicationsList = [];
  List<ApplicationModel> searchedApplicationsList = [];

  ApplyStatus applyStatus = ApplyStatus.unloaded;
  ApplyStatus retrieveApplyStatus = ApplyStatus.unloaded;
  ApplyStatus searchStatus = ApplyStatus.unloaded;

  DataStatus workingExperienceStatus = DataStatus.unloaded;

  DataStatus eventExperienceStatus = DataStatus.unloaded;

  DataStatus educationStatus = DataStatus.unloaded;

  FirebaseException? workingError;

  FirebaseException? eventError;

  FirebaseException? educationError;

  FirebaseException? applyError;
  FirebaseException? retrieveApplyError;
  FirebaseException? searchError;

  final DateTime now = DateTime.now();

  List<WorkingExperienceModel> workingExperiences = [];
  List<EventExperienceModel> eventExperiences = [];
  List<EducationModel> education = [];

  ApplicationModel selectedApplication = ApplicationModel(
    id: "", 
    solicitorId: "", 
    jobId: "", 
    employerId: "",
    jobTitle: "",
    fullName: "", 
    dateOfBirth: DateTime.now(), 
    email: "", 
    phoneNumber: "", 
    placeOfResidence: "", 
    resumeUrl: "", 
    dateApplied: DateTime.now(),
    dateUpdated: DateTime.now(),
    status: "",
    employerName: ""
  );

  void update(AuthProvider authProvider) {
    if (authProvider.currentUser != null) {
      _authProvider = authProvider;
    }
  }

  void updateListeners() {
    notifyListeners();
  }

  Future<void> getAllApplications() async {
    retrieveApplyStatus = ApplyStatus.retrieving;
    retrieveApplyError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collectionGroup(Collections.applications.name).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (applicationModel, _) => applicationModel.toFirestore()).where("solicitorId", isEqualTo: _authProvider!.currentUser!.uid).orderBy("dateApplied", descending: true).get().then((collection) {
        allApplicationsList = collection.docs.map((e) => e.data()).toList();
        for (var application in allApplicationsList) {
          if (now.difference(application.dateUpdated).inDays > 14 && application.status != ApplicationStatus.pendingInterview.status) {
            application.dateUpdated = DateTime.now();
            application.status = ApplicationStatus.archived.status;
            updateApplication(application);
          }
        }
        retrieveApplyStatus = ApplyStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      retrieveApplyError = e;
      retrieveApplyStatus = ApplyStatus.failed;
      notifyListeners();
    } 
  }

  Future<void> getApplicationsWithQuery(String searchKey, ApplicationStatus type, bool? descending) async {
    searchStatus = ApplyStatus.retrieving;
    searchError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collectionGroup(Collections.applications.name).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (applicationModel, _) => applicationModel.toFirestore()).where("solicitorId", isEqualTo: _authProvider!.currentUser!.uid).orderBy("dateApplied", descending: descending ?? true).get().then((collection) {
        allApplicationsList = collection.docs.map((e) => e.data()).toList();
        for (var application in allApplicationsList) {
          if (now.difference(application.dateUpdated).inDays > 14 && application.status != ApplicationStatus.pendingInterview.status) {
            application.dateUpdated = DateTime.now();
            application.status = ApplicationStatus.archived.status;
            updateApplication(application);
          }
        }
        if (searchKey.isEmpty && type == ApplicationStatus.all) {
          resetSearch();
          notifyListeners();
        } else {
          var applications = collection.docs.map((e) => e.data()).toList();
          searchedApplicationsList = applications.where((e) => e.jobTitle.toLowerCase().contains(searchKey.toLowerCase()) && e.status.toLowerCase().contains(type.status.toLowerCase())).toList();
          searchStatus = ApplyStatus.loaded;
          notifyListeners();
        }
      });
    } on FirebaseException catch (e) {
      searchError = e;
      searchStatus = ApplyStatus.failed;
      notifyListeners();
    } 
  }

  void resetSearch() {
    searchedApplicationsList = [];
    searchStatus = ApplyStatus.unloaded;
    notifyListeners();
  }

  Future<void> setSelectedApplication(String jobId) async {
    selectedApplication = allApplicationsList.where((element) => element.id == jobId).first;
    await _firebaseFirestore.collection(Collections.jobPosts.name).doc(selectedApplication.jobId).collection(Collections.applications.name).doc(selectedApplication.id).collection(Collections.workingExperiences.name).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (workingExperienceModel, _) => workingExperienceModel.toFirestore()).get().then((value) {
      final docs = value.docs;
      workingExperiences = docs.map((e) => e.data()).toList();
      workingExperienceStatus = DataStatus.finished;
      notifyListeners();
    }).onError((error, stackTrace) {
      workingError = error as FirebaseException;
      workingExperienceStatus = DataStatus.failed;
      notifyListeners();
    });
    await _firebaseFirestore.collection(Collections.jobPosts.name).doc(selectedApplication.jobId).collection(Collections.applications.name).doc(selectedApplication.id).collection(Collections.otherExperiences.name).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (eventExperienceModel, _) => eventExperienceModel.toFirestore()).get().then((value) {
      final docs = value.docs;
      eventExperiences = docs.map((e) => e.data()).toList();
      eventExperienceStatus = DataStatus.finished;
      notifyListeners();
    }).onError((error, stackTrace) {
      eventError = error as FirebaseException;
      eventExperienceStatus = DataStatus.failed;
      notifyListeners();
    });
    await _firebaseFirestore.collection(Collections.jobPosts.name).doc(selectedApplication.jobId).collection(Collections.applications.name).doc(selectedApplication.id).collection(Collections.education.name).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (education, _) => education.toFirestore()).get().then((value) {
      final docs = value.docs;
      education = docs.map((e) => e.data()).toList();
      educationStatus = DataStatus.finished;
      notifyListeners();
    }).onError((error, stackTrace) {
      educationError = error as FirebaseException;
      educationStatus = DataStatus.failed;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<bool> setApplication(
    ApplicationModel application, 
    List<WorkingExperienceModel>? workingExperiences,
    List<EventExperienceModel>? otherExperiences,
    List<EducationModel>? education,
    ) async {
    applyStatus = ApplyStatus.uploading;
    applyError = null;
    notifyListeners();
    try {
      application.dateUpdated = now;
      var batch = _firebaseFirestore.batch();
      if (workingExperiences != null && otherExperiences != null && education != null) {
        for (var workingExperience in workingExperiences) {
          final docRef =  _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).collection(Collections.workingExperiences.name).doc(workingExperience.id).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (WorkingExperienceModel working, _) => working.toFirestore());
          batch.set(docRef, workingExperience);
        }
        for (var otherExpeience in otherExperiences) {
          final docRef =  _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).collection(Collections.otherExperiences.name).doc(otherExpeience.id).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel event, _) => event.toFirestore());
          batch.set(docRef, otherExpeience);
        }
        for (var edu in education) {
          final docRef =  _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).collection(Collections.education.name).doc(edu.id).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel edu, _) => edu.toFirestore());
          batch.set(docRef, edu);
        }
      }
      final applicationRef = _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (applicationModel, _) => applicationModel.toFirestore());
      batch.set(applicationRef, application);
      selectedApplication = application;
      await batch.commit();
      applyStatus = ApplyStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      applyError = e;
      applyStatus = ApplyStatus.failed;
      notifyListeners();
      return false;
    } 
  }

  Future<void> updateApplication(ApplicationModel application) async {
    try {
      await _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (application, _) => application.toFirestore()).set(application);
      notifyListeners();
    } on FirebaseException catch (e) {
      applyError = e;
      notifyListeners();
    } 
  }
}