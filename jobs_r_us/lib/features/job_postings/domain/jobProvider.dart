import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/data/collections.dart';
import 'package:jobs_r_us/features/job_postings/model/jobPostModel.dart';

enum JobStatus { retrieving, failed, unloaded, loaded }
enum JobSearchOrder { title, salary, datePosted }
enum JobType {
  all(""),
  partTime("Part"),
  fullTime("Full");
  final String type;
  const JobType(this.type);
}

class JobProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<JobPostModel> allJobsList = [];
  List<JobPostModel> availableJobsList = [];
  List<JobPostModel> searchedJobsList = [];

  JobStatus jobStatus = JobStatus.unloaded;
  JobStatus searchStatus = JobStatus.unloaded;

  FirebaseException? jobError;
  FirebaseException? searchError;

  JobPostModel selectedJob = JobPostModel(
    id: "", 
    employerId: "", 
    title: "",
    type: "", 
    tag: "", 
    location: "",
    isOpen: true,
    datePosted: DateTime.now(), 
    workingHours: 0, 
    salary: 0, 
    description: "", 
    requirements: "", 
    employerName: "",
    longitude: 0.0,
    latitude: 0.0
  );

  JobProvider() {
    getAllJobs();
  }

  Future<void> getAllJobs() async {
    if (jobStatus == JobStatus.retrieving){
      return;
    }
    jobStatus = JobStatus.retrieving;
    jobError = null;
    try {
      _firebaseFirestore.collection(Collections.jobPosts.name).orderBy("datePosted", descending: true).withConverter(fromFirestore: JobPostModel.fromFirestore, toFirestore: (jobPostModel, _) => jobPostModel.toFirestore()).get().then((collection) {
        allJobsList = collection.docs.map((e) => e.data()).toList();
        availableJobsList = allJobsList.where((element) => element.isOpen).toList();
        jobStatus = JobStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      jobError = e;
      jobStatus = JobStatus.failed;
      notifyListeners();
    } 
  }

  Future<void> getJobsWithQuery(String searchKey, JobSearchOrder orderBy, JobType type, bool? descending) async {
    searchStatus = JobStatus.retrieving;
    searchError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection(Collections.jobPosts.name).withConverter(fromFirestore: JobPostModel.fromFirestore, toFirestore: (jobPostModel, _) => jobPostModel.toFirestore()).orderBy(orderBy.name, descending: descending ?? true).get().then((collection) {
        allJobsList = collection.docs.map((e) => e.data()).toList();
        availableJobsList = allJobsList.where((element) => element.isOpen).toList();
        if (searchKey.isEmpty && type == JobType.all) {
          resetSearch();
          notifyListeners();
        } else {
          var jobs = collection.docs.map((e) => e.data()).toList();
          searchedJobsList = jobs.where((job) => job.title.toLowerCase().contains(searchKey.toLowerCase()) && job.type.toLowerCase().contains(type.type.toLowerCase()) && job.isOpen).toList();
          searchStatus = JobStatus.loaded;
          notifyListeners();
        }
      });
    } on FirebaseException catch (e) {
      jobError = e;
      searchStatus = JobStatus.failed;
      notifyListeners();
    } 
  }

  void resetSearch() {
    searchedJobsList = [];
    searchStatus = JobStatus.unloaded;
    notifyListeners();
  }

  void setSelectedJob(String jobId) {
    selectedJob = allJobsList.where((element) => element.id == jobId).first;
    notifyListeners();
  }
}