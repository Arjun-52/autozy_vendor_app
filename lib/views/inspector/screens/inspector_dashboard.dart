import 'package:autozy_vendor_app/core/services/navigation_service.dart';
import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:autozy_vendor_app/views/inspector/widgets/inspector_card.dart';
import 'package:autozy_vendor_app/views/inspector/screens/area_management_screen.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/status_card.dart';
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

class _InspectorDashboardState extends State<InspectorDashboard> with WidgetsBindingObserver {
  bool isOnline = false;

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            NavigationService.goToLogin();
          },
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
              NavigationService.goToLogin();
            },
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.all16,
        child: Column(
          children: [
            Row(
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
                    title: vm.approvedCount.toString(),
                    subtitle: "Approved",
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
                    title: vm.pendingCount.toString(),
                    subtitle: "Pending",
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

            const SizedBox(height: AppSpacing.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Inspection Queue", style: AppStyles.sectionTitle),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.map,
                        color: AppColors.black,
                      ),
                      tooltip: "Area Master",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: vm,
                              child: const AreaMasterManagementScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: vm.hasActiveFilters ? AppColors.warning : AppColors.black,
                      ),
                      onPressed: () {
                        _showFilterBottomSheet(context, vm);
                      },
                    ),
                  ],
                ),
              ],
            ),

            if (vm.hasActiveFilters) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (vm.selectedArea != null)
                            _buildFilterChip(
                              label: 'Area: ${vm.selectedArea}',
                              onDeleted: () => vm.removeAreaFilter(),
                            ),
                          if (vm.selectedCommunity != null)
                            _buildFilterChip(
                              label: 'Community: ${vm.selectedCommunity}',
                              onDeleted: () => vm.removeCommunityFilter(),
                            ),
                          if (vm.selectedBuilding != null)
                            _buildFilterChip(
                              label: 'Building: ${vm.selectedBuilding}',
                              onDeleted: () => vm.removeBuildingFilter(),
                            ),
                          if (vm.selectedStreet != null)
                            _buildFilterChip(
                              label: 'Street: ${vm.selectedStreet}',
                              onDeleted: () => vm.removeStreetFilter(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => vm.clearFilters(),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => vm.loadInspections(),
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : vm.errorMessage != null
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      vm.errorMessage!,
                                      style: const TextStyle(color: AppColors.error),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () => vm.loadInspections(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                      ),
                                      child: const Text(
                                        "Retry",
                                        style: TextStyle(color: AppColors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : vm.inspections.isEmpty
                            ? const SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Text(
                                      "No inspections in queue",
                                      style: AppStyles.body,
                                    ),
                                  ),
                                ),
                              )
                            : vm.filteredInspections.isEmpty
                                ? SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.filter_list_off,
                                              size: 48,
                                              color: AppColors.grey600,
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              "No jobs found for selected filters.",
                                              style: AppStyles.body,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () => vm.clearFilters(),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: AppColors.textPrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Clear Filters",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: vm.filteredInspections.length,
                                    itemBuilder: (context, index) {
                                      return InspectorCard(
                                        inspection: vm.filteredInspections[index],
                                        index: index,
                                      );
                                    },
                                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onDeleted}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.primary,
        deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.textPrimary),
        onDeleted: onDeleted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, InspectorViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            final query = searchController.text.trim().toLowerCase();

            final filteredAreas = vm.uniqueAreas
                .where((e) => e.toLowerCase().contains(query))
                .toList();
            final filteredCommunities = vm.uniqueCommunities
                .where((e) => e.toLowerCase().contains(query))
                .toList();
            final filteredBuildings = vm.uniqueBuildings
                .where((e) => e.toLowerCase().contains(query))
                .toList();
            final filteredStreets = vm.uniqueStreets
                .where((e) => e.toLowerCase().contains(query))
                .toList();

            final hasMatches = filteredAreas.isNotEmpty ||
                filteredCommunities.isNotEmpty ||
                filteredBuildings.isNotEmpty ||
                filteredStreets.isNotEmpty;

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Filter Jobs",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (vm.hasActiveFilters)
                              TextButton(
                                onPressed: () {
                                  vm.clearFilters();
                                  setBottomSheetState(() {});
                                },
                                child: const Text(
                                  "Clear All",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search within filters...",
                            prefixIcon: const Icon(Icons.search, color: AppColors.grey600),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      searchController.clear();
                                      setBottomSheetState(() {});
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (val) {
                            setBottomSheetState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: [
                            if (!hasMatches)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.search_off, size: 48, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        "No filter options match \"${searchController.text}\"",
                                        style: const TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            
                            if (filteredAreas.isNotEmpty) ...[
                              _buildCategoryHeader("Area"),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filteredAreas.map((area) {
                                  final isSelected = vm.selectedArea == area;
                                  return ChoiceChip(
                                    label: Text(area),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      vm.setFilters(
                                        area: selected ? area : null,
                                        building: vm.selectedBuilding,
                                        street: vm.selectedStreet,
                                        community: vm.selectedCommunity,
                                      );
                                      setBottomSheetState(() {});
                                    },
                                    selectedColor: AppColors.primary,
                                    backgroundColor: AppColors.greyLight,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                            ],

                            if (filteredCommunities.isNotEmpty) ...[
                              _buildCategoryHeader("Community"),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filteredCommunities.map((community) {
                                  final isSelected = vm.selectedCommunity == community;
                                  return ChoiceChip(
                                    label: Text(community),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      vm.setFilters(
                                        area: vm.selectedArea,
                                        building: vm.selectedBuilding,
                                        street: vm.selectedStreet,
                                        community: selected ? community : null,
                                      );
                                      setBottomSheetState(() {});
                                    },
                                    selectedColor: AppColors.primary,
                                    backgroundColor: AppColors.greyLight,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                            ],

                            if (filteredBuildings.isNotEmpty) ...[
                              _buildCategoryHeader("Building"),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filteredBuildings.map((building) {
                                  final isSelected = vm.selectedBuilding == building;
                                  return ChoiceChip(
                                    label: Text(building),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      vm.setFilters(
                                        area: vm.selectedArea,
                                        building: selected ? building : null,
                                        street: vm.selectedStreet,
                                        community: vm.selectedCommunity,
                                      );
                                      setBottomSheetState(() {});
                                    },
                                    selectedColor: AppColors.primary,
                                    backgroundColor: AppColors.greyLight,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                            ],

                            if (filteredStreets.isNotEmpty) ...[
                              _buildCategoryHeader("Street"),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filteredStreets.map((street) {
                                  final isSelected = vm.selectedStreet == street;
                                  return ChoiceChip(
                                    label: Text(street),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      vm.setFilters(
                                        area: vm.selectedArea,
                                        building: vm.selectedBuilding,
                                        street: selected ? street : null,
                                        community: vm.selectedCommunity,
                                      );
                                      setBottomSheetState(() {});
                                    },
                                    selectedColor: AppColors.primary,
                                    backgroundColor: AppColors.greyLight,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Apply Filters",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
