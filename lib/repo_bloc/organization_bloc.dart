import 'package:matger_core_logic/core/orgnization/repo/organization_repo.dart';
import 'package:matger_core_logic/utls/bloc/base_bloc.dart';
import 'package:matger_core_logic/core/orgnization/data/organization_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:matger_core_logic/utls/bloc/remote_base_model.dart';

class OrganizationBloc {
  static final OrganizationBloc _singleton = OrganizationBloc._internal();
  factory OrganizationBloc() => _singleton;
  OrganizationBloc._internal();

  final OrganizationRepo _repo = OrganizationRepo();

  final DataSourceBloc<OrganizationData> createOrgBloc =
      DataSourceBloc<OrganizationData>();

  final DataSourceBloc<List<OrganizationData>> activeOrganizationsBloc =
      DataSourceBloc<List<OrganizationData>>();

  final DataSourceBloc<Map<String, dynamic>> rawDataBloc =
      DataSourceBloc<Map<String, dynamic>>();

  void createOrganizationWithOwner({
    required Map<String, dynamic> userData,
    required OrganizationData organizationData,
  }) async {
    createOrgBloc.loadingState();
    rawDataBloc.loadingState();

    final result = await _repo.createOrganizationWithOwner(
      userData: userData,
      organizationData: organizationData,
    );

    if (result.status == StatusModel.success && result.data != null) {
      createOrgBloc.successState(result.data!);
      // Push Map for raw inspection
      rawDataBloc.successState(result.data!.toJson());
    } else {
      // If error but has data, show it raw
      if (result.data is Map<String, dynamic>) {
        rawDataBloc.successState(result.data as Map<String, dynamic>);
      } else if (result.data != null) {
        try {
          rawDataBloc.successState(result.data!.toJson());
        } catch (_) {}
      }

      createOrgBloc.failedState(
        ErrorStateModel(
          message: result.message ?? "Failed to create organization",
        ),
        () => createOrganizationWithOwner(
          userData: userData,
          organizationData: organizationData,
        ),
      );
    }
  }

  void loadActiveOrganizations() async {
    activeOrganizationsBloc.loadingState();
    final result = await _repo.getActiveOrganizations();

    if (result.status == StatusModel.success && result.data != null) {
      activeOrganizationsBloc.successState(result.data!);
    } else {
      activeOrganizationsBloc.failedState(
        ErrorStateModel(
          message: result.message ?? "Failed to load organizations",
        ),
        () => loadActiveOrganizations(),
      );
    }
  }
}

