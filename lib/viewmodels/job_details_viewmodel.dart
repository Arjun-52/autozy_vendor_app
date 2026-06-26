import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/interfaces/job_details_repository_interface.dart';

class JobDetailsViewModel extends ChangeNotifier {
  final IJobDetailsRepository _repository;

  JobDetailsViewModel(this._repository);

  // Loading/error states
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Cached ID to prevent duplicate calls
  String? _lastLoadedJobId;

  // Job details
  String vehicleNumber = "";
  String customerName = "";
  String location = "";
  String phone = "";
  String status = "";
  String? vehicleImage = "";

  /// Load job details from repository
  Future<void> loadJobDetails(String jobId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _lastLoadedJobId == jobId) {
      // Prevent duplicate API calls if details for this job are already loaded
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final details = await _repository.getJobDetails(jobId);
      vehicleNumber = details['vehicleNumber'] ?? "";
      customerName = details['customerName'] ?? "";
      location = details['location'] ?? "";
      phone = details['phone'] ?? "";
      status = details['status'] ?? "";
      vehicleImage = details['vehicleImage'] ?? "";
      _lastLoadedJobId = jobId;
    } catch (e) {
      _errorMessage = "Failed to load job details: $e";
      
      // Keep fallback/passed values if repository fails
      vehicleNumber = jobId;
      customerName = "Rahul S.";
      location = "Tower A, Slot 6";
      phone = "9145679913";
      status = "Pending";
      vehicleImage = "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void callOwner() async {
    if (phone.isEmpty) return;
    try {
      final Uri url = Uri.parse('tel:$phone');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $url");
      }
      await _repository.callOwner(phone);
      debugPrint("Calling $phone");
    } catch (e) {
      debugPrint("Failed to call owner: $e");
    }
  }

  Future<void> uploadPhoto(BuildContext context) async {
    try {
      final success = await _repository.uploadPhoto(vehicleNumber);
      if (success) {
        status = "Completed";
        notifyListeners();

        if (context.mounted) {
          SnackbarHelper.showTopNotification(context);
        }
      }
    } catch (e) {
      debugPrint("Failed to upload photo: $e");
    }
  }
  
  void clearCache() {
    _lastLoadedJobId = null;
  }
}
