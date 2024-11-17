import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/applications/model/applicationModel.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/features/authentication/model/userProfileModel.dart';
import 'package:jobs_r_us_employer/features/interviews/model/interviewModel.dart';
import 'package:jobs_r_us_employer/features/job_postings/model/jobPostModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/educationModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/eventExperienceModel.dart';
import 'package:jobs_r_us_employer/features/view_solicitors/model/workingExperienceModel.dart';

enum DataStatus { processing, finished, failed, unloaded }

class ProfileProvider extends ChangeNotifier {
  AuthProvider? _authProvider;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserProfileModel? userProfile;

  List<WorkingExperienceModel>? workingExperiences;

  List<EventExperienceModel>? eventExperiences;

  List<EducationModel>? educationList;

  DataStatus userStatus = DataStatus.unloaded;

  DataStatus imageStatus = DataStatus.unloaded;

  String? resumeName;

  FirebaseException? userError;

  Exception? imageError;

  bool hasVisitedProfilePage = false;

  bool hasUploadedProfilePicture = false;

  bool hasEditedAboutMe = false;

  void update(AuthProvider authProvider) {
    if (authProvider.currentUser != null) {
      _authProvider = authProvider;
      getUserBasicProfile();
    }
  }

  void updateListeners() {
    notifyListeners();
  }

 
  Future<File?> getImageFromGallery(BuildContext context) async {
    imageError = null;
    notifyListeners();
    try {
      FilePickerResult? singleMedia = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          "png",
          "jpg",
          "jpeg"
        ]
      );
      if(singleMedia == null) {
        return null;
      } else {
        return File(singleMedia.files.single.path!);
      }
    } on Exception catch (e) {
      imageError = e;
      notifyListeners();
      return null;
    }
  }

  Future<bool> setProfileImage(File file) async {
    imageError = null;
    imageStatus = DataStatus.processing;
    notifyListeners();
    try {
      String uid = _authProvider!.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref("employers/");
      final fileName = file.path.split("/").last;
      final uploadRef = ref.child("$uid/images/$fileName");
      if (userProfile!.profileUrl.isNotEmpty) {
        final deletionRef = ref.child("$uid/images");
        var allFiles = await deletionRef.listAll();
        for (var element in allFiles.items) {
          await element.delete();
        }
        await uploadRef.putFile(file);
        userProfile!.profileUrl = await uploadRef.getDownloadURL();
        imageStatus = DataStatus.finished;
        hasUploadedProfilePicture = true;
        notifyListeners();
        return true;
      } else {
        await uploadRef.putFile(file);
        userProfile!.profileUrl = await uploadRef.getDownloadURL();
        imageStatus = DataStatus.finished;
        hasUploadedProfilePicture = true;
        notifyListeners();
        return true;
      }
    } on FirebaseException catch (e) {
      imageError = e;
      imageStatus = DataStatus.failed;
      notifyListeners();
      return false;
    }
  }

  Future<void> getUserBasicProfile() async {
    userError = null;
    if (_authProvider!.registeredUserProfile == null) {
      userStatus = DataStatus.processing;
      notifyListeners();
      String uid = _authProvider!.currentUser!.uid;
      try {
          _firebaseFirestore.collection(Collections.employers.name).doc(uid).withConverter(fromFirestore: UserProfileModel.fromFirestore, toFirestore: (UserProfileModel userProfile, _) => userProfile.toFirestore()).get().then((doc) {
            final data = doc.data();
            if (data == null) {
              // null
            } else {
              userProfile = data;
              hasEditedAboutMe = userProfile!.hasEditedAboutMe;
              hasUploadedProfilePicture = userProfile!.hasUploadedProfilePicture;
              hasVisitedProfilePage = userProfile!.hasVisitedProfilePage;
              userStatus = DataStatus.finished;
            }
            notifyListeners();
          }).onError((error, stackTrace) {
            userError = error as FirebaseException;
            userStatus = DataStatus.failed;
            notifyListeners();
          });
      } on FirebaseException catch (e) {
        userError = e;
        userStatus = DataStatus.failed;
        notifyListeners();
      }
    } else {
      userProfile = _authProvider!.registeredUserProfile;
      _authProvider!.registeredUserProfile = null;
      userStatus = DataStatus.finished;
      notifyListeners();
    }
  }

  Future<bool> setUserProfile({
    String? name,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? businessAddress,
    String? aboutUs,
    String? visionMission,
    String? profileUrl,
    String? type,
  }) async {
    userError = null;
    userStatus = DataStatus.processing;
    notifyListeners();
    String uid = _authProvider!.currentUser!.uid;
    try {
      userProfile = userProfile!.copyWith(
        name: name,
        dateOfBirth: dateOfBirth,
        email: email,
        phoneNumber: phoneNumber,
        businessAddress: businessAddress,
        aboutUs: aboutUs,
        visionMission: visionMission,
        profileUrl: profileUrl,
        type: type,
        hasVisitedProfilePage: hasVisitedProfilePage,
        hasUploadedProfilePicture: hasUploadedProfilePicture,
        hasEditedAboutMe: hasEditedAboutMe
      );
      
      var batch = _firebaseFirestore.batch();
      final userRef =  _firebaseFirestore.collection(Collections.employers.name).doc(uid).withConverter(fromFirestore: UserProfileModel.fromFirestore, toFirestore: (UserProfileModel user, _) => user.toFirestore());
      batch.set(userRef, userProfile!);
      final interviewSnapshot = await _firebaseFirestore.collection(Collections.interviews.name).withConverter(fromFirestore: InterviewModel.fromFirestore, toFirestore: (InterviewModel interviewModel, _) => interviewModel.toFirestore()).where("employerId", isEqualTo: uid).get();
      for (var element in interviewSnapshot.docs) {
        batch.update(element.reference, {
          "employerName": userProfile?.name ?? "",
        });
      }

      final jobSnapshot = await _firebaseFirestore.collectionGroup(Collections.jobPosts.name).withConverter(fromFirestore: JobPostModel.fromFirestore, toFirestore: (JobPostModel jobModel, _) => jobModel.toFirestore()).where("employerId", isEqualTo: uid).get();
      for (var element in jobSnapshot.docs) {
        batch.update(element.reference, {
          "employerName": userProfile?.name ?? "",
        });
      }
      final applicationSnapshot = await _firebaseFirestore.collectionGroup(Collections.applications.name).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (ApplicationModel applicationModel, _) => applicationModel.toFirestore()).where("employerId", isEqualTo: uid).get();
      for (var element in applicationSnapshot.docs) {
        batch.update(element.reference, {
          "employerName": userProfile?.name ?? "",
        });
      }
      await batch.commit();
      userStatus = DataStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      userError = e;
      userStatus = DataStatus.failed;
      notifyListeners();
      return false;
    }
  }

  String? validateAboutMe(String? aboutMe) {
    if (aboutMe == null || aboutMe.isEmpty) {
      return "Enter a description of your business";
    } else {
      return null;
    }
  }

  String? validateVisionAndMission(String? aboutMe) {
    if (aboutMe == null || aboutMe.isEmpty) {
      return "Enter your vision and mission";
    } else {
      return null;
    }
  }
}