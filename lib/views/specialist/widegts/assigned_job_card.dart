import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../data/models/assigned_job_model.dart';
import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../viewmodels/specialist_viewmodel.dart';

class AssignedJobCard extends StatefulWidget {
  final AssignedJobModel job;

  const AssignedJobCard({
    super.key,
    required this.job,
  });

  @override
  State<AssignedJobCard> createState() => _AssignedJobCardState();
}

class _AssignedJobCardState extends State<AssignedJobCard> {
  bool _isProcessing = false;

  Future<void> _refreshAssignedJobs() async {
    await context.read<SpecialistViewModel>().loadAssignedJobs();
  }

  Future<void> _showMessage(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleAcceptJob() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await context
          .read<SpecialistTasksViewModel>()
          .acceptSpecialistJob(widget.job.id);
      if (success) {
        await _refreshAssignedJobs();
        await _showMessage('Job accepted successfully.');
      } else {
        await _showMessage('Unable to accept the job.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<String?> _captureAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile == null) {
      return null;
    }

    final file = File(pickedFile.path);
    final response = await di.inspectorRepository.uploadImage(file);
    if (!response.success) {
      throw Exception('Photo upload failed.');
    }

    return response.data.url;
  }

  Future<void> _handleStartJob() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final imageUrl = await _captureAndUploadImage();
      if (imageUrl == null) {
        await _showMessage('A before photo is required to start the job.');
        return;
      }

      final success = await context
          .read<SpecialistTasksViewModel>()
          .startSpecialistJob(widget.job.id, imageUrl);

      if (success) {
        await _refreshAssignedJobs();
        await _showMessage('Job started successfully.');
      } else {
        await _showMessage('Unable to start the job.');
      }
    } catch (error) {
      await _showMessage('Start job failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleCancelJob() async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to cancel this job? A valid reason is required.',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Cancellation Reason',
                    hintText: 'Enter reason for cancellation...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Go Back'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a cancellation reason.')),
                  );
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Cancel Job'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      reasonController.dispose();
      return;
    }

