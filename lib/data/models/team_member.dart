class TeamMember {
  final String name;
  final String role;
  final String tower;
  final int completed;
  final int total;
  final String status; // Active / Break / Offline

  TeamMember({
    required this.name,
    required this.role,
    required this.tower,
    required this.completed,
    required this.total,
    required this.status,
  });
}
