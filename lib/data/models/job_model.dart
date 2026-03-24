class JobModel {
  final String vehicle;
  final String name;
  final String location;
  bool isCompleted;

  JobModel({
    required this.vehicle,
    required this.name,
    required this.location,
    this.isCompleted = false,
  });
}
