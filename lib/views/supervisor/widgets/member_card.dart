import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/models/team_member.dart';
import 'reassign_bottom_sheet.dart';

class MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String tower;
  final String status;
  final int completed;
  final int total;

  const MemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.tower,
    required this.status,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    double progress = completed / total;

    final isActive = status == "Active";
    final statusColor = isActive
        ? const Color(0xff008847)
        : const Color(0xffFFA500);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withOpacity(0.12),
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    "assets/images/profile-tick.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// NAME  DETAILS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff7E8392),
                        ),
                      ),

                      const SizedBox(width: 6),

                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xff7E8392),
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        tower,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff7E8392),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.8)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress: $completed/$total",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff7E8392),
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xffE9E9E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _actionButton("assets/images/call.svg", "Call", () {
                  // TODO: Add call functionality
                }),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _actionButton(
                  "assets/images/workFlow.svg",
                  "Reassign",
                  () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ReassignBottomSheet(
                        member: TeamMember(
                          id: 'temp_id', // TODO: Pass actual member ID
                          name: name,
                          role: role,
                          tower: tower,
                          status: status,
                          completed: completed,
                          total: total,
                        ),
                        parentContext: context,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),

        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 16, height: 16),

            const SizedBox(width: 8),

            Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
