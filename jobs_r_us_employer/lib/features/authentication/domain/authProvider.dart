import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobs_r_us_employer/core/data/collections.dart';
import 'package:jobs_r_us_employer/features/authentication/model/userProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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

  String? validateName(String? name) {
    if (name == null || name.length <= 1) {
      return "Enter your name or business name";
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
      return "You must be at least 18 years old to register";
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter a password";
    } else if (password.length < 8) {
      return "Your password must be at least 8 characters";
    } else if (!_exlusiveSpecialCharAndNumberExpression.hasMatch(password)) {
      return "Include a special character or number in your password";
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
      return "Enter your phone number";
    } else if (!_phoneNumberExpression.hasMatch(phoneNumber)) {
      return "Enter a phone number like 081122223333";
    } else {
      return null;
    }
  }

  String? validateBusinessAddress(String? placeOfResidence) {
    if (placeOfResidence == null || placeOfResidence.isEmpty) {
      return "Enter your business address";
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
        "name" : fullName,
        "email" : email,
        "dateOfBirth" : dob,
        "phoneNumber" : phone,
        "businessAddress" : placeOfResidence,
        "aboutUs" : "",
        "visionMission" : "",
        "profileUrl" : "",
        "type" : "",
        "hasVisitedProfilePage" : false,
        "hasUploadedProfilePicture" : false,
        "hasEditedAboutMe" : false,
        "dateJoined" : DateTime.now(),
      };
      await _firebaseFirestore.collection(Collections.employers.name).doc(credential.user?.uid ?? "").set(data);
      registeredUserProfile = UserProfileModel(
        name: fullName,
        dateOfBirth: dob,
        email: email,
        phoneNumber: phone,
        businessAddress: placeOfResidence,
        aboutUs: "",
        visionMission: "",
        profileUrl: "",
        type: "",
        hasVisitedProfilePage: false,
        hasUploadedProfilePicture: false,
        hasEditedAboutMe: false,
        dateJoined: DateTime.now()
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