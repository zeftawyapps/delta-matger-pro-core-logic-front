import 'package:matger_pro_core_logic/core/system/data/language_model.dart';
import 'package:matger_pro_core_logic/core/system/data/system_models.dart';
import 'package:matger_pro_core_logic/core/system/source/system_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class SystemRepo {
  final SystemSource _systemSource;

  SystemRepo({SystemSource? systemSource})
      : _systemSource = systemSource ?? SystemSource();

  Future<RemoteBaseModel<List<Language>>> getLanguages() async {
    JDRepoConsole.info(
      "Getting languages in repo",
      context: LogContext(module: "SystemRepo", method: "getLanguages"),
    );
    final result = await _systemSource.getLanguages();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data;
      final List listData;
      if (data is List) {
        listData = data;
      } else if (data is Map && data['data'] is List) {
        listData = data['data'];
      } else {
        listData = [];
      }
      final list = listData.map((json) => Language.fromJson(json)).toList();
      return RemoteBaseModel(data: list, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getLanguages: $e",
        context: LogContext(module: "SystemRepo", method: "getLanguages"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب اللغات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<Language>> addLanguage(Language language) async {
    JDRepoConsole.info(
      "Adding language in repo",
      context: LogContext(module: "SystemRepo", method: "addLanguage"),
    );
    final result = await _systemSource.addLanguage(language);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data['data'] ?? result.data;
      final item = Language.fromJson(data);
      return RemoteBaseModel(data: item, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في إضافة اللغة",
        data: null,
      );
    }
  }
  Future<RemoteBaseModel<SystemInfo>> getSystemInfo() async {
    JDRepoConsole.info(
      "Getting system info in repo",
      context: LogContext(module: "SystemRepo", method: "getSystemInfo"),
    );
    final result = await _systemSource.getSystemInfo();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data['data'] ?? result.data;
      final info = SystemInfo.fromJson(data);
      return RemoteBaseModel(data: info, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب بيانات النظام",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> bootstrapSystem(
    BootstrapRequest request,
    String systemKey,
  ) async {
    JDRepoConsole.info(
      "Bootstrapping system in repo",
      context: LogContext(module: "SystemRepo", method: "bootstrapSystem"),
    );
    final result = await _systemSource.bootstrapSystem(request, systemKey);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<bool>> seedLanguages() async {
    JDRepoConsole.info(
      "Seeding languages in repo",
      context: LogContext(module: "SystemRepo", method: "seedLanguages"),
    );
    final result = await _systemSource.seedLanguages();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}
