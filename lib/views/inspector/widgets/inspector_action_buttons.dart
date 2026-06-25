import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/top_banner.dart';

class InspectorActionButtons extends StatelessWidget {
  final int photoCount;
  final VoidCallback onApprove;
  final VoidCallback onFlag;
  final VoidCallback onTakePhoto;
  final bool isUploading;
  final List<String> imageUrls;

  const InspectorActionButtons({
    super.key,
    required this.photoCount,
    required this.onApprove,
    required this.onFlag,
    required this.onTakePhoto,
    required this.imageUrls,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TAKE PHOTO
        GestureDetector(
          onTap: isUploading ? null : onTakePhoto,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF636363).withValues(alpha: 0.16),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isUploading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.textPrimary,
                      strokeWidth: 2,
                    ),
                  )
                else ...[
                  SvgPicture.asset(
                    "assets/images/camera.svg",
                    colorFilter: const ColorFilter.mode(
                      AppColors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text("Take Photo ($photoCount)", style: AppStyles.bodyMedium),
                ],
              ],
            ),
          ),
        ),

        if (imageUrls.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final url = imageUrls[index];
                final isLocal = !url.startsWith('http') && File(url).existsSync();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrls: imageUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade100,
                      child: isLocal
                          ? Image.file(
                              File(url),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey, size: 20),
                            )
                          : Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                if (File(url).existsSync()) {
                                  return Image.file(
                                    File(url),
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) => const Icon(Icons.broken_image, color: Colors.grey, size: 20),
                                  );
                                }
                                return const Icon(Icons.broken_image, color: Colors.grey, size: 20);
                              },
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.md),

        /// APPROVE + FLAG
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onApprove,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),

                        decoration: const BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text("Approve", style: AppStyles.buttonSmall),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: GestureDetector(
                onTap: onFlag,
                child: Container(
                  height: 40,
                  width: 145.5,

                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/flag.svg",
                        height: 16,
                        width: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColors.error,
                          BlendMode.srcIn,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Flag",
                        style: TextStyle(
                          color: Color(0xffFF383C),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final url = widget.imageUrls[index];
              final isLocal = !url.startsWith('http') && File(url).existsSync();
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: isLocal
                      ? Image.file(
                          File(url),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white, size: 50),
                        )
                      : Image.network(
                          url,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            if (File(url).existsSync()) {
                              return Image.file(
                                File(url),
                                fit: BoxFit.contain,
                              );
                            }
                            return const Icon(Icons.broken_image, color: Colors.white, size: 50);
                          },
                        ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "${_currentIndex + 1} / ${widget.imageUrls.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
