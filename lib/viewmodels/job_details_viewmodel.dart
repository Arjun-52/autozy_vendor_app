import 'package:flutter/material.dart';

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
}
