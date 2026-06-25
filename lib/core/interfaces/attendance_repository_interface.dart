import '../../data/models/attendance_model.dart';

abstract class IAttendanceRepository {
  Future<AttendanceModel> markAttendance({required double latitude, required double longitude});
}
