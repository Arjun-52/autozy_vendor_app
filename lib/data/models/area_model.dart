class AreaModel {
  final String id;
  String name;
  String? code;
  String? description;
  bool isActive;
  final DateTime createdAt;
  DateTime updatedAt;
  List<String> assignedBuildings;

  AreaModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedBuildings,
  });

  AreaModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? assignedBuildings,
  }) {
    return AreaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedBuildings: assignedBuildings ?? List.from(this.assignedBuildings),
    );
  }
}
