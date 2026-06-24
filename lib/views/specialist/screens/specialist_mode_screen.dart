import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_status_tile.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/navigation_service.dart';

import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../core/services/alert_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/di/dependency_injection.dart';

class SpecialistModeScreen extends StatefulWidget {
  const SpecialistModeScreen({super.key});

  @override
  State<SpecialistModeScreen> createState() => _SpecialistModeScreenState();
}

class _SpecialistModeScreenState extends State<SpecialistModeScreen> {
  bool isOnline = false;

  void _simulatePaymentAndBooking(BuildContext context, SpecialistTasksViewModel vm, String pricingId, {String? customName, String? customPrice}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String selectedPayment = "UPI";
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Payment Experience", style: AppStyles.subHeading),
                  const SizedBox(height: 16),
                  Text(
                    "Service: ${customName ?? 'One-time Add-on Service'}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text("Amount: ₹${customPrice ?? '999'}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Select Payment Method", style: AppStyles.bodyMedium),
                  const SizedBox(height: 10),
                  RadioListTile<String>(
                    title: const Text("UPI / GooglePay / PhonePe"),
                    value: "UPI",
                    groupValue: selectedPayment,
                    onChanged: (val) {
                      setState(() {
                        selectedPayment = val!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Credit / Debit Card"),
                    value: "CARD",
                    groupValue: selectedPayment,
                    onChanged: (val) {
                      setState(() {
                        selectedPayment = val!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Cash / Pay on Service"),
                    value: "CASH",
                    groupValue: selectedPayment,
                    onChanged: (val) {
                      setState(() {
                        selectedPayment = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Close options, show loading/success dialog
                        Navigator.pop(context);
                        _showPaymentProgress(context, vm, pricingId, customName ?? 'Add-on');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Pay & Book Now", style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPaymentProgress(BuildContext context, SpecialistTasksViewModel vm, String pricingId, String serviceName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // close progress dialog
                _showSuccessDialog(context, serviceName);
                vm.fetchAddonBookings(); // refresh list
              }
            });
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                    SizedBox(height: 20),
                    Text("Processing Secure Payment...", style: AppStyles.bodyMedium),
                    SizedBox(height: 8),
                    Text("Please do not press back or close the app", style: AppStyles.caption),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 28),
              SizedBox(width: 8),
              Text("Booking Confirmed!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text("Your booking for '$serviceName' has been successfully created. Specialist will start work shortly."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Awesome"),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildComboPackagesList(BuildContext context, SpecialistTasksViewModel vm) {
    final combos = [
      {
        "name": "Ultimate Shine & Buff Combo",
        "description": "Full exterior polish and long-lasting ceramic coat protection.",
        "originalPrice": "4000",
        "discountPrice": "3200",
        "services": ["Ceramic Coating", "Exterior Polish"],
      },
      {
        "name": "Deep Clean & Hygiene Combo",
        "description": "Complete interior vacuuming, seat shampooing, AC disinfection.",
        "originalPrice": "2500",
        "discountPrice": "1999",
        "services": ["Interior Deep Clean", "AC Sanitization"],
      }
    ];

    return combos.map((combo) {
      final orig = double.parse(combo["originalPrice"] as String);
      final disc = double.parse(combo["discountPrice"] as String);
      final discountPct = (((orig - disc) / orig) * 100).round();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    combo["name"] as String,
                    style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$discountPct% OFF",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              combo["description"] as String,
              style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹${combo["originalPrice"]}",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "₹${combo["discountPrice"]}",
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _simulatePaymentAndBooking(
                    context,
                    vm,
                    "combo-id",
                    customName: combo["name"] as String,
                    customPrice: combo["discountPrice"] as String,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Book Combo",
                    style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpecialistTasksViewModel(di.specialistTasksRepository)
        ..loadTasks()
        ..fetchSpecialistJobs()
        ..fetchAddonServices()
        ..fetchAddonBookings(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () {
                NavigationService.goBack();
              },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Specialist Mode", style: AppStyles.subHeading),
              Text("Add-on Tasks", style: AppStyles.caption),
            ],
          ),
          actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOnline = !isOnline;
                  });

                  handleOnlineToggle(context, isOnline);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: AppSpacing.right16,
                  padding: AppSpacing.horizontal12Vertical6,
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.onlineBg.withOpacity(0.5)
                        : Colors.red.withOpacity(0.1),
                    border: Border.all(
                      color: isOnline ? AppColors.success : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Text(
                    isOnline ? "● Online" : "● Offline",
                    style: TextStyle(
                      color: isOnline ? AppColors.success : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: AppColors.black),
                onPressed: () {
                  context.push('/profile');
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.black),
                onPressed: () {
                  NavigationService.logout();
                },
              ),
            ]
        ),
        body: SafeArea(
          child: Consumer<SpecialistTasksViewModel>(
            builder: (context, vm, child) {
              if (vm.showError && vm.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertService.showTopAlert(
                    context,
                    message: vm.errorMessage!,
                    onClose: () => vm.clearError(),
                  );
                });
              }

              return Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  /// STATUS TILES
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        TaskStatusTile(count: "3", label: "Active"),
                        TaskStatusTile(
                          count: "1",
                          label: "In Progress",
                          highlight: true,
                        ),
                        TaskStatusTile(count: "2", label: "Queued"),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  /// LIST
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => vm.fetchSpecialistJobs(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        children: [
                          const Text(
                            "Add-on Tasks",
                            style: AppStyles.sectionTitle,
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.isLoadingJobs)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.specialistJobs.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No specialist jobs available",
                                style: AppStyles.body,
                              ),
                            ),
                          )
                        else
                          ...List.generate(vm.specialistJobs.length, (index) {
                            final job = vm.specialistJobs[index];
                            return TaskCard(
                              job: job,
                              taskIndex: index,
                            );
                          }),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          "Available Services",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.isLoadingAddonServices)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.addonServices.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No services available",
                                style: AppStyles.body,
                              ),
                            ),
                          )
                        else
                          ...vm.addonServices.map((service) {
                            final isSelected = vm.selectedPricingId == service.pricingId;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => vm.selectService(service.pricingId),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            service.name,
                                            style: AppStyles.bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "₹${service.price}",
                                          style: AppStyles.bodyMedium.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      service.description,
                                      style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 16, color: AppColors.grey600),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${service.estimatedDuration} mins",
                                              style: AppStyles.caption,
                                            ),
                                          ],
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            color: AppColors.primary,
                                          )
                                        else
                                          Text(
                                            "Tap to select",
                                            style: AppStyles.caption.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        if (vm.selectedPricingId != null) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                final selectedService = vm.addonServices.firstWhere((s) => s.pricingId == vm.selectedPricingId);
                                _simulatePaymentAndBooking(
                                  context,
                                  vm,
                                  vm.selectedPricingId!,
                                  customName: selectedService.name,
                                  customPrice: selectedService.price,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                "Book Selected Service",
                                style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          "Combo Packages",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ..._buildComboPackagesList(context, vm),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          "My Bookings",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.isLoadingBookings)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.addonBookings.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No bookings available",
                                style: AppStyles.body,
                              ),
                            ),
                          )
                        else
                          ...vm.addonBookings.map((booking) {
                            return Container();
                          }),
                      ],
                    ),
                  ),
                ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
