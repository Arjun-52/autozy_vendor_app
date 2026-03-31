import 'package:autozy_vendor_app/viewmodels/specialist_tasks_viewmodel.dart';
import 'package:flutter/material.dart';
import 'detail_row.dart';

class JobDetailsSheet extends StatelessWidget {
  final Task task;

  JobDetailsSheet({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            /// HEADER
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Job Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000E08),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// VEHICLE INFO
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.directions_car),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.vehicle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Rohit A • SUV",
                      style: TextStyle(
                        color: Color(0xff7E8392),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DETAILS CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  DetailRow(Icons.location_on, "Tower A, Slot 6"),
                  SizedBox(height: 10),
                  DetailRow(Icons.gps_fixed, "GPS Tracked • Live"),
                  SizedBox(height: 10),
                  DetailRow(Icons.calendar_today, "Interior Deep Clean"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// STATUS
            Row(
              children: const [
                Text(
                  "Status",
                  style: TextStyle(
                    color: Color(0xff7E8392),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  "• Pending",
                  style: TextStyle(
                    color: Color(0xffD79306),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
