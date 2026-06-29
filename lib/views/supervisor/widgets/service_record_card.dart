import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import 'reassign_bottom_sheet.dart';
import '../../../data/models/team_member.dart';

class ServiceRecordCard extends StatelessWidget {
  final Map<String, dynamic> record;

  const ServiceRecordCard({super.key, required this.record});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely parse nested vehicle and detailer objects
    final vehicle = record['vehicle'] as Map<String, dynamic>?;
    final detailer = record['detailer'] as Map<String, dynamic>?;

    final vehicleNumber = vehicle?['vehicle_number'] ?? 'N/A';
    final vehicleBrand = vehicle?['brand'] ?? '';
    final vehicleModel = vehicle?['model'] ?? '';
    final vehicleInfo = vehicleBrand.isNotEmpty || vehicleModel.isNotEmpty
        ? "$vehicleBrand $vehicleModel".trim()
        : "Unknown Vehicle";

    final detailerName = detailer?['name'] ?? 'Unassigned';
    final detailerPhone = detailer?['phone']?.toString() ?? '';

    final status = (record['status']?.toString() ?? 'PENDING').toUpperCase();
    final serviceDate = record['service_date']?.toString() ?? 'N/A';

    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case 'COMPLETED':
        statusColor = const Color(0xff008847);
        statusBgColor = const Color(0xff008847).withOpacity(0.1);
        break;
      case 'PENDING':
        statusColor = const Color(0xffFFA500);
        statusBgColor = const Color(0xffFFA500).withOpacity(0.1);
        break;
      case 'IN_PROGRESS':
        statusColor = AppColors.primary;
        statusBgColor = AppColors.primary.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Vehicle & Status tag
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Icon and Info
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleInfo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // License plate style container for vehicle number
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        vehicleNumber,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFE9E9E9), height: 1),
          ),
          // Row 2: Detailer & Service Date details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Detailer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detailer",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff7E8392),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detailerName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Service Date Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Service Date",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff7E8392),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceDate,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Buttons
          const SizedBox(height: 12),
          Row(
            children: [
              if (detailerPhone.isNotEmpty)
                Expanded(
                  child: InkWell(
                    onTap: () => _makePhoneCall(detailerPhone),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE9E9E9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone_outlined, size: 16, color: Colors.black),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              "Call ($detailerName)",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (detailerPhone.isNotEmpty) const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ReassignBottomSheet(
                        parentContext: context,
                        serviceRecordUuid: record['id']?.toString(),
                        member: TeamMember(
                          id: detailer?['id']?.toString() ?? '',
                          name: detailerName,
                          role: 'Detailer',
                          phone: detailerPhone,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE9E9E9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.swap_horiz, size: 16, color: Colors.black),
                        SizedBox(width: 6),
                        Text(
                          "Reassign",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
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
      ),
    );
  }
}