    final reason = reasonController.text.trim();
    reasonController.dispose();

    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await context
          .read<SpecialistTasksViewModel>()
          .cancelSpecialistJob(widget.job.id, reason);
      if (success) {
        await _refreshAssignedJobs();
        await _showMessage('Job cancelled successfully.');
      } else {
        await _showMessage('Unable to cancel the job.');
      }
    } catch (error) {
      await _showMessage('Cancel job failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _handleCancelJob,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Cancel Job',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _handlePhotoUpload(bool isBeforePhoto) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final imageUrl = await _captureAndUploadImage();
      if (imageUrl == null) {
        return;
      }

      final tasksVm = context.read<SpecialistTasksViewModel>();
      final success = isBeforePhoto
          ? await tasksVm.uploadBeforePhotos(widget.job.id, [imageUrl])
          : await tasksVm.uploadAfterPhotos(widget.job.id, [imageUrl]);

      if (success) {
        await _refreshAssignedJobs();
        await _showMessage(
          isBeforePhoto
              ? 'Before photo uploaded successfully.'
              : 'After photo uploaded successfully.',
        );
      } else {
        await _showMessage('Unable to upload the photo.');
      }
    } catch (error) {
      await _showMessage('Upload failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleCompleteJob() async {
    final notesController = TextEditingController();
    String? afterPhotoUrl;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Complete Job'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Capture an after-service photo and add notes to complete this job.',
                    ),
                    const SizedBox(height: 12),
                    if (afterPhotoUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          afterPhotoUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'After photo attached',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            setDialogState(() {
                              _isProcessing = true;
                            });
                            final uploadedUrl = await _captureAndUploadImage();
                            if (uploadedUrl != null) {
                              setDialogState(() {
                                afterPhotoUrl = uploadedUrl;
                              });
                            }
                          } catch (error) {
                            await _showMessage('Upload failed: $error');
                          } finally {
                            setDialogState(() {
                              _isProcessing = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture After Photo'),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Specialist Notes',
                        hintText: 'Enter service notes',
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: afterPhotoUrl == null || _isProcessing
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        );
      },
    );

    if (afterPhotoUrl == null) {
      notesController.dispose();
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await context.read<SpecialistTasksViewModel>().completeSpecialistJob(
            widget.job.id,
            afterPhotoUrl!,
            notesController.text.trim(),
          );
      if (success) {
        await _refreshAssignedJobs();
        await _showMessage('Job completed successfully.');
      } else {
        await _showMessage('Unable to complete the job.');
      }
    } catch (error) {
      await _showMessage('Complete job failed: $error');
    } finally {
      notesController.dispose();
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Widget _buildActionButton() {
    final job = widget.job;
    final hasBeforePhotos = job.beforePhotos.isNotEmpty;
    final hasAfterPhotos = job.afterPhotos.isNotEmpty;

    if (_isProcessing) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget? primaryAction;

    if (job.isAssigned) {
      primaryAction = _PrimaryButton(
        text: 'Accept Job',
        onPressed: _handleAcceptJob,
      );
    } else if (job.isAccepted) {
      primaryAction = _PrimaryButton(
        text: 'Start Job',
        onPressed: _handleStartJob,
      );
    } else if (job.isInProgress) {
      if (!hasBeforePhotos) {
        primaryAction = _PrimaryButton(
          text: 'Upload Before Photo',
          onPressed: () => _handlePhotoUpload(true),
        );
      } else if (!hasAfterPhotos) {
        primaryAction = _PrimaryButton(
          text: 'Upload After Photo',
          onPressed: () => _handlePhotoUpload(false),
        );
      } else {
        primaryAction = _PrimaryButton(
          text: 'Complete Job',
          isSuccess: true,
          onPressed: _handleCompleteJob,
        );
      }
    } else if (job.isCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Completed',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else if (job.status == 'CANCELLED') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Cancelled',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (primaryAction != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          primaryAction,
          const SizedBox(height: 8),
          _buildCancelButton(),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 420;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardHighlight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.directions_car, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.vehicle.vehicleNumber,
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          job.addonService.name,
                          style: AppStyles.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _StatusChip(status: job.status),
                ],
              ),
              const SizedBox(height: 14),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InfoTile(
                        label: 'Customer',
                        value: job.user.name,
                        secondary: job.user.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoTile(
                        label: 'Vehicle',
                        value: '${job.vehicle.brand} ${job.vehicle.model}'.trim(),
                        secondary: job.vehicle.sizeCategory,
                      ),
                    ),
                  ],
                )
              else ...[
                _InfoTile(
                  label: 'Customer',
                  value: job.user.name,
                  secondary: job.user.phone,
                ),
                const SizedBox(height: 12),
                _InfoTile(
                  label: 'Vehicle',
                  value: '${job.vehicle.brand} ${job.vehicle.model}'.trim(),
                  secondary: job.vehicle.sizeCategory,
                ),
              ],
              const SizedBox(height: 12),
              _InfoTile(
                label: 'Location',
                value: job.locationLabel,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      label: 'Scheduled',
                      value: job.scheduledDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoTile(
                      label: 'Slot',
                      value:
                          '${job.scheduledSlotStart} - ${job.scheduledSlotEnd}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaPill(
                    icon: Icons.timer_outlined,
                    text:
                        '${job.addonService.estimatedDurationMinutes} mins',
                  ),
                  _MetaPill(
                    icon: Icons.photo_camera_outlined,
                    text: 'Before: ${job.beforePhotos.length}',
                  ),
                  _MetaPill(
                    icon: Icons.photo_outlined,
                    text: 'After: ${job.afterPhotos.length}',
                  ),
                ],
              ),
              if (job.specialistNotes != null &&
                  job.specialistNotes!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoTile(
                  label: 'Notes',
                  value: job.specialistNotes!,
                ),
              ],
              const SizedBox(height: 16),
              _buildActionButton(),
            ],
          ),
        );
      },
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSuccess;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSuccess ? AppColors.success : AppColors.primary,
          foregroundColor: isSuccess ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String? secondary;

  const _InfoTile({
    required this.label,
    required this.value,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not available' : value,
            style: AppStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (secondary != null && secondary!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              secondary!,
              style: AppStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color textColor;
    late final Color backgroundColor;

    switch (status) {
      case 'COMPLETED':
        textColor = AppColors.success;
        backgroundColor = AppColors.success.withOpacity(0.12);
        break;
      case 'IN_PROGRESS':
      case 'STARTED':
        textColor = AppColors.warning;
        backgroundColor = AppColors.warning.withOpacity(0.12);
        break;
      case 'ACCEPTED':
        textColor = AppColors.primary;
        backgroundColor = AppColors.primary.withOpacity(0.12);
        break;
      case 'CANCELLED':
        textColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.12);
        break;
      default:
        textColor = AppColors.textPrimary;
        backgroundColor = AppColors.backgroundLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
