import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/report/model/feedbackReportModel.dart';
import 'package:jobs_r_us_employer/features/report/model/userReportModel.dart';

enum ReportStatus { processing, finished, failed, unloaded }
enum OffenseType {
  fraud("Fraud"),
  unfairDecision("Unjust Behavior"),
  defamation("Defamation"),
  violationOfNonDisclosure("Violation of NDA"),
  inappropriateComment("Inappropriate Comment");
  final String offense;
  const OffenseType(this.offense);
}

class ReportProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ReportStatus reportStatus = ReportStatus.unloaded;

  FirebaseException? reportError;

  Future<bool> setFeedbackReport(FeedbackReportModel report) async {
    reportStatus = ReportStatus.processing;
    reportError = null;
    notifyListeners();
    try {
      await _firebaseFirestore.collection(Collections.reportsFeedback.name).doc(report.id).withConverter(fromFirestore: FeedbackReportModel.fromFirestore, toFirestore: (reportModel, _) => reportModel.toFirestore()).set(report);
      reportStatus = ReportStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      reportStatus = ReportStatus.failed;
      reportError = e;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setUserReport(UserReportModel report) async {
    reportStatus = ReportStatus.processing;
    reportError = null;
    notifyListeners();
    try {
      await _firebaseFirestore.collection(Collections.reports.name).doc(report.id).withConverter(fromFirestore: UserReportModel.fromFirestore, toFirestore: (reportModel, _) => reportModel.toFirestore()).set(report);
      reportStatus = ReportStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      reportStatus = ReportStatus.failed;
      reportError = e;
      notifyListeners();
      return false;
    }
  }

  String? validateOffense(String? offense) {
    if (offense == null || offense.isEmpty ) {
      return "Enter an offence";
    } else {
      return null;
    }
  }

  String? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return "Enter a description of the offence";
    } else {
      return null;
    }
  }
}