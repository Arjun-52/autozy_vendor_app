import 'package:flutter/material.dart';
import '../../data/models/job_model.dart';

class DashboardViewModel extends ChangeNotifier {
  List<JobModel> _jobs = [];
  void undoCNA(int index) {
    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: JobStatus.pending,
    );

    notifyListeners();
  }

  List<JobModel> get jobs => List.unmodifiable(_jobs);

  void loadJobs() {
    _jobs = [
      JobModel(
        vehicle: "TS 01 AB 1234",
        name: "Rahul S.",
        location: "Tower A, Slot 6",
        phone: "+91 98765 43210",
        status: JobStatus.pending,
      ),
      JobModel(
        vehicle: "MH 03 CD 5678",
        name: "Priya N.",
        location: "Tower B, Slot 5",
        phone: "+91 87654 32109",
        status: JobStatus.pending,
      ),
      JobModel(
        vehicle: "MH 04 EF 9012",
        name: "Amit K.",
        location: "Tower B, Slot 8",
        phone: "+91 76543 21098",
        status: JobStatus.pending,
      ),
    ];
    notifyListeners();
  }

  bool markJobCompleted(int index) {
    if (index < 0 || index >= _jobs.length) {
      return false;
    }

    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: JobStatus.completed,
    );
    notifyListeners();
    return true;
  }

  bool markCNA(int index) {
    if (index < 0 || index >= _jobs.length) {
      return false;
    }

    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: JobStatus.cna,
    );
    notifyListeners();
    return true;
  }

  bool undoJob(int index) {
    if (index < 0 || index >= _jobs.length) {
      return false;
    }

    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: JobStatus.pending,
    );
    notifyListeners();
    return true;
  }

  JobModel? getJob(int index) {
    if (index < 0 || index >= _jobs.length) {
      return null;
    }
    return _jobs[index];
  }
}
