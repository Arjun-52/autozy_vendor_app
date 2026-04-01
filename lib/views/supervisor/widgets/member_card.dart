import "package:autozy_vendor_app/data/models/team_member.dart";
import "package:autozy_vendor_app/views/supervisor/widgets/action_button.dart";
import "package:autozy_vendor_app/views/supervisor/widgets/progress_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class MemberCard extends StatelessWidget {
  final TeamMember member;

  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    double progress = member.completed / member.total;

    Color statusColor = member.status == "Active"
        ? Color(0xff008847)
        : Colors.orange;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.19),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    "assets/images/profile-tick.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        member.role,
                        style: TextStyle(
                          color: Color(0xff7E8392),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(member.tower, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),

              Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: statusColor.withValues(alpha: 0.1),
                  border: Border.all(color: statusColor.withValues(alpha: 0.8)),
                ),
                child: Text(
                  member.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress: ${member.completed}/${member.total}",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(width: 120, child: ProgressBar(value: progress)),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              ActionButton(
                icon: Padding(
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    "assets/images/call.svg",
                    height: 18,
                    width: 18,
                    fit: BoxFit.contain,
                  ),
                ),
                text: "Call",
              ),
              const SizedBox(width: 10),
              ActionButton(
                icon: Padding(
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    "assets/images/workFlow.svg",
                    height: 18,
                    width: 18,
                    fit: BoxFit.contain,
                  ),
                ),
                text: "Reassign",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
