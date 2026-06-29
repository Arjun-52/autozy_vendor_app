import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../data/models/team_member.dart';
import '../../../core/utils/top_banner_2.dart';
import '../../../viewmodels/supervisor_viewmodel.dart';

class ReassignBottomSheet extends StatefulWidget {
  final TeamMember member;
  final BuildContext parentContext;
  final String? serviceRecordUuid;

  const ReassignBottomSheet({
    super.key,
    required this.member,
    required this.parentContext,
    this.serviceRecordUuid,
  });

  @override
  State<ReassignBottomSheet> createState() => _ReassignBottomSheetState();
}

class _ReassignBottomSheetState extends State<ReassignBottomSheet> {
  bool _isProcessing = false;

  Future<void> _handleReassignment(TeamMember targetDetailer) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final vm = Provider.of<SupervisorViewModel>(context, listen: false);

    bool overallSuccess = false;

    if (widget.serviceRecordUuid != null) {
      // Reassign single service record
      overallSuccess = await vm.reassignRecord(widget.serviceRecordUuid!, targetDetailer.id);
    } else {
      // Reassign all pending service records of widget.member
      final pendingRecords = vm.serviceRecords.where((r) =>
          r['detailer'] != null &&
          r['detailer']['id'] == widget.member.id &&
          r['status'].toString().toUpperCase() != 'COMPLETED'
      ).toList();

      if (pendingRecords.isEmpty) {
        if (mounted) {
          Navigator.pop(context);
          showTopBanner(
            widget.parentContext,
            message: "No pending jobs to reassign for ${widget.member.name}.",
          );
        }
        return;
      }

      int successCount = 0;
      for (var record in pendingRecords) {
        final recordId = record['id']?.toString();
        if (recordId != null) {
          final success = await vm.reassignRecord(recordId, targetDetailer.id);
          if (success) {
            successCount++;
          }
        }
      }
      overallSuccess = successCount > 0;
    }

    if (mounted) {
      Navigator.pop(context);
      if (overallSuccess) {
        final msg = widget.serviceRecordUuid != null
            ? "Job reassigned from ${widget.member.name} to ${targetDetailer.name}."
            : "Jobs reassigned from ${widget.member.name} to ${targetDetailer.name}.";
        showTopBanner(
          widget.parentContext,
          message: msg,
        );
      } else {
        final errorMsg = vm.reassignError ?? "Failed to reassign job(s).";
        showTopBanner(
          widget.parentContext,
          message: "Error: $errorMsg",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SupervisorViewModel>(context);
    
    // Filter out inspectors and the current member from potential reassign targets
    final detailers = vm.members.where((m) =>
        m.role.trim().toLowerCase() == 'detailer' &&
        m.id != widget.member.id
    ).toList();

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DRAG HANDLE
          Center(
            child: Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xff303030),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _isProcessing ? null : () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceRecordUuid != null
                          ? "Reassign Job from ${widget.member.name}"
                          : "Reassign Jobs from ${widget.member.name}",
                      style: AppStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000E08),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.serviceRecordUuid != null
                          ? "1 job • ${widget.member.tower}"
                          : "${widget.member.total - widget.member.completed} pending jobs • ${widget.member.tower}",
                      style: AppStyles.caption.copyWith(
                        color: const Color(0xff7E8392),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_isProcessing)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            )
          else ...[
            /// LABEL
            Text(
              "Select a team member to receive the jobs:",
              style: AppStyles.caption.copyWith(
                fontSize: 14,
                color: const Color(0xff7E8392),
              ),
            ),

            const SizedBox(height: 12),

            if (detailers.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "No other active detailers available.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              /// LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: detailers.length,
                itemBuilder: (_, index) {
                  final m = detailers[index];

                  final bgColor = m.status == "Warning"
                      ? const Color(0xFFFFF6E5)
                      : const Color(0xFFE9F8EF);

                  final iconColor = m.status == "Warning"
                      ? Colors.orange
                      : Colors.green;

                  return GestureDetector(
                    onTap: () => _handleReassignment(m),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF161616).withOpacity(0.12),
                            blurRadius: 13,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// ICON
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/images/profile-tick.svg',
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                  iconColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.name,
                                  style: AppStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${m.role}  •  ${m.tower}  •  ${m.completed}/${m.total}",
                                  style: AppStyles.caption.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
