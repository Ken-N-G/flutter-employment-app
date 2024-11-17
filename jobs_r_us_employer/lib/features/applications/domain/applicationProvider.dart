import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/applications/model/applicationModel.dart';
import 'package:flutter/services.dart';
import 'package:jobs_r_us_employer/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/educationModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/eventExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/workingExperienceModel.dart';

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

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<ApplicationModel> allApplicationsList = [];
  List<ApplicationModel> searchedApplicationsList = [];

  List<WorkingExperienceModel> workingExperiences = [];
  List<EventExperienceModel> eventExperiences = [];
  List<EducationModel> education = [];

  ApplyStatus applyStatus = ApplyStatus.unloaded;
  ApplyStatus retrieveApplyStatus = ApplyStatus.unloaded;
  ApplyStatus searchStatus = ApplyStatus.unloaded;
  ApplyStatus resumeStatus = ApplyStatus.unloaded;

  DataStatus workingExperienceStatus = DataStatus.unloaded;

  DataStatus eventExperienceStatus = DataStatus.unloaded;

  DataStatus educationStatus = DataStatus.unloaded;

  FirebaseException? workingError;

  FirebaseException? eventError;

  FirebaseException? educationError;

  FirebaseException? applyError;
  FirebaseException? retrieveApplyError;
  FirebaseException? searchError;
  FirebaseException? metricsError;
  Exception? resumeError;

  PDFDocument? document;

  final DateTime now = DateTime.now();

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

  Future<void> getAllApplications(String seletectedJobId) async {
    retrieveApplyStatus = ApplyStatus.retrieving;
    retrieveApplyError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.jobPosts.name).doc(seletectedJobId).collection(Collections.applications.name).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (applicationModel, _) => applicationModel.toFirestore()).orderBy("dateApplied", descending: true).get().then((collection) {
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

  Future<void> getApplicationsWithQuery(String searchKey, ApplicationStatus type, bool? descending, String seletectedJobId) async {
    searchStatus = ApplyStatus.retrieving;
    searchError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.jobPosts.name).doc(seletectedJobId).collection(Collections.applications.name).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (applicationModel, _) => applicationModel.toFirestore()).orderBy("dateApplied", descending: descending ?? true).get().then((collection) {
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
          searchedApplicationsList = applications.where((e) => e.fullName.toLowerCase().contains(searchKey.toLowerCase()) && e.status.toLowerCase().contains(type.status.toLowerCase())).toList();
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

  Future<bool> setSelectedApplication(String id) async {
    bool wasStatusUpdated = false;
    selectedApplication = allApplicationsList.where((element) => element.id == id).first;
    if (selectedApplication.status == ApplicationStatus.submitted.status) {
      wasStatusUpdated = true;
      selectedApplication.status = ApplicationStatus.pendingReview.status;
      for (int x = 0; x < allApplicationsList.length; x++) {
        if (allApplicationsList[x].id == id) {
          allApplicationsList[x].status = ApplicationStatus.pendingReview.status;
        }
      } 
    }
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
    setApplication(selectedApplication);
    notifyListeners();
    return wasStatusUpdated;
  }

  Future<bool> setApplication(ApplicationModel application) async {
    applyStatus = ApplyStatus.uploading;
    applyError = null;
    notifyListeners();
    try {
      application.dateUpdated = DateTime.now();
      _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (applicationModel, _) => applicationModel.toFirestore()).set(application);
      for (int x = 0; x < allApplicationsList.length; x++) {
        if (allApplicationsList[x].id == application.id) {
          allApplicationsList[x] = application;
        }
      }
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

  Future<bool> getResumeDocument() async {
    resumeError = null;
    document = null;
    resumeStatus = ApplyStatus.retrieving;
    notifyListeners();
    try {
      document = await PDFDocument.fromURL(selectedApplication.resumeUrl);
      resumeStatus = ApplyStatus.finished;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      resumeStatus = ApplyStatus.failed;
      resumeError = e;
      print(resumeError);
      notifyListeners();
      return false;
    }
  }

  Future<void> updateApplication(ApplicationModel application) async {
    try {
       _firebaseFirestore.collection(Collections.jobPosts.name).doc(application.jobId).collection(Collections.applications.name).doc(application.id).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (application, _) => application.toFirestore()).set(application);
      notifyListeners();
    } on FirebaseException catch (e) {
      applyError = e;
      notifyListeners();
    } 
  }
}