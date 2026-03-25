import 'package:flutter/material.dart';
import '../../core/utils/snackbar_helper.dart';

class JobDetailsViewModel extends ChangeNotifier {
  String vehicleNumber = "TS 01 AB 1234";
  String customerName = "Rahul S.";
  String location = "Tower A, Slot 6";
  String phone = "9145679913";
  String status = "Pending";

  void callOwner() {
    debugPrint("Calling $phone");
    // later: integrate url_launcher
  }

  Future<void> uploadPhoto(BuildContext context) async {
    // Simulate photo upload
    await Future.delayed(const Duration(seconds: 1));

    // Update status
    status = "Completed";
    notifyListeners();

    // Show success notification
    if (context.mounted) {
      SnackbarHelper.showTopNotification(context);
    }
  }
}
