import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/career_materials/model/careerModel.dart';

enum CareerStatus { retrieving, failed, unloaded, loaded }

class CareerProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<CareerModel> careerArticles = [];
  List<CareerModel> searchedArticles = [];
  CareerModel selectedArticle = CareerModel(
    id: "",
    articleTitle: "", 
    dateUploaded: DateTime.now(), 
    author: "", 
    introduction: "", 
    bodyHeaders: [], 
    bodyContent: []
  );

  CareerStatus careerStatus = CareerStatus.unloaded;
  CareerStatus searchStatus = CareerStatus.unloaded;

  FirebaseException? careerError;
  FirebaseException? searchError;

  CareerProvider() {
    getAllArticles();
  }

  Future<void> getAllArticles() async {
    careerStatus = CareerStatus.retrieving;
    careerError = null;
    try {
      _firebaseFirestore.collection(Collections.articles.name).orderBy("dateUploaded", descending: true).withConverter(fromFirestore: CareerModel.fromFirestore, toFirestore: (article, _) => article.toFirestore()).get().then((collection) {
        careerArticles = collection.docs.map((e) => e.data()).toList();
        careerStatus = CareerStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      careerError = e;
      careerStatus = CareerStatus.failed;
      notifyListeners();
    } 
  }

  Future<void> getArticleWithQuery(String searchKey) async {
    if (searchStatus == CareerStatus.retrieving){
      return;
    }
    searchStatus = CareerStatus.retrieving;
    searchError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.articles.name).withConverter(fromFirestore: CareerModel.fromFirestore, toFirestore: (article, _) => article.toFirestore()).orderBy("dateUploaded", descending: true).get().then((collection) {
        careerArticles = collection.docs.map((e) => e.data()).toList();
        if (searchKey.isEmpty) {
          resetSearch();
          notifyListeners();
        } else {
          var jobs = collection.docs.map((e) => e.data()).toList();
          searchedArticles = jobs.where((job) => job.articleTitle.toLowerCase().contains(searchKey.toLowerCase())).toList();
          searchStatus = CareerStatus.loaded;
          notifyListeners();
        }
      });
    } on FirebaseException catch (e) {
      careerError = e;
      searchStatus = CareerStatus.failed;
      notifyListeners();
    } 
  }

  void resetSearch() {
    searchedArticles = [];
    searchStatus = CareerStatus.unloaded;
    notifyListeners();
  }

  void setSelectedArticle(String articleId) {
    selectedArticle = careerArticles.where((element) => element.id == articleId).first;
    notifyListeners();
  }
}