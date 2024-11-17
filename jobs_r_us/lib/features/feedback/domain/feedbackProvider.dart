import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/feedback/model/feedbackModel.dart';
enum FeedbackStatus { processing, failed, unloaded, loaded }

class FeedbackProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FeedbackStatus feedbackStatus = FeedbackStatus.unloaded;
  FeedbackStatus updateStatus = FeedbackStatus.unloaded;
  
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

  Future<bool> addFeedback(FeedbackModel feedbackModel) async {
    feedbackStatus = FeedbackStatus.processing;
    feedbackError = null;
    notifyListeners();
    try {
      feedbackList.add(feedbackModel);
      final batch = _firebaseFirestore.batch();
      for (var feedback in feedbackList) {
        final ref = _firebaseFirestore.collection(Collections.jobPosts.name).doc(feedbackModel.jobId).collection(Collections.feedbacks.name).doc(feedback.id).withConverter(fromFirestore: FeedbackModel.fromFirestore, toFirestore: (feedbackModel, _) => feedbackModel.toFirestore());
        batch.set(ref, feedback);
      }
      await batch.commit();
      feedbackStatus = FeedbackStatus.loaded;
      feedbackError = null;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      feedbackError = e;  
      feedbackStatus = FeedbackStatus.failed;
      notifyListeners();
      return false;
    } 
  }

  Future<void> setFeedback(String jobId) async {
    updateStatus = FeedbackStatus.processing;
    updateError = null;
    notifyListeners();
    try {
      final batch = _firebaseFirestore.batch();
      for (var feedback in feedbackList) {
        final ref = _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedback.id).withConverter(fromFirestore: FeedbackModel.fromFirestore, toFirestore: (feedbackModel, _) => feedbackModel.toFirestore());
        batch.set(ref, feedback);
      }
      await batch.commit();
      updateStatus = FeedbackStatus.loaded;
      updateError = null;
      notifyListeners();
    } on FirebaseException catch (e) {
      updateError = e;  
      updateStatus = FeedbackStatus.failed;
      notifyListeners();
    } 
  }

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

  String? validateFeedback(String? feedback) {
    if (feedback == null || feedback.isEmpty) {
      return "Please enter your feedback";
    } else {
      return null;
    }
  }

  Future<void> endorseFeedback(String feedbackId, String userId, String jobId) async {
    _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.endorsedBy.name).doc(userId).get().then((value) async {
      for (var feedback in feedbackList) {
        if (feedback.id == feedbackId) {
          if (value.exists) {
            await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.endorsedBy.name).doc(userId).delete();
            feedback.endorsedBy--;
          } else {
            await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.endorsedBy.name).doc(userId).set(
              {
                "dateEndorsed": DateTime.now(),
                "solictorId": userId,
              }
            );
            feedback.endorsedBy++;
          }
          final snapshot = await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.dislikedBy.name).doc(userId).get();
          if (snapshot.exists) {
            await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.dislikedBy.name).doc(userId).delete();
            feedback.dislikedBy--;
          }
          setFeedback(jobId);
        }
      }
    });
  }

  Future<void> dislikeFeedback(String feedbackId, String userId, String jobId) async {
    _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.dislikedBy.name).doc(userId).get().then((value) async {
      for (var feedback in feedbackList) {
        if (feedback.id == feedbackId) {
          if (value.exists) {
            await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.dislikedBy.name).doc(userId).delete();
            feedback.dislikedBy--;
          } else {
            await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.dislikedBy.name).doc(userId).set(
              {
                "dateDisliked": DateTime.now(),
                "solictorId": userId,
              }
            );
            feedback.dislikedBy++;
          }
          final snapshot = await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.endorsedBy.name).doc(userId).get();
          if (snapshot.exists) {
            await _firebaseFirestore.collection(Collections.jobPosts.name).doc(jobId).collection(Collections.feedbacks.name).doc(feedbackId).collection(Collections.endorsedBy.name).doc(userId).delete();
            feedback.endorsedBy--;
          }
          setFeedback(jobId);
        }
      }
    });
  }

  void setSelectedFeedback(String id) {
    selectedFeedback = feedbackList.where((element) => element.id == id).first;
    notifyListeners();
  }
}