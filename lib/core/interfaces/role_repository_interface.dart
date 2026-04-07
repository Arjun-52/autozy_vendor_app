import '../../data/models/role_model.dart';

abstract class IRoleRepository {
  Future<List<RoleModel>> getRoles();
  Future<bool> selectRole(String role);
}
