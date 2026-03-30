class AlertModel {
  final String title;
  final String time;
  final String type; // idle / fraud / success

  AlertModel({required this.title, required this.time, required this.type});
}
