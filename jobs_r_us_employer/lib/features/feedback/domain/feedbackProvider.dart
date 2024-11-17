import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/feedback/model/feedbackModel.dart';
enum FeedbackStatus { processing, failed, unloaded, loaded }

class FeedbackProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FeedbackStatus feedbackStatus = FeedbackStatus.unloaded;
  
  List<FeedbackModel> feedbackList = [];

  FirebaseException? feedbackError;
  FirebaseException? updateError;

  FeedbackModel selectedFeedback = FeedbackModel(
    id: "", 
    solicitorId: "", 
    name: "", 
    profileUrl: "", 
    jobId: "", 
    feedback: "",
    datePosted: DateTime.now(), 
    endorsedBy: 0, 
    dislikedBy: 0
  );

  Future<void> getFeedback(String jobId) async {
    feedbackStatus = FeedbackStatus.processing;
    feedbackError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).withConverter(fromFirestore: FeedbackModel.fromFirestore, toFirestore: (feedbackModel, _) => feedbackModel.toFirestore()).orderBy("datePosted", descending: true).get().then((snapshot) {
        final docs = snapshot.docs;
        feedbackList = docs.map((e) => e.data()).toList();
        feedbackStatus = FeedbackStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      feedbackError = e;  
      feedbackStatus = FeedbackStatus.failed;
      notifyListeners();
    } 
  }

  void setSelectedFeedback(String id) {
    selectedFeedback = feedbackList.where((element) => element.id == id).first;
    notifyListeners();
  }
}