import 'package:flutter/material.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/interfaces/job_details_repository_interface.dart';

class JobDetailsViewModel extends ChangeNotifier {
  final IJobDetailsRepository _repository;

  JobDetailsViewModel(this._repository);

  // Job details - loaded from repository
  String vehicleNumber = "";
  String customerName = "";
  String location = "";
  String phone = "";
  String status = "";

  /// Load job details from repository
  Future<void> loadJobDetails(String vehicleNumber) async {
    try {
      final details = await _repository.getJobDetails(vehicleNumber);
      this.vehicleNumber = details['vehicleNumber'] ?? "";
      customerName = details['customerName'] ?? "";
      location = details['location'] ?? "";
      phone = details['phone'] ?? "";
      status = details['status'] ?? "";
      notifyListeners();
    } catch (e) {
      // Keep fallback values if repository fails
      this.vehicleNumber = vehicleNumber;
      customerName = "Rahul S.";
      location = "Tower A, Slot 6";
      phone = "9145679913";
      status = "Pending";
      notifyListeners();
    }
  }

  void callOwner() async {
    try {
      await _repository.callOwner(phone);
      debugPrint("Calling $phone");
      // later: integrate url_launcher
    } catch (e) {
      debugPrint("Failed to call owner: $e");
    }
  }

  Future<void> uploadPhoto(BuildContext context) async {
    try {
      final success = await _repository.uploadPhoto(vehicleNumber);
      if (success) {
        // Update status
        status = "Completed";
        notifyListeners();

        // Show success notification
        if (context.mounted) {
          SnackbarHelper.showTopNotification(context);
        }
      }
    } catch (e) {
      debugPrint("Failed to upload photo: $e");
    }
  }
}
