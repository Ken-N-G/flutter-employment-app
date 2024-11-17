import 'package:cloud_firestore/cloud_firestore.dart';

class CareerModel {
  CareerModel({
    required this.id,
    required this.articleTitle,
    required this.dateUploaded,
    required this.author,
    required this.introduction,
    required this.bodyHeaders,
    required this.bodyContent
  });

  String id;
  String articleTitle;
  DateTime dateUploaded; 
  String author;
  String introduction;
  List<String> bodyHeaders;
  List<String> bodyContent;

  factory CareerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final data = snapshot.data();
      return CareerModel(
        id: data?['id'] ?? "",
        articleTitle: data?['articleTitle'] ?? "",
        dateUploaded: data?['dateUploaded'].toDate() ?? Timestamp.now(),
        author: data?['author'] ?? "",
        introduction: data?['introduction'] ?? "",
        bodyHeaders: data?['bodyHeaders'] is Iterable ? List.from(data?['bodyHeaders']) : [],
        bodyContent: data?['bodyContent'] is Iterable ? List.from(data?['bodyContent']) : [],
      );
    }

  CareerModel copyWith({
    String? id,
    String? articleTitle,
    DateTime? dateUploaded,
    String? author,
    String? introduction,
    List<String>? bodyHeaders,
    List<String>? bodyContent,
  }) {
    return CareerModel(
      id: id ?? this.id,
      articleTitle: articleTitle ?? this.articleTitle,
      dateUploaded: dateUploaded ?? this.dateUploaded,
      author: author ?? this.author,
      introduction: introduction ?? this.introduction,
      bodyHeaders: bodyHeaders ?? this.bodyHeaders,
      bodyContent: bodyContent ?? this.bodyContent,
    );
  }

  Map<String, Object?> toFirestore() => {
    "id" : id,
    "articleTitle" : articleTitle,
    "dateUploaded" : dateUploaded,
    "author" : author,
    "introduction" : introduction,
    "bodyHeaders" : bodyHeaders,
    "bodyContent" : bodyContent
  };
}