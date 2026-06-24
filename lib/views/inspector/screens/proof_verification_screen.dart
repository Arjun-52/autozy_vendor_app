import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/top_banner.dart';
import '../../../data/models/inspection_model.dart';
import '../../../viewmodels/inspector_viewmodel.dart';

class ProofVerificationScreen extends StatefulWidget {
  final InspectionModel inspection;

  const ProofVerificationScreen({
    super.key,
    required this.inspection,
  });

  @override
  State<ProofVerificationScreen> createState() => _ProofVerificationScreenState();
}

class _ProofVerificationScreenState extends State<ProofVerificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _commentController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _remarksController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _openFullScreenImage(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageUrl: url, title: title),
      ),
    );
  }

  Future<void> _handleUpload(String type) async {
    final vm = context.read<InspectorViewModel>();
    final currentInspection = vm.pendingVerifications.firstWhere(
      (element) => element.id == widget.inspection.id,
      orElse: () => vm.inspections.firstWhere(
        (element) => element.id == widget.inspection.id,
        orElse: () => widget.inspection,
      ),
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Photo from Camera'),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.read<InspectorViewModel>().uploadProofPhoto(
                  widget.inspection.id,
                  type,
                  ImageSource.camera,
                  fallbackInspection: currentInspection,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.read<InspectorViewModel>().uploadProofPhoto(
                  widget.inspection.id,
                  type,
                  ImageSource.gallery,
                  fallbackInspection: currentInspection,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(InspectorViewModel vm) {
    final reasonController = TextEditingController();
    final rejectFormKey = GlobalKey<FormState>();
    final List<String> rejectSuggestions = [
      'Photo blurry',
      'Vehicle parked incorrectly',
      'Incomplete cleaning',
      'Customer unavailable',
      'Vehicle not found',
      'Wrong vehicle',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: AppColors.error),
                SizedBox(width: 8),
                Text('Reject Verification'),
              ],
            ),
            content: Form(
              key: rejectFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please specify the mandatory reason for rejecting this service proof.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Rejection Reason *',
                        hintText: 'e.g. Quality check failed: water marks remaining',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Rejection reason is mandatory';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Suggestions (Tap to use):',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: rejectSuggestions.map((suggestion) => ActionChip(
                        label: Text(suggestion, style: const TextStyle(fontSize: 11)),
                        backgroundColor: Colors.grey.shade100,
                        onPressed: () {
                          setStateDialog(() {
                            reasonController.text = suggestion;
                          });
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Optional remarks can be added in the main remarks section.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (rejectFormKey.currentState!.validate()) {
                    final reason = reasonController.text.trim();
                    final remarks = _remarksController.text.trim();
                    Navigator.pop(dialogCtx);

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    final currentInspection = vm.pendingVerifications.firstWhere(
                      (element) => element.id == widget.inspection.id,
                      orElse: () => vm.inspections.firstWhere(
                        (element) => element.id == widget.inspection.id,
                        orElse: () => widget.inspection,
                      ),
                    );

                    await vm.rejectVerification(
                      widget.inspection.id,
                      reason,
                      remarks: remarks,
                      fallbackInspection: currentInspection,
                    );

                    // Pop loading indicator
                    if (mounted) Navigator.pop(context);

                    if (vm.errorMessage != null) {
                      if (mounted) TopBanner(context, vm.errorMessage!);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Service proof rejected successfully')),
                        );
                        Navigator.pop(context); // Go back to dashboard
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Reject', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleApprove(InspectorViewModel vm) async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Approve Proof'),
        content: const Text('Are you sure you want to approve this service proof?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              final currentInspection = vm.pendingVerifications.firstWhere(
                (element) => element.id == widget.inspection.id,
                orElse: () => vm.inspections.firstWhere(
                  (element) => element.id == widget.inspection.id,
                  orElse: () => widget.inspection,
                ),
              );

              await vm.approveVerification(
                widget.inspection.id,
                remarks: _commentController.text.trim().isNotEmpty
                    ? _commentController.text.trim()
                    : _remarksController.text.trim(),
                fallbackInspection: currentInspection,
              );

              // Pop loading
              if (mounted) Navigator.pop(context);

              if (vm.errorMessage != null) {
                if (mounted) TopBanner(context, vm.errorMessage!);
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service proof approved and verified')),
                  );
                  Navigator.pop(context); // Go back to dashboard
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoContainer(String type, List<InspectionPhoto> photos, bool isUploading, InspectorViewModel vm) {
    final typePhotos = photos.where((p) => p.type.toUpperCase() == type.toUpperCase()).toList();
    final localPhotos = vm.getLocalProofPhotos(widget.inspection.id);
    final localPath = localPhotos[type];

    if (kDebugMode) {
      print('--- _buildPhotoContainer Debug Log ---');
      print('Type: $type');
      print('Local Path: $localPath');
      if (localPath != null && localPath.isNotEmpty) {
        final fileExists = File(localPath).existsSync();
        print('Local File Exists: $fileExists');
      }
      print('Network photos count: ${typePhotos.length}');
      print('--------------------------------------');
    }

    Widget imageWidget;
    bool hasImage = false;
    String? imageUrlToDisplay;

    if (localPath != null && localPath.isNotEmpty && File(localPath).existsSync()) {
      hasImage = true;
      imageWidget = Image.file(
        File(localPath),
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) {
          if (kDebugMode) {
            print('Error rendering local Image.file: $err');
          }
          return Container(
            color: Colors.grey.shade100,
            child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
          );
        },
      );
    } else if (typePhotos.isNotEmpty) {
      hasImage = true;
      final photo = typePhotos.first;
      imageUrlToDisplay = photo.url;
      imageWidget = Image.network(
        photo.url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade100,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print('Error loading network image: $error');
          }
          // Fallback if URL is actually a local path or invalid network url
          if (photo.url.startsWith('/') || photo.url.contains(':') || !photo.url.startsWith('http')) {
            return Image.file(
              File(photo.url),
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, st) => Container(
                color: Colors.grey.shade100,
                child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            );
          }
          return Container(
            color: Colors.grey.shade100,
            child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
          );
        },
      );
    } else {
      imageWidget = const SizedBox.shrink();
    }

    if (!hasImage) {
      // Show upload placeholder when no image is selected/exists
      return GestureDetector(
        onTap: () => _handleUpload(type),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.values[1], // Dashed border simulated using border + padding
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Upload ${type.toUpperCase() == 'BEFORE' ? 'Before' : 'After'} Photo',
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                'Camera or Gallery support',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    // Display image preview
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (localPath != null && localPath.isNotEmpty) {
              _openFullScreenImage(
                context,
                localPath,
                '${type.toUpperCase() == 'BEFORE' ? 'Before' : 'After'} Service Photo (Local)',
              );
            } else if (imageUrlToDisplay != null) {
              _openFullScreenImage(
                context,
                imageUrlToDisplay,
                '${type.toUpperCase() == 'BEFORE' ? 'Before' : 'After'} Service Photo',
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: imageWidget,
            ),
          ),
        ),
        if (isUploading)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 8,
          right: 8,
          child: FloatingActionButton.small(
            onPressed: () => _handleUpload(type),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            child: const Icon(Icons.edit),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type.toUpperCase() == 'BEFORE' ? 'Before Service' : 'After Service',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModel>();
    
    // Find current state of the inspection (to support updating UI live)
    final currentInspection = vm.pendingVerifications.firstWhere(
      (element) => element.id == widget.inspection.id,
      orElse: () => vm.inspections.firstWhere(
        (element) => element.id == widget.inspection.id,
        orElse: () => widget.inspection,
      ),
    );

    final photos = currentInspection.photos ?? [];
    final beforePhotos = photos.where((p) => p.type.toUpperCase() == 'BEFORE').toList();
    final afterPhotos = photos.where((p) => p.type.toUpperCase() == 'AFTER').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Proof Verification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SERVICE INFORMATION CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // VEHICLE NUMBER styled like plate
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F5),
                              border: Border.all(color: Colors.grey.shade400, width: 1.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              currentInspection.vehicle,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: currentInspection.status == InspectionStatus.verified
                                  ? AppColors.onlineBg.withOpacity(0.5)
                                  : currentInspection.status == InspectionStatus.rejected
                                      ? Colors.red.shade50
                                      : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentInspection.status == InspectionStatus.verified
                                  ? 'Verified'
                                  : currentInspection.status == InspectionStatus.rejected
                                      ? 'Rejected'
                                      : 'Pending Verification',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: currentInspection.status == InspectionStatus.verified
                                    ? AppColors.success
                                    : currentInspection.status == InspectionStatus.rejected
                                        ? Colors.red
                                        : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            currentInspection.vehicleName ?? 'Mercedes C-Class',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      // Key info fields
                      _buildInfoRow(Icons.person_outline, 'Customer', currentInspection.customerName ?? 'Rohit A.'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.build_circle_outlined, 'Service', currentInspection.serviceType ?? 'Premium Polish & Shine'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_today_outlined, 'Service Date', currentInspection.serviceDate ?? '2026-06-11'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.assignment_ind_outlined, 'Specialist', currentInspection.assignedSpecialist ?? 'John Specialist'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.location_on_outlined, 'Location', currentInspection.location),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // PHOTOS SECTION TITLE
                const Text("Proof Images Comparison", style: AppStyles.sectionTitle),
                const SizedBox(height: 8),

                // PHOTO VIEWERS TABS AND CONTENT
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Before'),
                      Tab(text: 'After'),
                      Tab(text: 'Side-by-Side'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // PHOTO PANELS
                SizedBox(
                  height: 250,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(), // Prevent conflict with pinch-to-zoom gestures
                    children: [
                      // BEFORE TAB
                      _buildPhotoContainer('BEFORE', photos, vm.isUploadingImage && vm.uploadingInspectionId == widget.inspection.id, vm),
                      // AFTER TAB
                      _buildPhotoContainer('AFTER', photos, vm.isUploadingImage && vm.uploadingInspectionId == widget.inspection.id, vm),
                      // COMPARE SIDE-BY-SIDE TAB
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(child: _buildPhotoContainer('BEFORE', photos, vm.isUploadingImage && vm.uploadingInspectionId == widget.inspection.id, vm)),
                                const SizedBox(height: 4),
                                const Text('Before Service', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(child: _buildPhotoContainer('AFTER', photos, vm.isUploadingImage && vm.uploadingInspectionId == widget.inspection.id, vm)),
                                const SizedBox(height: 4),
                                const Text('After Service', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),

                // STAKEHOLDER NOTES SIDE-BY-SIDE
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          border: Border.all(color: Colors.teal.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.build_circle_outlined, size: 16, color: Colors.teal),
                                SizedBox(width: 6),
                                Text('Detailer Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentInspection.detailerNotes ?? 'No detailer notes',
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.chat_bubble_outline, size: 16, color: Colors.blue),
                                SizedBox(width: 6),
                                Text('Customer Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentInspection.customerNotes ?? 'No customer notes',
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ADD COMMENT FIELD
                const Text("Add Comment", style: AppStyles.sectionTitle),
                const SizedBox(height: 8),
                const Text(
                  'Suggestions (Tap to use):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    'Vehicle parked incorrectly',
                    'Customer unavailable',
                    'Photo blurry',
                    'Vehicle not found',
                    'Incomplete cleaning',
                    'Wrong vehicle',
                  ].map((suggestion) => ActionChip(
                    label: Text(suggestion, style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.grey.shade100,
                    onPressed: () {
                      setState(() {
                        _commentController.text = suggestion;
                      });
                    },
                  )).toList(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _commentController,
                  maxLines: 2,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Enter observations, feedback, or quality concerns...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (vm.isLoading || _commentController.text.trim().isEmpty)
                        ? null
                        : () async {
                            final text = _commentController.text.trim();
                            await vm.addComment(
                              currentInspection.id,
                              text,
                              fallbackInspection: currentInspection,
                            );
                            if (vm.errorMessage != null) {
                              if (mounted) TopBanner(context, vm.errorMessage!);
                            } else {
                              _commentController.clear();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Comment added successfully.')),
                                );
                              }
                            }
                          },
                    icon: vm.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                            ),
                          )
                        : const Icon(Icons.send, size: 16, color: Colors.black),
                    label: Text(
                      vm.isLoading ? 'Saving...' : 'Save Comment',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // CHRONOLOGICAL NOTES & COMMENTS TIMELINE
                const Text("Chronological Notes & Comments Timeline", style: AppStyles.sectionTitle),
                const SizedBox(height: 12),
                _buildTimelineList(currentInspection),
                const SizedBox(height: 20),

                // ACTIONS BUTTON ROW
                if (currentInspection.status == InspectionStatus.pendingVerification)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: vm.isLoading ? null : () => _showRejectDialog(vm),
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text("Reject Proof", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: vm.isLoading
                                ? null
                                : () {
                                    final localPhotos = vm.getLocalProofPhotos(widget.inspection.id);
                                    final selectedImagePathBefore = localPhotos['BEFORE'] ?? '';
                                    final selectedImagePathAfter = localPhotos['AFTER'] ?? '';
                                    final selectedImagePath = selectedImagePathBefore.isNotEmpty 
                                        ? selectedImagePathBefore 
                                        : selectedImagePathAfter;

                                    final uploadedImageUrlBefore = beforePhotos.isNotEmpty ? beforePhotos.first.url : '';
                                    final uploadedImageUrlAfter = afterPhotos.isNotEmpty ? afterPhotos.first.url : '';
                                    final uploadedImageUrl = uploadedImageUrlBefore.isNotEmpty 
                                        ? uploadedImageUrlBefore 
                                        : uploadedImageUrlAfter;

                                    print('Selected image path: $selectedImagePath');
                                    print('Uploaded image URL: $uploadedImageUrl');
                                    print('Comment text: ${_commentController.text}');
                                    print('Approval validation running');

                                    if (vm.isUploadingImage) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Upload is in progress. Please wait for the upload to complete.'),
                                        ),
                                      );
                                      return;
                                    }

                                    final hasBefore = beforePhotos.isNotEmpty || (selectedImagePathBefore.isNotEmpty && File(selectedImagePathBefore).existsSync());
                                    final hasAfter = afterPhotos.isNotEmpty || (selectedImagePathAfter.isNotEmpty && File(selectedImagePathAfter).existsSync());

                                    if (!hasBefore || !hasAfter) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please upload photo before approving vehicle'),
                                        ),
                                      );
                                      return;
                                    }

                                    _handleApprove(vm);
                                  },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text("Approve Proof", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineList(InspectionModel currentInspection) {
    final List<TimelineItem> timelineItems = [];

    // Add Customer Notes
    if (currentInspection.customerNotes != null && currentInspection.customerNotes!.isNotEmpty) {
      timelineItems.add(TimelineItem(
        userName: currentInspection.customerName ?? 'Customer',
        role: 'Customer',
        content: currentInspection.customerNotes!,
        timestamp: '2026-06-11 10:00:00', // Baseline date
        icon: Icons.person,
        color: Colors.blue,
      ));
    }

    // Add Detailer Notes
    if (currentInspection.detailerNotes != null && currentInspection.detailerNotes!.isNotEmpty) {
      timelineItems.add(TimelineItem(
        userName: currentInspection.assignedSpecialist ?? 'Specialist',
        role: 'Detailer',
        content: currentInspection.detailerNotes!,
        timestamp: '2026-06-11 11:00:00', // Baseline date
        icon: Icons.build_circle_outlined,
        color: Colors.teal,
      ));
    }

    // Add Remarks
    if (currentInspection.remarks != null) {
      for (final remark in currentInspection.remarks!) {
        timelineItems.add(TimelineItem(
          userName: remark.userName,
          role: remark.role,
          content: remark.comment,
          timestamp: remark.createdAt,
          icon: remark.role.toUpperCase() == 'INSPECTOR' ? Icons.verified_user : Icons.chat_bubble_outline,
          color: remark.role.toUpperCase() == 'INSPECTOR' ? Colors.green : Colors.deepPurple,
        ));
      }
    }

    // Add Verification History items
    if (currentInspection.verificationHistory != null) {
      for (final hist in currentInspection.verificationHistory!) {
        final hasDuplicate = timelineItems.any((e) => e.content == hist.remarks && e.role == 'Verifier');
        if (!hasDuplicate) {
          timelineItems.add(TimelineItem(
            userName: hist.verifiedBy,
            role: 'Verifier',
            content: hist.remarks,
            timestamp: hist.verificationDate,
            icon: hist.status == 'Verified' ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: hist.status == 'Verified' ? Colors.green : Colors.red,
          ));
        }
      }
    }

    // Sort timeline items (latest first)
    timelineItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (timelineItems.isEmpty) {
      return const Text("No comments or notes available yet.", style: TextStyle(color: Colors.grey));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timelineItems.length,
      itemBuilder: (context, index) {
        final item = timelineItems[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: item.color, width: 2),
                  ),
                  child: Icon(item.icon, size: 16, color: item.color),
                ),
                if (index < timelineItems.length - 1)
                  Container(
                    width: 2,
                    height: 55,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.userName} (${item.role})',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: item.color),
                        ),
                        Text(
                          item.timestamp.split('.')[0],
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.content,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class TimelineItem {
  final String userName;
  final String role;
  final String content;
  final String timestamp;
  final IconData icon;
  final Color color;

  TimelineItem({
    required this.userName,
    required this.role,
    required this.content,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          maxScale: 4.0,
          minScale: 1.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            },
            errorBuilder: (context, error, stackTrace) {
              if (imageUrl.startsWith('/') || imageUrl.contains(':') || !imageUrl.startsWith('http')) {
                return Image.file(
                  File(imageUrl),
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, st) => const Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
              return const Center(
                child: Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
