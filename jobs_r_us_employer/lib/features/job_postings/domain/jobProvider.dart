import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/job_postings/model/jobPostModel.dart';

enum JobStatus { retrieving, failed, unloaded, loaded, uploading, finished }
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

  AuthProvider? _authProvider;

  List<JobPostModel> allJobsList = [];
  List<JobPostModel> availableJobsList = [];
  List<JobPostModel> searchedJobsList = [];

  List<int> applicantMetricsList = [];

  JobStatus metricsStatus = JobStatus.unloaded;

  JobStatus jobStatus = JobStatus.unloaded;
  JobStatus searchStatus = JobStatus.unloaded;

  FirebaseException? jobError;
  FirebaseException? searchError;
  FirebaseException? metricsError;

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

  final _numbersOnlyExpression = RegExp(r'^[1-9][0-9]*$');

  void update(AuthProvider authProvider) async {
    if (authProvider.currentUser != null) {
      _authProvider = authProvider;
      getAllJobs();
    }
  }

  Future<void> getApplicantMetrics(List<JobPostModel> jobList) async {
    metricsStatus = JobStatus.retrieving;
    metricsError = null;
    notifyListeners();
    try {
      for (var job in jobList) {
        await _firebaseFirestore.collection("jobPosts").doc(job.id).collection("applications").count().get().then((value) {
          applicantMetricsList.add(value.count ?? 0);
        });
      }
      metricsStatus = JobStatus.finished;
      notifyListeners();
    } on FirebaseException catch (e) {
      metricsError = e;
      metricsStatus = JobStatus.failed;
      notifyListeners();
    }
  }

  Future<void> getAllJobs() async {
    jobStatus = JobStatus.retrieving;
    jobError = null;
    notifyListeners();
    try {
      _firebaseFirestore.collection("jobPosts").withConverter(fromFirestore: JobPostModel.fromFirestore, toFirestore: (jobPostModel, _) => jobPostModel.toFirestore()).where("employerId", isEqualTo: _authProvider?.currentUser?.uid ?? "").orderBy("datePosted", descending: true).get().then((collection) async {
        allJobsList = collection.docs.map((e) => e.data()).toList();
        availableJobsList = allJobsList.where((element) => element.isOpen).toList();
        await getApplicantMetrics(allJobsList);
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
      _firebaseFirestore.collection("jobPosts").withConverter(fromFirestore: JobPostModel.fromFirestore, toFirestore: (jobPostModel, _) => jobPostModel.toFirestore()).where("employerId", isEqualTo: _authProvider?.currentUser?.uid).orderBy(orderBy.name, descending: descending ?? true).get().then((collection) {
        allJobsList = collection.docs.map((e) => e.data()).toList();
        availableJobsList = allJobsList.where((element) => element.isOpen).toList();
        if (searchKey.isEmpty && type == JobType.all) {
          resetSearch();
          notifyListeners();
        } else {
          var jobs = collection.docs.map((e) => e.data()).toList();
          searchedJobsList = jobs.where((job) => job.title.toLowerCase().contains(searchKey.toLowerCase()) && job.type.toLowerCase().contains(type.type.toLowerCase())).toList();
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

  Future<bool> setJob(JobPostModel newJob, bool addToList) async {
    jobStatus = JobStatus.uploading;
    jobError = null;
    notifyListeners();
    try {
      await _firebaseFirestore.collection("jobPosts").doc(newJob.id).withConverter(fromFirestore: JobPostModel.fromFirestore, toFirestore: (job, _) => job.toFirestore()).set(newJob);
      if (addToList) {
        allJobsList.add(newJob);
      }
      jobStatus = JobStatus.finished;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      jobError = e;
      jobStatus = JobStatus.failed;
      notifyListeners();
      return false;
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

  String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return "Enter a job title";
    } else {
      return null;
    }
  }

  String? validateTag(String? tag) {
    if (tag == null || tag.isEmpty) {
      return "Enter a tag";
    } else {
      return null;
    }
  }

  String? validateSalary(String? salary) {
    if (salary == null || salary.isEmpty) {
      return "Enter a salary";
    } else if (!_numbersOnlyExpression.hasMatch(salary)) {
      return "Enter a salary like 1000000";
    } else {
      return null;
    }
  }

  String? validateHours(String? hours) {
    if (hours == null || hours.isEmpty) {
      return "Enter the working hours";
    } else if (!_numbersOnlyExpression.hasMatch(hours)) {
      return "Enter a working hour like 8 or 12";
    } else if (int.parse(hours) > 40) {
      return "Your working hours cannot exceed 40 hours";
    } else {
      return null;
    }
  }

  String? validateLocation(String? location) {
    if (location == null || location.isEmpty) {
      return "Enter the location of the job";
    }  else {
      return null;
    }
  }

  String? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return "Enter a description of the job";
    }  else {
      return null;
    }
  }

  String? validateRequirements(String? requirements) {
    if (requirements == null || requirements.isEmpty) {
      return "Enter the requirements for the job";
    }  else {
      return null;
    }
  }
}