import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../data/models/team_member.dart';
import '../../../core/utils/top_banner_2.dart';

class ReassignBottomSheet extends StatefulWidget {
  final TeamMember member;
  final BuildContext parentContext;

  const ReassignBottomSheet({
    super.key,
    required this.member,
    required this.parentContext,
  });

  @override
  State<ReassignBottomSheet> createState() => _ReassignBottomSheetState();
}

class _ReassignBottomSheetState extends State<ReassignBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final mockMembers = [
      TeamMember(
        id: "1",
        name: "Sanjay P",
        role: "Detailer",
        tower: "Tower B",
        completed: 8,
        total: 35,
        status: "Active",
        phone: "+91 98765 43211",
      ),
      TeamMember(
        id: "2",
        name: "Deepak S",
        role: "Detailer",
        tower: "Tower D",
        completed: 3,
        total: 5,
        status: "Active",
        phone: "+91 98765 43212",
      ),
      TeamMember(
        id: "3",
        name: "Sanjay P",
        role: "Detailer",
        tower: "Tower B",
        completed: 16,
        total: 38,
        status: "Warning",
        phone: "+91 98765 43214",
      ),
    ];

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
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reassign Jobs from ${widget.member.name}",
                      style: AppStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000E08),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.member.total - widget.member.completed} pending jobs • ${widget.member.tower}",
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

          /// LABEL
          Text(
            "Select a team member to receive the jobs:",
            style: AppStyles.caption.copyWith(
              fontSize: 14,
              color: const Color(0xff7E8392),
            ),
          ),

          const SizedBox(height: 12),

          /// LIST
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockMembers.length,
            itemBuilder: (_, index) {
              final m = mockMembers[index];

              final bgColor = m.status == "Warning"
                  ? const Color(0xFFFFF6E5)
                  : const Color(0xFFE9F8EF);

              final iconColor = m.status == "Warning"
                  ? Colors.orange
                  : Colors.green;

              return GestureDetector(
                onTap: () {
                  // Close bottom sheet first
                  Navigator.pop(context);

                  // Show banner using parent context (safe from bottom sheet context issues)
                  showTopBanner(
                    widget.parentContext,
                    message:
                        "5 jobs reassigned from ${widget.member.name} to ${m.name}.",
                  );
                },
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

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
