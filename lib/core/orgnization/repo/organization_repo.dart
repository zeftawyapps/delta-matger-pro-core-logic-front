import 'package:matger_pro_core_logic/core/orgnization/data/organization_model.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_config.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_policy.dart';
import 'package:matger_pro_core_logic/core/orgnization/source/organization_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_requests.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_stats.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrganizationRepo {
  late final OrganizationSource _organizationSource;

  OrganizationRepo({OrganizationSource? organizationSource}) {
    _organizationSource = organizationSource ?? OrganizationSource();
  }

  Future<RemoteBaseModel<OrganizationData>> createOrganizationWithOwner({
    required Map<String, dynamic> userData,
    required OrganizationData organizationData,
    String? templateOrgId,
  }) async {
    JDRepoConsole.info(
      "Creating organization in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "createOrganizationWithOwner",
      ),
    );
    final result = await _organizationSource.createOrganizationWithOwner(
      request: CreateOrgWithOwnerRequest(
        userData: userData,
        organizationData: organizationData.toJson(),
        templateOrgId: templateOrgId,
      ),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createOrganizationWithOwner: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "createOrganizationWithOwner",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      // Assuming the response returns the created organization in a field or directly
      final data = result.data['organization'] ?? result.data;
      final org = OrganizationData.fromJson(data as Map<String, dynamic>);
      JDRepoConsole.success(
        "Organization parsed successfully in repo",
        context: LogContext(
          module: "OrganizationRepo",
          method: "createOrganizationWithOwner",
        ),
      );
      return RemoteBaseModel(data: org, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createOrganizationWithOwner: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "createOrganizationWithOwner",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<OrganizationData>>>
  getActiveOrganizations() async {
    JDRepoConsole.info(
      "Getting active organizations in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getActiveOrganizations",
      ),
    );
    final result = await _organizationSource.getActiveOrganizations();

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getActiveOrganizations: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getActiveOrganizations",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data;
      final List organizationsList;

      if (data is List) {
        organizationsList = data;
      } else if (data is Map) {
        if (data['organizations'] is List) {
          organizationsList = data['organizations'];
        } else if (data['data'] is List) {
          organizationsList = data['data'];
        } else if (data['data'] is Map &&
            data['data']['organizations'] is List) {
          organizationsList = data['data']['organizations'];
        } else {
          organizationsList = [];
        }
      } else {
        organizationsList = [];
      }

      final organizations = organizationsList
          .map(
            (json) => OrganizationData.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      JDRepoConsole.success(
        "Fetched ${organizations.length} active organizations successfully in repo",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getActiveOrganizations",
        ),
      );
      return RemoteBaseModel(data: organizations, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getActiveOrganizations: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getActiveOrganizations",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<OrganizationData>>>
  getCompleteOrganizations() async {
    JDRepoConsole.info(
      "Getting complete organizations in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getCompleteOrganizations",
      ),
    );
    final result = await _organizationSource.getCompleteOrganizations();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final List data = result.data is List ? result.data : result.data['organizations'] ?? [];
      final organizations = data
          .map((json) => OrganizationData.fromJson(json as Map<String, dynamic>))
          .toList();
      return RemoteBaseModel(data: organizations, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<OrganizationData>>>
  getIncompleteOrganizations() async {
    JDRepoConsole.info(
      "Getting incomplete organizations in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getIncompleteOrganizations",
      ),
    );
    final result = await _organizationSource.getIncompleteOrganizations();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final List data = result.data is List ? result.data : result.data['organizations'] ?? [];
      final organizations = data
          .map((json) => OrganizationData.fromJson(json as Map<String, dynamic>))
          .toList();
      return RemoteBaseModel(data: organizations, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationStats>> getOrganizationStats() async {
    JDRepoConsole.info(
      "Getting organization stats in repo",
      context: LogContext(module: "OrganizationRepo", method: "getOrganizationStats"),
    );
    final result = await _organizationSource.getOrganizationStats();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final stats = OrganizationStats.fromJson(result.data as Map<String, dynamic>);
      return RemoteBaseModel(data: stats, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<OrganizationData>>> searchByLocation(
    OrganizationLocationSearchRequest request,
  ) async {
    JDRepoConsole.info(
      "Searching organizations by location in repo",
      context: LogContext(module: "OrganizationRepo", method: "searchByLocation"),
    );
    final result = await _organizationSource.searchByLocation(request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final List data = result.data is List ? result.data : (result.data['organizations'] ?? []);
      final organizations = data
          .map((json) => OrganizationData.fromJson(json as Map<String, dynamic>))
          .toList();
      return RemoteBaseModel(data: organizations, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationData>> createOrganizationForExistingUser({
    required String userId,
    required Map<String, dynamic> organizationData,
    String? templateOrgId,
  }) async {
    final result = await _organizationSource.createOrganizationForExistingUser(
      request: CreateOrgForExistingUserRequest(
        userId: userId,
        organizationData: organizationData,
        templateOrgId: templateOrgId,
      ),
    );

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final org = OrganizationData.fromJson(result.data as Map<String, dynamic>);
      return RemoteBaseModel(data: org, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> cloneOrganization({
    required String templateOrgId,
    required String targetOrgId,
    bool? overwrite,
  }) async {
    final result = await _organizationSource.cloneOrganization(
      request: OrganizationCloneRequest(
        templateOrgId: templateOrgId,
        targetOrgId: targetOrgId,
        overwrite: overwrite,
      ),
    );

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<bool>> setTemplateStatus({
    required String id,
    required bool isTemplate,
  }) async {
    final result = await _organizationSource.setTemplateStatus(
      id: id,
      isTemplate: isTemplate,
    );

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<bool>> deleteOrganization(String id) async {
    final result = await _organizationSource.deleteOrganization(id);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<OrganizationConfig>> getOrganizationConfig(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting organization config in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getOrganizationConfig",
      ),
    );
    final result = await _organizationSource.getOrganizationConfig(
      organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationConfig: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationConfig",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final configData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final config = OrganizationConfig.fromJson(configData);
      JDRepoConsole.success(
        "Organization config parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationConfig",
        ),
      );
      return RemoteBaseModel(data: config, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationConfig: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationConfig",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationConfig>> updateOrganizationConfig({
    required String organizationId,
    required OrganizationConfig config,
  }) async {
    JDRepoConsole.info(
      "Updating organization config in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationConfig",
      ),
    );
    final result = await _organizationSource.updateOrganizationConfig(
      organizationId: organizationId,
      configData: config.toJson(),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationConfig: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationConfig",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final configData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedConfig = OrganizationConfig.fromJson(configData);
      JDRepoConsole.success(
        "Organization config parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationConfig",
        ),
      );
      return RemoteBaseModel(data: updatedConfig, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationConfig: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationConfig",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationConfig>> updateOrganizationConfigSection({
    required String organizationId,
    required String section,
    required Map<String, dynamic> sectionData,
  }) async {
    JDRepoConsole.info(
      "Updating organization config section $section in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationConfigSection",
      ),
    );
    final result = await _organizationSource.updateOrganizationConfigSection(
      organizationId: organizationId,
      section: section,
      sectionData: sectionData,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationConfigSection: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationConfigSection",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final configData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedConfig = OrganizationConfig.fromJson(configData);
      JDRepoConsole.success(
        "Organization config section parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationConfigSection",
        ),
      );
      return RemoteBaseModel(data: updatedConfig, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationConfigSection: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationConfigSection",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  // Specific Methods for Config Sections

  Future<RemoteBaseModel<ThemesConfig>> getOrganizationThemes(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting organization themes in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getOrganizationThemes",
      ),
    );
    final result = await _organizationSource.getOrganizationConfigSection(
      organizationId: organizationId,
      section: 'themes',
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationThemes: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationThemes",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final themes = ThemesConfig.fromJson(data);
      JDRepoConsole.success(
        "Organization themes parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationThemes",
        ),
      );
      return RemoteBaseModel(data: themes, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationThemes: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationThemes",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<ThemesConfig>> updateOrganizationThemes({
    required String organizationId,
    required ThemesConfig themes,
  }) async {
    JDRepoConsole.info(
      "Updating organization themes in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationThemes",
      ),
    );
    final result = await _organizationSource.updateOrganizationConfigSection(
      organizationId: organizationId,
      section: 'themes',
      sectionData: themes.toJson(),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationThemes: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationThemes",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedThemes = ThemesConfig.fromJson(data);
      JDRepoConsole.success(
        "Organization themes updated and parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationThemes",
        ),
      );
      return RemoteBaseModel(data: updatedThemes, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationThemes: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationThemes",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<LayoutConfig>> getOrganizationLayout(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting organization layout in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getOrganizationLayout",
      ),
    );
    final result = await _organizationSource.getOrganizationConfigSection(
      organizationId: organizationId,
      section: 'layout',
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationLayout: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationLayout",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final layout = LayoutConfig.fromJson(data);
      JDRepoConsole.success(
        "Organization layout parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationLayout",
        ),
      );
      return RemoteBaseModel(data: layout, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationLayout: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationLayout",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<LayoutConfig>> updateOrganizationLayout({
    required String organizationId,
    required LayoutConfig layout,
  }) async {
    JDRepoConsole.info(
      "Updating organization layout in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationLayout",
      ),
    );
    final result = await _organizationSource.updateOrganizationConfigSection(
      organizationId: organizationId,
      section: 'layout',
      sectionData: layout.toJson(),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationLayout: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationLayout",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedLayout = LayoutConfig.fromJson(data);
      JDRepoConsole.success(
        "Organization layout updated and parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationLayout",
        ),
      );
      return RemoteBaseModel(data: updatedLayout, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationLayout: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationLayout",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<VisualConfig>> getOrganizationVisual(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting organization visual in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getOrganizationVisual",
      ),
    );
    final result = await _organizationSource.getOrganizationConfigSection(
      organizationId: organizationId,
      section: 'visual',
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationVisual: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationVisual",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final visual = VisualConfig.fromJson(data);
      JDRepoConsole.success(
        "Organization visual parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationVisual",
        ),
      );
      return RemoteBaseModel(data: visual, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationVisual: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationVisual",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<VisualConfig>> updateOrganizationVisual({
    required String organizationId,
    required VisualConfig visual,
  }) async {
    JDRepoConsole.info(
      "Updating organization visual in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationVisual",
      ),
    );
    final result = await _organizationSource.updateOrganizationConfigSection(
      organizationId: organizationId,
      section: 'visual',
      sectionData: visual.toJson(),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationVisual: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationVisual",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedVisual = VisualConfig.fromJson(data);
      JDRepoConsole.success(
        "Organization visual updated and parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationVisual",
        ),
      );
      return RemoteBaseModel(data: updatedVisual, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationVisual: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationVisual",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationPolicy>> getOrganizationPolicy(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting organization policy in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getOrganizationPolicy",
      ),
    );
    final result = await _organizationSource.getOrganizationPolicy(
      organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationPolicy: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationPolicy",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final policyData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final policy = OrganizationPolicy.fromJson(policyData);
      JDRepoConsole.success(
        "Organization policy parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationPolicy",
        ),
      );
      return RemoteBaseModel(data: policy, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationPolicy: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationPolicy",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationPolicy>> updateOrganizationPolicy({
    required String organizationId,
    required OrganizationPolicy policy,
  }) async {
    JDRepoConsole.info(
      "Updating organization policy in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationPolicy",
      ),
    );
    final result = await _organizationSource.updateOrganizationPolicy(
      organizationId: organizationId,
      policyData: policy.toJson(),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationPolicy: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationPolicy",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final policyData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedPolicy = OrganizationPolicy.fromJson(policyData);
      JDRepoConsole.success(
        "Organization policy parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationPolicy",
        ),
      );
      return RemoteBaseModel(data: updatedPolicy, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationPolicy: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationPolicy",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationPolicy>> updateOrganizationPolicySection({
    required String organizationId,
    required String section,
    required Map<String, dynamic> sectionData,
  }) async {
    JDRepoConsole.info(
      "Updating organization policy section $section in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "updateOrganizationPolicySection",
      ),
    );
    final result = await _organizationSource.updateOrganizationPolicySection(
      organizationId: organizationId,
      section: section,
      sectionData: sectionData,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrganizationPolicySection: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationPolicySection",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final policyData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final updatedPolicy = OrganizationPolicy.fromJson(policyData);
      JDRepoConsole.success(
        "Organization policy section parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationPolicySection",
        ),
      );
      return RemoteBaseModel(data: updatedPolicy, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOrganizationPolicySection: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "updateOrganizationPolicySection",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationConfig>> getOrganizationConfigByName(
    String orgName,
  ) async {
    JDRepoConsole.info(
      "Getting organization config by name in repo",
      context: LogContext(
        module: "OrganizationRepo",
        method: "getOrganizationConfigByName",
      ),
    );
    final result = await _organizationSource.getOrganizationConfigByName(
      orgName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationConfigByName: ${result.error?.message}",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationConfigByName",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final configData = result.data is Map && result.data['data'] != null
          ? result.data['data'] as Map<String, dynamic>
          : result.data as Map<String, dynamic>;

      final config = OrganizationConfig.fromJson(configData);
      JDRepoConsole.success(
        "Organization config by name parsed successfully",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationConfigByName",
        ),
      );
      return RemoteBaseModel(data: config, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationConfigByName: $e",
        context: LogContext(
          module: "OrganizationRepo",
          method: "getOrganizationConfigByName",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrganizationData>> updateOrganization({
    required String id,
    required Map<String, dynamic> updateData,
  }) async {
    final result = await _organizationSource.updateOrganization(
      id: id,
      updateData: updateData,
    );
    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }
    try {
      return RemoteBaseModel(
        data: OrganizationData.fromJson(result.data as Map<String, dynamic>),
        status: StatusModel.success,
      );
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنظمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> activateOrganization(String id) async {
    final result = await _organizationSource.activateOrganization(id);
    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<bool>> deactivateOrganization(String id) async {
    final result = await _organizationSource.deactivateOrganization(id);
    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}


