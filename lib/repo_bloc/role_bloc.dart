import 'package:matger_core_logic/features/roles/repo/role_repo.dart';
import 'package:matger_core_logic/features/roles/data/role_data_model.dart';
import 'package:matger_core_logic/core/auth/data/permission_model.dart';
import 'package:matger_core_logic/utls/bloc/base_bloc.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:matger_core_logic/utls/bloc/remote_base_model.dart';

class RoleBloc {
  late final RoleRepo _repo;

  RoleBloc({RoleRepo? roleRepo}) {
    _repo = roleRepo ?? RoleRepo();
  }

  final DataSourceBloc<RoleDataModel> roleDataBloc = DataSourceBloc<RoleDataModel>();
  final DataSourceBloc<List<RoleDataModel>> rolesListBloc = DataSourceBloc<List<RoleDataModel>>();
  final DataSourceBloc<List<PermissionModel>> permissionsListBloc = DataSourceBloc<List<PermissionModel>>();

  Future<void> getRoles({String? organizationId}) async {
    rolesListBloc.loadingState();
    final result = await _repo.getRoles(organizationId: organizationId);

    if (result.status == StatusModel.success && result.data != null) {
      rolesListBloc.successState(result.data!);
    } else {
      rolesListBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to get roles"),
        () => getRoles(organizationId: organizationId),
      );
    }
  }

  Future<void> getAllPermissions() async {
    permissionsListBloc.loadingState();
    final result = await _repo.getAllPermissions();

    if (result.status == StatusModel.success && result.data != null) {
      permissionsListBloc.successState(result.data!);
    } else {
      permissionsListBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to get permissions"),
        () => getAllPermissions(),
      );
    }
  }

  Future<void> createRole({
    required String name,
    String? displayName,
    String? description,
    required List<String> permissions,
    String? organizationId,
  }) async {
    roleDataBloc.loadingState();
    final result = await _repo.createRole(
      name: name,
      displayName: displayName,
      description: description,
      permissions: permissions,
      organizationId: organizationId,
    );

    if (result.status == StatusModel.success && result.data != null) {
      roleDataBloc.successState(result.data!);
      // Refresh list after creation
      getRoles(organizationId: organizationId);
    } else {
      roleDataBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to create role"),
        () => createRole(
          name: name,
          displayName: displayName,
          description: description,
          permissions: permissions,
          organizationId: organizationId,
        ),
      );
    }
  }

  Future<void> updateRole({
    required String roleId,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? isActive,
    String? organizationId,
  }) async {
    roleDataBloc.loadingState();
    final result = await _repo.updateRole(
      roleId: roleId,
      name: name,
      displayName: displayName,
      description: description,
      permissions: permissions,
      isActive: isActive,
    );

    if (result.status == StatusModel.success && result.data != null) {
      roleDataBloc.successState(result.data!);
      // Refresh list after update
      getRoles(organizationId: organizationId);
    } else {
      roleDataBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to update role"),
        () => updateRole(
          roleId: roleId,
          name: name,
          displayName: displayName,
          description: description,
          permissions: permissions,
          isActive: isActive,
          organizationId: organizationId,
        ),
      );
    }
  }

  Future<void> deleteRole(String roleId, {String? organizationId}) async {
    roleDataBloc.loadingState();
    final result = await _repo.deleteRole(roleId);

    if (result.status == StatusModel.success) {
      roleDataBloc.init();
      // Refresh list after deletion
      getRoles(organizationId: organizationId);
    } else {
      roleDataBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to delete role"),
        () => deleteRole(roleId, organizationId: organizationId),
      );
    }
  }
}
