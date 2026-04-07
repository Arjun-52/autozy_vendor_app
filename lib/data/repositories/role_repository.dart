import '../../core/interfaces/role_repository_interface.dart';
import '../../data/models/role_model.dart';

class RoleRepository implements IRoleRepository {
  @override
  Future<List<RoleModel>> getRoles() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Return exact same mock data as before
    return [
      RoleModel(title: 'Detailer', subtitle: 'Daily car cleaning route'),
      RoleModel(title: 'Inspector', subtitle: 'New vehicle inspections'),
      RoleModel(title: 'Supervisor', subtitle: 'Team & route management'),
      RoleModel(title: 'Specialist', subtitle: 'Premium add-on services'),
    ];
  }

  @override
  Future<bool> selectRole(String role) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
