import 'dart:io';
import 'package:autozy_vendor_app/views/specialist/widegts/job_details_sheet_.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/completed_task_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../data/models/specialist_job_model.dart';
import '../../../core/di/dependency_injection.dart';

import 'task_card_header.dart';

class TaskCard extends StatefulWidget {
  final SpecialistJobModel job;
  final int taskIndex;

  const TaskCard({
    super.key,
    required this.job,
    required this.taskIndex,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isUploading = false;

  void _showJobDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JobDetailsSheet(job: widget.job),
    );
  }

  Future<void> _handlePhotoUpload(BuildContext context, SpecialistTasksViewModel vm, bool isBefore) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(pickedFile.path);
      final response = await di.inspectorRepository.uploadImage(file);
      if (response.success) {
        final imageUrl = response.data.url;
        bool success;
        if (isBefore) {
          success = await vm.uploadBeforePhotos(widget.job.id, [imageUrl]);
        } else {
          success = await vm.uploadAfterPhotos(widget.job.id, [imageUrl]);
        }

        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${isBefore ? 'Before' : 'After'} photo uploaded successfully!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _handleStartJobFlow(BuildContext context, SpecialistTasksViewModel vm) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("A before photo is required to start the job.")),
        );
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(pickedFile.path);
      final response = await di.inspectorRepository.uploadImage(file);
      if (response.success) {
        final imageUrl = response.data.url;
        final success = await vm.startSpecialistJob(widget.job.id, imageUrl);
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Job started successfully!")),
          );
        }
      } else {
        throw Exception("Photo upload failed.");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Start job failed: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _handleCompleteJobFlow(BuildContext context, SpecialistTasksViewModel vm) async {
    final TextEditingController notesController = TextEditingController();
    String? afterPhotoUrl;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Complete Job"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Please capture an after-cleaning photo and enter notes to complete the job."),
                    const SizedBox(height: 12),
                    if (afterPhotoUrl != null) ...[
                      Image.network(afterPhotoUrl!, height: 120, width: double.infinity, fit: BoxFit.cover),
                      const SizedBox(height: 6),
                      const Text("Photo selected ✓", style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ] else ...[
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Capture After Photo"),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            setDialogState(() {
                              _isUploading = true;
                            });
                            try {
                              final file = File(pickedFile.path);
                              final response = await di.inspectorRepository.uploadImage(file);
                              if (response.success) {
                                setDialogState(() {
                                  afterPhotoUrl = response.data.url;
                                });
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Upload failed: $e")),
                              );
                            } finally {
                              setDialogState(() {
                                _isUploading = false;
                              });
                            }
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: "Specialist Notes",
                        hintText: "Enter service remarks...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: (afterPhotoUrl == null || _isUploading)
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text("Complete"),
                ),
              ],
            );
          },
        );
      },
    );

    if (afterPhotoUrl == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final success = await vm.completeSpecialistJob(widget.job.id, afterPhotoUrl!, notesController.text.trim());
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job completed successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Complete job failed: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SpecialistTasksViewModel>();
    final job = widget.job;

    if (job.status == "COMPLETED") {
      return CompletedTaskCard(task: job.toTask());
    }

    Widget actionButton;
    if (_isUploading) {
      actionButton = const Center(child: CircularProgressIndicator());
    } else if (job.status == "ASSIGNED") {
      actionButton = SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => vm.acceptSpecialistJob(job.id),
          child: const Text("Accept Job", style: AppStyles.buttonSmall),
        ),
      );
    } else if (job.status == "ACCEPTED") {
      actionButton = SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _handleStartJobFlow(context, vm),
          child: const Text("Start Job", style: AppStyles.buttonSmall),
        ),
      );
    } else if (job.status == "IN_PROGRESS" || job.status == "STARTED") {
      final hasBefore = job.beforePhotos != null && job.beforePhotos!.isNotEmpty;
      final hasAfter = job.afterPhotos != null && job.afterPhotos!.isNotEmpty;

      if (!hasBefore) {
        actionButton = SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt, color: AppColors.black),
            label: const Text("Upload Before Photo", style: AppStyles.buttonSmall),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _handlePhotoUpload(context, vm, true),
          ),
        );
      } else if (!hasAfter) {
        actionButton = SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt, color: AppColors.black),
            label: const Text("Upload After Photo", style: AppStyles.buttonSmall),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _handlePhotoUpload(context, vm, false),
          ),
        );
      } else {
        actionButton = SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _handleCompleteJobFlow(context, vm),
            child: const Text("Complete Job", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      }
    } else {
      actionButton = const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCardHeader(
            vehicle: job.vehicle.vehicleNumber,
            title: job.addonService.name,
            showTimer: (job.status == "IN_PROGRESS" || job.status == "STARTED"),
            onTap: () => _showJobDetails(context),
          ),
          const SizedBox(height: 8),
          Text(
            "Brand/Model: ${job.vehicle.brand} ${job.vehicle.model}",
            style: AppStyles.bodyMedium,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Customer: ${job.user.name}",
                style: AppStyles.caption,
              ),
              Text(
                "Phone: ${job.user.phone}",
                style: AppStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Scheduled: ${job.scheduledDate}",
                style: AppStyles.caption,
              ),
              Text(
                "Slot: ${job.scheduledSlotStart} - ${job.scheduledSlotEnd}",
                style: AppStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Status: ${job.status}",
            style: AppStyles.caption.copyWith(
              color: job.status == "COMPLETED" ? AppColors.success : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          actionButton,
        ],
      ),
    );
  }
}
