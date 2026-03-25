import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectorCard extends StatelessWidget {
  final InspectionModel inspection;
  final int index;

  const InspectorCard({
    super.key,
    required this.inspection,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<InspectorViewModel>();

    final isApproved = inspection.status == InspectionStatus.approved;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: isApproved ? Colors.grey.shade300 : Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.directions_car),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inspection.vehicle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    inspection.name,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const Spacer(),

              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                inspection.location,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (isApproved)
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "Approved",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else ...[
            GestureDetector(
              onTap: () {
                vm.addPhoto(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined),
                    const SizedBox(width: 6),
                    Text("Take Photo (${inspection.photoCount})"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                /// APPROVE
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      vm.approveInspection(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 6),
                          Text(
                            "Approve",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// FLAG
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      vm.flagInspection(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag, color: Colors.red),
                          SizedBox(width: 6),
                          Text("Flag", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
