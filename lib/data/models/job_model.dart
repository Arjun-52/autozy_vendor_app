class JobModel {
  final String vehicle;
  final String name;
  final String location;
  final String phone;
  final JobStatus status;

  JobModel({
    required this.vehicle,
    required this.name,
    required this.location,
    required this.phone,
    this.status = JobStatus.pending,
  });

  bool get isCompleted => status == JobStatus.completed;
  bool get isCNA => status == JobStatus.cna;
}

enum JobStatus { pending, completed, cna }
