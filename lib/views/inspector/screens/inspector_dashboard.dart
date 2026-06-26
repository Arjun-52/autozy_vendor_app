import 'package:autozy_vendor_app/core/services/navigation_service.dart';
import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/attendance_viewmodel.dart';
import 'package:autozy_vendor_app/views/inspector/widgets/inspector_card.dart';
import 'package:autozy_vendor_app/views/inspector/screens/area_management_screen.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/status_card.dart';
import 'package:autozy_vendor_app/data/models/inspection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class InspectorDashboard extends StatefulWidget {
  const InspectorDashboard({super.key});

  @override
  State<InspectorDashboard> createState() => _InspectorDashboardState();
}

class _InspectorDashboardState extends State<InspectorDashboard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectorViewModel>().loadInspections();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<InspectorViewModel>().loadInspections();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModel>();
    final attendanceVm = context.watch<AttendanceViewModel>();
    final isOnline = attendanceVm.attendance != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => NavigationService.goToLogin(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Inspector Mode", style: AppStyles.subHeading),
            Text("Inspection Queue", style: AppStyles.caption),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (!isOnline) {
                context.push('/profile');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Clock In to go Online')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Clock Out from Profile to go Offline')),
                );
              }
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
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.black),
            onPressed: () => NavigationService.goToLogin(),
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => vm.loadInspections(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── Stats Row ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppSpacing.all16,
                      child: Row(
                        children: [
                          Expanded(
                            child: StatusCard(
                              icon: SvgPicture.asset(
                                "assets/images/Car.svg",
                                height: AppSpacing.iconMd,
                                width: AppSpacing.iconMd,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: vm.assignedInspections.length.toString(),
                              subtitle: "Assigned",
                              iconColor: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: StatusCard(
                              icon: SvgPicture.asset(
                                "assets/images/Car.svg",
                                height: AppSpacing.iconMd,
                                width: AppSpacing.iconMd,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: vm.unassignedInspections.length.toString(),
                              subtitle: "In Queue",
                              iconColor: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: StatusCard(
                              icon: const Icon(Icons.warning),
                              title: vm.flaggedCount.toString(),
                              subtitle: "Flagged",
                              iconColor: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Error Banner ───────────────────────────────────────
                  if (vm.errorMessage != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              vm.errorMessage!,
                              style: const TextStyle(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => vm.loadInspections(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary),
                              child: const Text("Retry",
                                  style: TextStyle(color: AppColors.black)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── Section: Assigned Jobs ──────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.assignment_ind_outlined,
                                  size: 18, color: AppColors.black),
                              const SizedBox(width: 6),
                              Text(
                                "Assigned Jobs (${vm.assignedInspections.length})",
                                style: AppStyles.sectionTitle,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.map, color: AppColors.black),
                            tooltip: "Area Master",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChangeNotifierProvider.value(
                                    value: vm,
                                    child: const AreaMasterManagementScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (vm.assignedInspections.isEmpty)
                    const SliverToBoxAdapter(
                      child: _EmptyState(
                        icon: Icons.assignment_outlined,
                        message: "No assigned inspections.",
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => InspectorCard(
                            inspection: vm.assignedInspections[index],
                            index: index,
                          ),
                          childCount: vm.assignedInspections.length,
                        ),
                      ),
                    ),

                  // ── Section: Unassigned Queue ───────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Row(
                        children: [
                          const Icon(Icons.inbox_outlined,
                              size: 18, color: AppColors.black),
                          const SizedBox(width: 6),
                          Text(
                            "Available Queue (${vm.unassignedInspections.length})",
                            style: AppStyles.sectionTitle,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (vm.unassignedInspections.isEmpty)
                    const SliverToBoxAdapter(
                      child: _EmptyState(
                        icon: Icons.inbox,
                        message: "No inspections available in queue.",
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _QueueCard(
                            inspection: vm.unassignedInspections[index],
                            onClaim: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Claim Inspection"),
                                  content: Text(
                                    "Claim vehicle ${vm.unassignedInspections[index].vehicle}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      child: const Text("Claim",
                                          style: TextStyle(
                                              color: AppColors.black)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                final id =
                                    vm.unassignedInspections[index].id;
                                final success =
                                    await vm.claimInspection(id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(success
                                        ? 'Inspection claimed successfully'
                                        : 'Failed to claim inspection'),
                                  ));
                                }
                              }
                            },
                          ),
                          childCount: vm.unassignedInspections.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

// ── Empty State Widget ──────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.grey600),
            const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Unassigned Queue Card ───────────────────────────────────────────────────

class _QueueCard extends StatelessWidget {
  final InspectionModel inspection;
  final VoidCallback onClaim;

  const _QueueCard({required this.inspection, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<InspectorViewModel>();
    final isClaiming =
        vm.isLoading; // shows spinner during claim operation

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    "assets/images/car2.svg",
                    colorFilter: const ColorFilter.mode(
                      AppColors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspection.vehicle.isNotEmpty
                          ? inspection.vehicle
                          : 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inspection.vehicleName ?? inspection.name,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Pending badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Pending",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Location
          if (inspection.location.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    inspection.location,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          // Scheduled date if available
          if (inspection.serviceDate != null &&
              inspection.serviceDate!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.schedule,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  inspection.serviceDate!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // Claim button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: isClaiming ? null : onClaim,
              icon: isClaiming
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.black),
                    )
                  : const Icon(Icons.add_task,
                      size: 18, color: AppColors.black),
              label: Text(
                isClaiming ? "Claiming..." : "Claim Inspection",
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
