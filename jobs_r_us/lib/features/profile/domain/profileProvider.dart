import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/applications/model/applicationModel.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/authentication/model/userProfileModel.dart';
import 'package:jobs_r_us/features/feedback/model/feedbackModel.dart';
import 'package:jobs_r_us/features/interviews/model/interviewModel.dart';
import 'package:jobs_r_us/features/profile/model/educationModel.dart';
import 'package:jobs_r_us/features/profile/model/eventExperienceModel.dart';
import 'package:jobs_r_us/features/profile/model/workingExperienceModel.dart';

enum DataStatus { processing, finished, failed, unloaded }

class ProfileProvider extends ChangeNotifier {
  AuthProvider? _authProvider;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserProfileModel? userProfile;

  List<WorkingExperienceModel>? workingExperiences;

  List<EventExperienceModel>? eventExperiences;

  List<EducationModel>? educationList;

  DataStatus userStatus = DataStatus.unloaded;

  DataStatus workingExperienceStatus = DataStatus.unloaded;

  DataStatus eventExperienceStatus = DataStatus.unloaded;

  DataStatus educationStatus = DataStatus.unloaded;

  DataStatus imageStatus = DataStatus.unloaded;

  DataStatus fileStatus = DataStatus.unloaded;
  
  String? resumeName;

  FirebaseException? userError;

  FirebaseException? workingError;

  FirebaseException? eventError;

  FirebaseException? educationError;

  Exception? imageError;

  Exception? fileError;

  bool hasVisitedProfilePage = false;

  bool hasUploadedProfilePicture = false;

  bool hasEditedAboutMe = false;

  final _exlusiveSpecialCharAndNumberExpression = RegExp(r'[0-9!@#$%^&*(),?":{}|<>]');

  void update(AuthProvider authProvider) {
    if (authProvider.currentUser != null) {
      _authProvider = authProvider;
      getUserBasicProfile();
      getWorkingExperiences();
      getEventExperiences();
      getEducationExperiences();
    }
  }

  void updateListeners() {
    notifyListeners();
  }

