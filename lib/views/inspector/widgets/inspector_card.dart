import 'package:flutter/material.dart';

class InspectorCard extends StatelessWidget {
  final bool isApproved;

  const InspectorCard({super.key, this.isApproved = false});

  @override
  Widget build(BuildContext context) {
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

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MH 01 KL 9999",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text("Rohit A • SUV", style: TextStyle(color: Colors.grey)),
                ],
              ),

              const Spacer(),

              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 5),
              Text("Tower A, Slot 6", style: TextStyle(color: Colors.grey)),
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(width: 6),
                  Text("Take Photo (0)"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                /// APPROVE
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.black),
                        SizedBox(width: 6),
                        Text(
                          "Approve",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// FLAG
                Expanded(
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
              ],
            ),
          ],
        ],
      ),
    );
  }
}
