import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/inspector_viewmodel.dart';
import '../../../data/models/area_model.dart';

class AreaDetailsScreen extends StatefulWidget {
  final String areaId;

  const AreaDetailsScreen({super.key, required this.areaId});

  @override
  State<AreaDetailsScreen> createState() => _AreaDetailsScreenState();
}

class _AreaDetailsScreenState extends State<AreaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModel>();

    // Safely retrieve area. If deleted/not found, pop back
    final areaIndex = vm.areas.indexWhere((e) => e.id == widget.areaId);
    if (areaIndex == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final area = vm.areas[areaIndex];
    final String formattedCreatedDate = "${area.createdAt.day}/${area.createdAt.month}/${area.createdAt.year}";
    final String formattedUpdatedDate = "${area.updatedAt.day}/${area.updatedAt.month}/${area.updatedAt.year}";

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
        title: Text(area.name, style: AppStyles.subHeading),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.black),
            onPressed: () => _showEditAreaDialog(context, vm, area),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Area Summary Card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            area.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
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
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: area.isActive ? AppColors.successDark : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (area.code != null && area.code!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Code: ${area.code}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (area.description != null && area.description!.isNotEmpty) ...[
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          area.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const Divider(),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Created: $formattedCreatedDate",
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          Text(
                            "Updated: $formattedUpdatedDate",
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Assigned Buildings Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Assigned Buildings (${area.assignedBuildings.length})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAssignBuildingsDialog(context, vm, area),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text("Assign", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (area.assignedBuildings.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.business, size: 36, color: AppColors.grey),
                      SizedBox(height: 8),
                      Text(
                        "No buildings mapped to this area.",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: area.assignedBuildings.length,
                  itemBuilder: (context, index) {
                    final building = area.assignedBuildings[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.business, color: AppColors.textSecondary),
                        title: Text(
                          building,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _confirmRemoveBuilding(context, vm, area, building),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditAreaDialog(BuildContext context, InspectorViewModel vm, AreaModel area) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: area.name);
    final codeController = TextEditingController(text: area.code ?? '');
    final descController = TextEditingController(text: area.description ?? '');
    bool isActive = area.isActive;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Edit coverage Area"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Area Name *"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Area name cannot be empty";
                          }
                          if (vm.isDuplicateAreaName(value, excludeId: area.id)) {
                            return "An area with this name already exists";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: codeController,
                        decoration: const InputDecoration(labelText: "Area Code (Optional)"),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(labelText: "Description (Optional)"),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Status (Active)", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      vm.editArea(
                        area.id,
                        nameController.text,
                        codeController.text,
                        descController.text,
                        isActive,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text("Area updated successfully"),
                          backgroundColor: AppColors.success,
                        ),
                      );
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

  void _showAssignBuildingsDialog(BuildContext context, InspectorViewModel vm, AreaModel area) {
    // Collect all available buildings
    final List<String> allAvailable = vm.availableBuildingsForAssignment;
    List<String> selectedBuildings = List.from(area.assignedBuildings);
    String filterText = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredAvailable = allAvailable
                .where((b) => b.toLowerCase().contains(filterText.toLowerCase()))
                .toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Assign Buildings"),
              content: SizedBox(
                width: double.maxFinite,
                height: 380,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search buildings...",
                        prefixIcon: const Icon(Icons.search, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (val) {
                        setDialogState(() {
                          filterText = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filteredAvailable.isEmpty
                          ? const Center(child: Text("No buildings match search"))
                          : ListView.builder(
                              itemCount: filteredAvailable.length,
                              itemBuilder: (context, index) {
                                final bName = filteredAvailable[index];
                                final isCurrentlyMapped = selectedBuildings.contains(bName);
                                // Is it mapped to another area?
                                String? otherArea;
                                for (final a in vm.areas) {
                                  if (a.id != area.id && a.assignedBuildings.contains(bName)) {
                                    otherArea = a.name;
                                    break;
                                  }
                                }

                                return CheckboxListTile(
                                  value: isCurrentlyMapped,
                                  title: Text(
                                    bName,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: otherArea != null
                                      ? Text(
                                          "Assigned to: $otherArea",
                                          style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold),
                                        )
                                      : null,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      if (val == true) {
                                        selectedBuildings.add(bName);
                                      } else {
                                        selectedBuildings.remove(bName);
                                      }
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  checkColor: AppColors.textPrimary,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    vm.assignBuildings(area.id, selectedBuildings);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text("Buildings assigned successfully"),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmRemoveBuilding(BuildContext context, InspectorViewModel vm, AreaModel area, String building) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remove Building"),
          content: Text("Are you sure you want to remove '$building' from '${area.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                vm.removeBuildingFromArea(area.id, building);
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text("Building removed from area"),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );
  }
}