  Future<void> getResumeData() async {
    try {
      String uid = _authProvider!.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref("solicitors/");
      final docRef = ref.child("$uid/doc");
      if (userProfile!.resumeUrl.isNotEmpty) {
        var allFiles = await docRef.listAll();
        for (var element in allFiles.items) {
          resumeName = element.name;
        }
        fileStatus = DataStatus.finished;
        notifyListeners();
      } else {
        resumeName = null;
        fileStatus = DataStatus.finished;
        notifyListeners();
      }
    } on FirebaseException catch (e) {
      fileError = e;
      fileStatus = DataStatus.failed;
      notifyListeners();
    }
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

  Future<File?> getPDFFromPhone(BuildContext context) async{
    fileError = null;
    notifyListeners();
    try {
      FilePickerResult? singleMedia = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          "pdf",
        ]
      );
      if(singleMedia == null) {
        return null;
      } else {
        return File(singleMedia.files.single.path!);
      }
    } on Exception catch (e) {
      fileError = e;
      notifyListeners();
      return null;
    }
  }

  Future<bool> setProfileImage(File file) async {
    fileError = null;
    imageStatus = DataStatus.processing;
    notifyListeners();
    try {
      String uid = _authProvider!.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref("solicitors/");
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

  Future<bool> setResume(File file) async {
    fileError = null;
    fileStatus = DataStatus.processing;
    notifyListeners();
    try {
      String uid = _authProvider!.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref("solicitors/");
      final fileName = file.path.split("/").last;
      final uploadRef = ref.child("$uid/doc/$fileName");
      if (userProfile!.resumeUrl.isNotEmpty) {
        final deletionRef = ref.child("$uid/doc");
        var allFiles = await deletionRef.listAll();
        for (var element in allFiles.items) {
          await element.delete();
        }
        await uploadRef.putFile(file);
        userProfile!.resumeUrl = await uploadRef.getDownloadURL();
        resumeName = fileName;
        fileStatus = DataStatus.finished;
        notifyListeners();
        return true;
      } else {
        await uploadRef.putFile(file);
        userProfile!.resumeUrl = await uploadRef.getDownloadURL();
        resumeName = fileName;
        fileStatus = DataStatus.finished;
        notifyListeners();
        return true;
      }
    } on FirebaseException catch (e) {
      fileError = e;
      fileStatus = DataStatus.failed;
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
          _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).withConverter(fromFirestore: UserProfileModel.fromFirestore, toFirestore: (UserProfileModel userProfile, _) => userProfile.toFirestore()).get().then((doc) {
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
            getResumeData().then((value) {
              userStatus = DataStatus.finished;
            notifyListeners();
            });
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

  Future<void> getWorkingExperiences() async {
    if (_authProvider!.registeredUserProfile == null) {
      workingError = null;
      userStatus = DataStatus.processing;
      notifyListeners();
      String uid = _authProvider!.currentUser!.uid;
      try {
          _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.workingExperiences.name).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, 
          toFirestore: (WorkingExperienceModel experience, _) => experience.toFirestore()).get().then((snapshot) {
            final docs = snapshot.docs;
            workingExperiences = docs.map((e) => e.data()).toList();
            workingExperienceStatus = DataStatus.finished;
            notifyListeners();
          }).onError((error, stackTrace) {
            workingError = error as FirebaseException;
            workingExperienceStatus = DataStatus.failed;
            notifyListeners();
          });
      } on FirebaseException catch (e) {
        workingError = e;
        workingExperienceStatus = DataStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> getEventExperiences() async {
    if (_authProvider!.registeredUserProfile == null) {
      eventError = null;
      eventExperienceStatus = DataStatus.processing;
      notifyListeners();
      String uid = _authProvider!.currentUser!.uid;
      try {
          _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.otherExperiences.name).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel experience, _) => experience.toFirestore()).get().then((snapshot) {
            final docs = snapshot.docs;
            eventExperiences = docs.map((e) => e.data()).toList();
            eventExperienceStatus = DataStatus.finished;
            notifyListeners();
          }).onError((error, stackTrace) {
            eventError = error as FirebaseException;
            eventExperienceStatus = DataStatus.failed;
            notifyListeners();
          });
      } on FirebaseException catch (e) {
        eventError = e;
        eventExperienceStatus = DataStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> getEducationExperiences() async {
    if (_authProvider!.registeredUserProfile == null) {
      educationError = null;
      educationStatus = DataStatus.processing;
      notifyListeners();
      String uid = _authProvider!.currentUser!.uid;
      try {
          _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.education.name).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel education, _) => education.toFirestore()).get().then((snapshot) {
            final docs = snapshot.docs;
            educationList = docs.map((e) => e.data()).toList();
            educationStatus = DataStatus.finished;
            notifyListeners();
          }).onError((error, stackTrace) {
            educationError = error as FirebaseException;
            educationStatus = DataStatus.failed;
            notifyListeners();
          });
      } on FirebaseException catch (e) {
        educationError = e;
        educationStatus = DataStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<bool> setUserProfile({
    String? fullName,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? placeOfResidence,
    String? aboutMe,
    String? resumeUrl,
    String? profileUrl,
    String? subscribedTag,
    List<String>? followedEmployers,
  }) async {
    userError = null;
    userStatus = DataStatus.processing;
    notifyListeners();
    String uid = _authProvider!.currentUser!.uid;
    try {
      userProfile = userProfile!.copyWith(
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        email: email,
        phoneNumber: phoneNumber,
        placeOfResidence: placeOfResidence,
        aboutMe: aboutMe,
        resumeUrl: resumeUrl,
        profileUrl: profileUrl,
        subscribedTag: subscribedTag,
        hasVisitedProfilePage: hasVisitedProfilePage,
        hasUploadedProfilePicture: hasUploadedProfilePicture,
        hasEditedAboutMe: hasEditedAboutMe,
        followedEmployers: followedEmployers
      );
      var batch = _firebaseFirestore.batch();
      final userRef = _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).withConverter(fromFirestore: UserProfileModel.fromFirestore, toFirestore: (UserProfileModel user, _) => user.toFirestore());
      batch.set(userRef, userProfile!);
      final interviewSnapshot = await _firebaseFirestore.collection(Collections.interviews.name).withConverter(fromFirestore: InterviewModel.fromFirestore, toFirestore: (InterviewModel interviewModel, _) => interviewModel.toFirestore()).where("solicitorId", isEqualTo: uid).get();
      for (var element in interviewSnapshot.docs) {
        batch.update(element.reference, {
          "solicitorName": userProfile?.fullName ?? "",
        });
      }

      final feedbackSnapshot = await _firebaseFirestore.collectionGroup(Collections.feedbacks.name).withConverter(fromFirestore: FeedbackModel.fromFirestore, toFirestore: (FeedbackModel feedbackModel, _) => feedbackModel.toFirestore()).where("solicitorId", isEqualTo: uid).get();
      for (var element in feedbackSnapshot.docs) {
        batch.update(element.reference, {
          "name": userProfile?.fullName ?? "",
          "profileUrl": userProfile?.profileUrl ?? "",
        });
      }
      final applicationSnapshot = await _firebaseFirestore.collectionGroup(Collections.applications.name).withConverter(fromFirestore: ApplicationModel.fromFirestore, toFirestore: (ApplicationModel applicationModel, _) => applicationModel.toFirestore()).where("solicitorId", isEqualTo: uid).get();
      for (var element in applicationSnapshot.docs) {
        batch.update(element.reference, {
          "fullName": userProfile?.fullName ?? "",
          "resumeUrl" : userProfile?.resumeUrl ?? ""
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


  Future<bool> setEducation(List<EducationModel> updatedList) async {
    educationError = null;
    educationStatus = DataStatus.processing;
    notifyListeners();
    String uid = _authProvider!.currentUser!.uid;
    if (updatedList.isNotEmpty) {
      try {
        final batch = _firebaseFirestore.batch();
        List<EducationModel> newItems = [];
        List<EducationModel> updatedItems = [];
        List<EducationModel> deletedItems = [];

        if (educationList!.isNotEmpty) {
          for (var doc in educationList!) {
            bool docDoesNotExist = true;
            for (int x = 0; x < updatedList.length; x++) {
              if (updatedList[x].id == doc.id) {
                updatedItems.add(updatedList.removeAt(x));
                docDoesNotExist = false;
                break;
              }
            }
            if (docDoesNotExist) {
              deletedItems.add(doc);
            }
          }
        }

        newItems = updatedList;

        for (var education in updatedItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.education.name).doc(education.id).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel education, _) => education.toFirestore());
          batch.set(docRef, education);
        }

        for (var education in deletedItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.education.name).doc(education.id).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel education, _) => education.toFirestore());
          batch.delete(docRef);
        }

        for (var education in newItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.education.name).doc(education.id).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel education, _) => education.toFirestore());
          batch.set(docRef, education);
        }

        await batch.commit();
        educationStatus = DataStatus.finished;
        educationList = newItems + updatedItems;
        notifyListeners();
        return true;
      } on FirebaseException catch (e) {
        educationError = e;
        educationStatus = DataStatus.failed;
        notifyListeners();
        return false;
      }
    } else {
      try {
        if (educationList != null) {
          final batch = _firebaseFirestore.batch();
          for (var education in educationList!) {
            final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.education.name).doc(education.id).withConverter(fromFirestore: EducationModel.fromFirestore, toFirestore: (EducationModel education, _) => education.toFirestore());
            batch.delete(docRef);
          }

          await batch.commit();
          educationStatus = DataStatus.finished;
          educationList = [];
          notifyListeners();
          return true;
        } else {
          educationStatus = DataStatus.failed;
          educationList = [];
          notifyListeners();
          return false;
        }
      } on FirebaseException catch (e) {
        educationError = e;
        educationStatus = DataStatus.failed;
        notifyListeners();
        return false;
      }
    }
  }

  Future<bool> setOtherExperiences(List<EventExperienceModel> updatedList) async {
    eventError = null;
    eventExperienceStatus = DataStatus.processing;
    notifyListeners();
    String uid = _authProvider!.currentUser!.uid;
    if (updatedList.isNotEmpty) {
      try {
        final batch = _firebaseFirestore.batch();
        List<EventExperienceModel> newItems = [];
        List<EventExperienceModel> updatedItems = [];
        List<EventExperienceModel> deletedItems = [];

        if (eventExperiences!.isNotEmpty) {
          for (var doc in eventExperiences!) {
            bool docDoesNotExist = true;
            for (int x = 0; x < updatedList.length; x++) {
              if (updatedList[x].id == doc.id) {
                updatedItems.add(updatedList.removeAt(x));
                docDoesNotExist = false;
                break;
              }
            }
            if (docDoesNotExist) {
              deletedItems.add(doc);
            }
          }
        }

        newItems = updatedList;

        for (var experience in updatedItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.otherExperiences.name).doc(experience.id).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel experience, _) => experience.toFirestore());
          batch.set(docRef, experience);
        }

        for (var experience in deletedItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.otherExperiences.name).doc(experience.id).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel experience, _) => experience.toFirestore());
          batch.delete(docRef);
        }

        for (var experience in newItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.otherExperiences.name).doc(experience.id).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel experience, _) => experience.toFirestore());
          batch.set(docRef, experience);
        }

        await batch.commit();
        eventExperienceStatus = DataStatus.finished;
        eventExperiences = newItems + updatedItems;
        notifyListeners();
        return true;
      } on FirebaseException catch (e) {
        eventError = e;
        eventExperienceStatus = DataStatus.failed;
        notifyListeners();
        return false;
      }
    } else {
      try {
        if (eventExperiences != null) {
          final batch = _firebaseFirestore.batch();
          for (var experience in eventExperiences!) {
            final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.otherExperiences.name).doc(experience.id).withConverter(fromFirestore: EventExperienceModel.fromFirestore, toFirestore: (EventExperienceModel experience, _) => experience.toFirestore());
            batch.delete(docRef);
          }

          await batch.commit();
          eventExperienceStatus = DataStatus.finished;
          eventExperiences = [];
          notifyListeners();
          return true;
        }
        return true;
      } on FirebaseException catch (e) {
        eventError = e;
        eventExperienceStatus = DataStatus.failed;
        notifyListeners();
        return false;
      }
    }
  }

  Future<bool> setWorkingExperiences(List<WorkingExperienceModel> updatedList) async {
    workingError = null;
    workingExperienceStatus = DataStatus.processing;
    notifyListeners();
    String uid = _authProvider!.currentUser!.uid;
    if (updatedList.isNotEmpty) {
      try {
        final batch = _firebaseFirestore.batch();
        List<WorkingExperienceModel> newItems = [];
        List<WorkingExperienceModel> updatedItems = [];
        List<WorkingExperienceModel> deletedItems = [];

        if (workingExperiences!.isNotEmpty) {
          for (var doc in workingExperiences!) {
            bool docDoesNotExist = true;
            for (int x = 0; x < updatedList.length; x++) {
              if (updatedList[x].id == doc.id) {
                updatedItems.add(updatedList.removeAt(x));
                docDoesNotExist = false;
                break;
              }
            }
            if (docDoesNotExist) {
              deletedItems.add(doc);
            }
          }
        }

        newItems = updatedList;

        for (var experience in updatedItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.workingExperiences.name).doc(experience.id).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (WorkingExperienceModel experience, _) => experience.toFirestore());
          batch.set(docRef, experience);
        }

        for (var experience in deletedItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.workingExperiences.name).doc(experience.id).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (WorkingExperienceModel experience, _) => experience.toFirestore());
          batch.delete(docRef);
        }

        for (var experience in newItems) {
          final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.workingExperiences.name).doc(experience.id).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (WorkingExperienceModel experience, _) => experience.toFirestore());
          batch.set(docRef, experience);
        }

        await batch.commit();
        workingExperienceStatus = DataStatus.finished;
        workingExperiences = newItems + updatedItems;
        notifyListeners();
        return true;
      } on FirebaseException catch (e) {
        workingError = e;
        workingExperienceStatus = DataStatus.failed;
        notifyListeners();
        return false;
      }
    } else {
      try {
        if (workingExperiences != null) {
          final batch = _firebaseFirestore.batch();
          for (var experience in workingExperiences!) {
            final docRef =  _firebaseFirestore.collection(Collections.solicitors.name).doc(uid).collection(Collections.workingExperiences.name).doc(experience.id).withConverter(fromFirestore: WorkingExperienceModel.fromFirestore, toFirestore: (WorkingExperienceModel experience, _) => experience.toFirestore());
            batch.delete(docRef);
          }

          await batch.commit();
          workingExperienceStatus = DataStatus.finished;
          workingExperiences = [];
          notifyListeners();
          return true;
        }
        return true;
      } on FirebaseException catch (e) {
        workingError = e;
        workingExperienceStatus = DataStatus.failed;
        notifyListeners();
        return false;
      }
    }
  }

  String? validateAboutMe(String? aboutMe) {
    if (aboutMe == null || aboutMe.isEmpty) {
      return "Describe yourself";
    } else {
      return null;
    }
  }

  String? validateInstitution(String? institution) {
    if (institution == null || institution.isEmpty) {
      return "Enter the institution you studied in";
    } else {
      return null;
    }
  }

  String? validateQualification(String? lastHighestQualification) {
    if (lastHighestQualification == null || lastHighestQualification.isEmpty) {
      return "Enter the lastest highest qualification you obtained";
    } else {
      return null;
    }
  }
  
  String? validateLocation(String? location) {
    if (location == null || location.isEmpty) {
      return "Enter the location of this institution";
    } else {
      return null;
    }
  }
  
  String? validatePositionHeld(String? positionHeld) {
    if (positionHeld == null || positionHeld.isEmpty) {
      return "Enter a position";
    } else if (_exlusiveSpecialCharAndNumberExpression.hasMatch(positionHeld)) {
      return "Do not add numbers or special characters like !@#\$%^&*(),?\":{}|<>";
    } else {
      return null;
    }
  }

  String? validateEvent(String? event) {
    if(event == null || event.isEmpty) {
      return "Enter an event you participated in";
    } else {
      return null;
    }
  }

  String? validateEmployer(String? employer) {
    if(employer == null || employer.isEmpty) {
      return "Enter the Employer you worked the position for";
    } else {
      return null;
    }
  }

  String? validateDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Enter a date";
    } else {
      return null;
    }
  }
}