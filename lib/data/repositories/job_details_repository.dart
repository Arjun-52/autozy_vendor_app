import '../../core/interfaces/job_details_repository_interface.dart';

class JobDetailsRepository implements IJobDetailsRepository {
  @override
  Future<Map<String, String>> getJobDetails(String vehicleNumber) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Return exact same mock data as before
    return {
      'vehicleNumber': "TS 01 AB 1234",
      'customerName': "Rahul S.",
      'location': "Tower A, Slot 6",
      'phone': "9145679913",
      'status': "Pending",
    };
  }

  @override
  Future<bool> uploadPhoto(String vehicleNumber) async {
    // Simulate photo upload delay
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> callOwner(String phoneNumber) async {
    // Simulate call initiation
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
