abstract class IJobDetailsRepository {
  Future<Map<String, String>> getJobDetails(String vehicleNumber);
  Future<bool> uploadPhoto(String vehicleNumber);
  Future<bool> callOwner(String phoneNumber);
}
