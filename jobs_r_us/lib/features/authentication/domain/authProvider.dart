import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/authentication/model/userProfileModel.dart';

enum AuthStatus { authenticating, failed, unauthenticated, authenticated }

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat("d MMM yyyy");
  final DateTime _now = DateTime.now();
  final _exlusiveSpecialCharAndNumberExpression = RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]');
  final _emailExpression = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final _phoneNumberExpression = RegExp(r'^[1-9][0-9]*|0');

  User? get currentUser => _firebaseAuth.currentUser;

  AuthStatus authStatus = AuthStatus.unauthenticated;

  UserProfileModel? registeredUserProfile;

  FirebaseAuthException? loginError;

  FirebaseException? registrationError;

  String? validateFullName(String? name) {
    if (name == null || name.length <= 1) {
      return "Enter your full name";
    } else {
      return null;
    }
  }

  String? validateEmail(String? email) {
    if (email == null || email.length <= 1 ) {
      return "Enter your complete email";
    }
    if (!_emailExpression.hasMatch(email)) {
      return "Enter an email like someone@example.com";
    } else {
      return null;
    }
  }

  String? validateDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      return "Enter your date of birth";
    } else if (_now.difference(_dateFormat.parse(dateOfBirth)).inDays ~/ 365 < 18) {
      return "You need to be at least 18 years old to register";
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter your password";
    } else if (password.length < 8) {
      return "Your password must be at least 8 characters long";
    } else if (!_exlusiveSpecialCharAndNumberExpression.hasMatch(password)) {
      return "Add special characters or a number to your password";
    } else {
      return null;
    }
  }

  String? validatePasswordOnSignIn(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter your password";
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Enter your phone nubmer";
    } else if (!_phoneNumberExpression.hasMatch(phoneNumber)) {
      return "Enter a phone number like 081122223333";
    } else {
      return null;
    }
  }

  String? validatePlaceOfResidence(String? placeOfResidence) {
    if (placeOfResidence == null || placeOfResidence.isEmpty) {
      return "Enter your place of residence";
    } else {
      return null;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      authStatus = AuthStatus.authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      authStatus = AuthStatus.failed;
      loginError = e;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
    authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> registerUser(String fullName, String email, String password, DateTime dob, String phone, String placeOfResidence) async {
    try {
      authStatus = AuthStatus.authenticating;
      notifyListeners();
      UserCredential? credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final data = <String, dynamic> {
        "fullName" : fullName,
        "email" : email,
        "dateOfBirth" : dob,
        "phoneNumber" : phone,
        "placeOfResidence" : placeOfResidence,
        "aboutMe" : "",
        "resumeUrl" : "",
        "profileUrl" : "",
        "subscribedTag" : "",
        "hasVisitedProfilePage" : false,
        "hasUploadedProfilePicture" : false,
        "hasEditedAboutMe" : false,
        "followedEmployers" : []
      };
      await _firebaseFirestore.collection(Collections.solicitors.name).doc(credential.user?.uid ?? "").set(data);
      registeredUserProfile = UserProfileModel(
        fullName: fullName,
        dateOfBirth: dob,
        email: email,
        phoneNumber: phone,
        placeOfResidence: placeOfResidence,
        aboutMe: "",
        resumeUrl: "",
        profileUrl: "",
        subscribedTag: "",
        hasVisitedProfilePage: false,
        hasUploadedProfilePicture: false,
        hasEditedAboutMe: false,
        followedEmployers: []
      );
      authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      authStatus = AuthStatus.failed;
      registrationError = e;
      notifyListeners();
      return false;
    }
  }
}