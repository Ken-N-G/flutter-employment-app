import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/interviews/model/interviewModel.dart';

enum InterStatus { processing, finished, failed, unloaded }
enum InterviewStatus {
  all("", Colors.transparent),
  pendingSchedule("Awaiting Schedule from You", Color.fromARGB(255, 206, 110, 0)),
  awaitingInterview("Awaiting Interview", Color.fromARGB(255, 141, 97, 81)),
  happeningNow("Happening Now", Color.fromARGB(255, 190, 31, 19)),
  completed("Completed", Colors.green),
  archived("Archived", Color.fromARGB(255, 94, 94, 94));
  final String status;
  final Color color;  
  const InterviewStatus(this.status, this.color);
}

enum InterviewTypes {
  phoneCall("Telephone"),
  google("Google Meet"),
  zoom("Zoom");
  final String types;
  const InterviewTypes(this.types);
}

class InterviewProvider extends ChangeNotifier {
  AuthProvider? _authProvider;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<InterviewModel> interviewList = [];
  List<InterviewModel> searchedInterviewList = [];

  InterviewModel selectedInterview = InterviewModel(
    id: "", 
    solicitorId: "", 
    employerId: "",
    jobId: "", 
    interviewMethod: "", 
    link: "", 
    additionalPreparations: "", 
    selectedDate: DateTime.now(),
    lastUpdatedDate: DateTime.now(),  
    status: "", 
    availableDates: [],
    solicitorName: "",
    employerName: "",
    jobTitle: ""
  );

  InterStatus interviewStatus = InterStatus.unloaded;
  InterStatus searchStatus = InterStatus.unloaded;

  FirebaseException? interviewError;
  FirebaseException? searchError;


  void update(AuthProvider authProvider) {
    if (authProvider.currentUser != null) {
      _authProvider = authProvider;
      getInterviews();
    }
  }

  void updateListeners() {
    notifyListeners();
  }

  Future<void> getInterviews() async {
    interviewStatus = InterStatus.processing;
    interviewError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.interviews.name).withConverter(fromFirestore: InterviewModel.fromFirestore, toFirestore: (interviewModel, _) => interviewModel.toFirestore()).where("employerId", isEqualTo: _authProvider!.currentUser!.uid).orderBy("lastUpdatedDate", descending: true).get().then((collection) {
        interviewList = collection.docs.map((e) => e.data()).toList();
        for (var interview in interviewList) {
          if (DateTime.now().difference(interview.lastUpdatedDate).inDays > 14 && interview.status != InterviewStatus.awaitingInterview.status) {
            interview.lastUpdatedDate = DateTime.now();
            interview.status = InterviewStatus.archived.status;
            updateInterviewItem(interview);
          }
          switch (interview.status) {
            case "Awaiting Interview":
              final daysUntilInterview = interview.selectedDate.difference(DateTime.now()).inHours;
              if (daysUntilInterview == 0) {
                interview.lastUpdatedDate = DateTime.now();
                interview.status = InterviewStatus.happeningNow.status;
                updateInterviewItem(interview);
              } else if (daysUntilInterview < 0) {
                interview.lastUpdatedDate = DateTime.now();
                interview.status = InterviewStatus.completed.status;
                updateInterviewItem(interview);
              }
              break;
            case "Happening Now":
              final daysUntilInterview = interview.selectedDate.difference(DateTime.now()).inDays;
              if (daysUntilInterview < 0) {
                interview.lastUpdatedDate = DateTime.now();
                interview.status = InterviewStatus.completed.status;
                updateInterviewItem(interview);
              }
              break;
          }
        }
        interviewStatus = InterStatus.finished;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      interviewError = e;
      interviewStatus = InterStatus.failed;
      notifyListeners();
    } 
  }

  Future<void> getInterviewsWithQuery(InterviewStatus type) async {
    if (searchStatus == InterStatus.processing){
      return;
    }
    searchStatus = InterStatus.processing;
    searchError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.interviews.name).withConverter(fromFirestore: InterviewModel.fromFirestore, toFirestore: (interviewModel, _) => interviewModel.toFirestore()).where("employerId", isEqualTo: _authProvider!.currentUser!.uid).orderBy("lastUpdatedDate", descending: true).get().then((collection) {
      interviewList = collection.docs.map((e) => e.data()).toList();
      for (var interview in interviewList) {
        if (DateTime.now().difference(interview.lastUpdatedDate).inDays > 14 && interview.status != InterviewStatus.awaitingInterview.status) {
            interview.lastUpdatedDate = DateTime.now();
            interview.status = InterviewStatus.archived.status;
            updateInterviewItem(interview);
          }
          switch (interview.status) {
            case "Awaiting Interview":
              final daysUntilInterview = interview.selectedDate.difference(DateTime.now()).inDays;
              if (daysUntilInterview == 0) {
                interview.lastUpdatedDate = DateTime.now();
                interview.status = InterviewStatus.happeningNow.status;
                updateInterviewItem(interview);
              } else if (daysUntilInterview < 0) {
                interview.lastUpdatedDate = DateTime.now();
                interview.status = InterviewStatus.completed.status;
                updateInterviewItem(interview);
              }
              break;
            case "Happening Now":
              final daysUntilInterview = interview.selectedDate.difference(DateTime.now()).inDays;
              if (daysUntilInterview < 0) {
                interview.lastUpdatedDate = DateTime.now();
                interview.status = InterviewStatus.completed.status;
                updateInterviewItem(interview);
              }
              break;
          }
        }
        if (type == InterviewStatus.all) {
          resetSearch();
          notifyListeners();
        } else {
          var applications = collection.docs.map((e) => e.data()).toList();
          searchedInterviewList = applications.where((e) => e.status.toLowerCase().contains(type.status.toLowerCase())).toList();
          searchStatus = InterStatus.finished;
          notifyListeners();
        }
      });
    } on FirebaseException catch (e) {
      searchError = e;
      searchStatus = InterStatus.failed;
      notifyListeners();
    } 
  }

  void resetSearch() {
    searchedInterviewList = [];
    searchStatus = InterStatus.unloaded;
    notifyListeners();
  }

  Future<bool> setInterview(InterviewModel interview) async {
    interviewStatus = InterStatus.processing;
    interviewError = null;
    notifyListeners();
    try {
      await _firebaseFirestore.collection(Collections.interviews.name).doc(interview.id).withConverter(fromFirestore: InterviewModel.fromFirestore, toFirestore: (interviewModel, _) => interviewModel.toFirestore()).set(interview);
      interviewStatus = InterStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      interviewError = e;
      interviewStatus = InterStatus.failed;
      notifyListeners();
      return false;
    } 
  }

  String? validateDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Enter a date";
    } else {
      return null;
    }
  }

  String? validateTime(String? time) {
    if (time == null || time.isEmpty) {
      return "Enter a time";
    } else {
      return null;
    }
  }
  String? validateLink(String? time) {
    if (time == null || time.isEmpty) {
      return "Include a link to the external video call";
    } else {
      return null;
    }
  }

  String? validateAdditonalPreparations(String? time) {
    return null;
  }

  Future<void> updateInterviewItem(InterviewModel interview) async {
    try {
      await _firebaseFirestore.collection(Collections.interviews.name).doc(interview.id).withConverter(fromFirestore: InterviewModel.fromFirestore, toFirestore: (interviewModel, _) => interviewModel.toFirestore()).set(interview);
      notifyListeners();
    } on FirebaseException catch (e) {
      interviewError = e;
      notifyListeners();
    } 
  }
}