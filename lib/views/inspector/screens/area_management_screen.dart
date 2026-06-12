import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/inspector_viewmodel.dart';
import '../../../data/models/area_model.dart';
import 'area_details_screen.dart';

class AreaMasterManagementScreen extends StatefulWidget {
  const AreaMasterManagementScreen({super.key});

  @override
  State<AreaMasterManagementScreen> createState() => _AreaMasterManagementScreenState();
}

class _AreaMasterManagementScreenState extends State<AreaMasterManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Active, Inactive, Recently Created

  final List<String> _filters = ['All', 'Active', 'Inactive', 'Recently Created'];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModel>();

    // Apply search and filter logic
    List<AreaModel> filteredList = vm.areas.where((area) {
      // Search
      final matchesSearch = area.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (area.code?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (area.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      if (!matchesSearch) return false;

      // Filter
      switch (_selectedFilter) {
        case 'Active':
          return area.isActive;
        case 'Inactive':
          return !area.isActive;
        case 'Recently Created':
          // Sort or filter? Let's show all created in last 7 days, or just keep it matching if created within 7 days
          return area.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7)));
        default:
          return true;
      }
    }).toList();

    // If 'Recently Created' is selected, we sort by createdAt descending
    if (_selectedFilter == 'Recently Created') {
      filteredList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Area Master", style: AppStyles.subHeading),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () => _showAreaFormDialog(context, vm),
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter Options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search areas by name or code...",
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey600),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
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
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.greyLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Area Cards List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Since this is in-memory, we just emulate delay
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() {});
              },
              child: filteredList.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: 350,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_outlined, size: 60, color: AppColors.grey600),
                            const SizedBox(height: 16),
                            const Text(
                              "No areas found.",
                              style: AppStyles.body,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty ? "Try checking spelling or clear search." : "Create your first coverage area.",
                              style: AppStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final area = filteredList[index];
                        return _buildAreaCard(context, vm, area);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAreaFormDialog(context, vm),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAreaCard(BuildContext context, InspectorViewModel vm, AreaModel area) {
    final String formattedDate = "${area.createdAt.day}/${area.createdAt.month}/${area.createdAt.year}";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: vm,
                child: AreaDetailsScreen(areaId: area.id),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          area.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (area.code != null && area.code!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            "Code: ${area.code}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: area.isActive
                          ? AppColors.successLight
                          : AppColors.greyLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: area.isActive ? AppColors.success : AppColors.grey,
                      ),
                    ),
                    child: Text(
                      area.isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: area.isActive ? AppColors.successDark : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (area.description != null && area.description!.isNotEmpty) ...[
                Text(
                  area.description!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              const Divider(),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: AppColors.grey600),
                      const SizedBox(width: 6),
                      Text(
                        "${area.assignedBuildings.length} Buildings",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Created: $formattedDate",
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showAreaFormDialog(context, vm, area: area),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _confirmDeleteArea(context, vm, area),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Delete"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAreaFormDialog(BuildContext context, InspectorViewModel vm, {AreaModel? area}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: area?.name ?? '');
    final codeController = TextEditingController(text: area?.code ?? '');
    final descController = TextEditingController(text: area?.description ?? '');
    bool isActive = area?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(area == null ? "Create coverage Area" : "Edit coverage Area"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Area Name *",
                          hintText: "e.g. Madhapur",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Area name cannot be empty";
                          }
                          if (vm.isDuplicateAreaName(value, excludeId: area?.id)) {
                            return "An area with this name already exists";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: "Area Code (Optional)",
                          hintText: "e.g. MP",
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: "Description (Optional)",
                          hintText: "Short description of area...",
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Status (Active)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: isActive,
                            onChanged: (val) {
                              setDialogState(() {
                                isActive = val;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      try {
                        if (area == null) {
                          vm.createArea(
                            nameController.text,
                            codeController.text,
                            descController.text,
                            isActive,
                          );
                        } else {
                          vm.editArea(
                            area.id,
                            nameController.text,
                            codeController.text,
                            descController.text,
                            isActive,
                          );
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(area == null ? "Area created successfully" : "Area updated successfully"),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: ${e.toString()}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteArea(BuildContext context, InspectorViewModel vm, AreaModel area) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Area"),
          content: Text("Are you sure you want to delete '${area.name}'? All building mappings to this area will be removed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                vm.deleteArea(area.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text("Area deleted successfully"),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
