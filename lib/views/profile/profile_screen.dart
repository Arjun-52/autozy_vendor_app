import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/attendance_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 500,
        maxHeight: 500,
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Gallery permission denied";
      });
      return;
    }

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final file = File(pickedFile.path);
      final response = await di.inspectorRepository.uploadImage(file);
      if (response.success) {
        final imageUrl = response.data.url;
        ApiClient().setProfilePictureUrl(imageUrl);
        setState(() {
          _successMessage = "Profile picture updated successfully!";
        });
      } else {
        setState(() {
          _errorMessage = "Upload failed: API error";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Upload failed: $e";
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profilePicUrl = ApiClient().profilePictureUrl;
    final staffRole = ApiClient().staffRole ?? "Vendor Staff";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text("My Profile", style: AppStyles.subHeading),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: profilePicUrl != null && profilePicUrl.isNotEmpty
                            ? Image.network(
                                profilePicUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
                              )
                            : _buildFallbackAvatar(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _isUploading ? null : _pickAndUploadImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: _isUploading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                                  ),
                                )
                              : const Icon(Icons.camera_alt, color: AppColors.black, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Text(
                "Autozy Staff",
                style: AppStyles.heading.copyWith(fontSize: 22),
              ),
              Text(
                staffRole.toUpperCase(),
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              if (_successMessage != null)
                Text(
                  _successMessage!,
                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                ),

              // Attendance Section
              Consumer<AttendanceViewModel>(
                builder: (context, attendanceVm, child) {
                  final isCheckedIn = attendanceVm.attendance != null;
                  final checkInTime = isCheckedIn ? _formatTime(attendanceVm.attendance!.checkIn) : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Staff Attendance",
                        style: AppStyles.sectionTitle,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isCheckedIn ? "Status: Checked In" : "Status: Not Clocked In",
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (isCheckedIn && checkInTime != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        "Time: $checkInTime",
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isCheckedIn ? Colors.green.shade50 : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: isCheckedIn ? Colors.green.shade200 : Colors.orange.shade200),
                                  ),
                                  child: Text(
                                    isCheckedIn ? "PRESENT" : "ABSENT",
                                    style: TextStyle(
                                      color: isCheckedIn ? Colors.green : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: (attendanceVm.isLoading || isCheckedIn)
                                    ? null
                                    : () async {
                                        await attendanceVm.markAttendance();
                                        if (context.mounted) {
                                          if (attendanceVm.errorMessage != null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(attendanceVm.errorMessage!),
                                                backgroundColor: AppColors.error,
                                              ),
                                            );
                                          } else if (attendanceVm.successMessage != null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(attendanceVm.successMessage!),
                                                backgroundColor: AppColors.success,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCheckedIn ? AppColors.greyLight : AppColors.primary,
                                  foregroundColor: isCheckedIn ? AppColors.textSecondary : AppColors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor: isCheckedIn ? Colors.green.shade100 : AppColors.greyLight,
                                ),
                                icon: attendanceVm.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                                        ),
                                      )
                                    : Icon(isCheckedIn ? Icons.check_circle : Icons.login),
                                label: Text(
                                  attendanceVm.isLoading
                                      ? "Processing..."
                                      : isCheckedIn
                                          ? "Checked In"
                                          : "Clock In",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ApiClient().clearToken();
                    ApiClient().clearRefreshToken();
                    context.go('/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.shade200),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? checkInStr) {
    if (checkInStr == null || checkInStr.isEmpty) return '--:--';
    try {
      final dateTime = DateTime.parse(checkInStr).toLocal();
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '--:--';
    }
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: AppColors.backgroundLight,
      child: const Icon(
        Icons.person,
        size: 60,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
