import 'package:matger_pro_core_logic/models/app_settings.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import '../source/test_page_source.dart';

class TestRepo {
  late final TestPageSource _landingPageSource;

  TestRepo({TestPageSource? landingPageSource}) {
    _landingPageSource = landingPageSource ?? TestPageSource();
  }

  /// Retrieves landing page data from the source and converts it to AppSettings model.
  Future<RemoteBaseModel<AppSettings>> getLandingData({
    Map<String, dynamic>? mockData,
  }) async {
    JDRepoConsole.info(
      "Getting landing data in repo",
      context: LogContext(module: "TestRepo", method: "getLandingData"),
    );
    final result = await _landingPageSource.getTestPages(
      mockResponse: mockData,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getLandingData: ${result.error?.message}",
        context: LogContext(module: "TestRepo", method: "getLandingData"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    if (result.data != null) {
      try {
        final settings = AppSettings.fromJson(result.data!);
        JDRepoConsole.success(
          "Landing data parsed successfully in repo",
          context: LogContext(module: "TestRepo", method: "getLandingData"),
        );
        return RemoteBaseModel(data: settings, status: StatusModel.success);
      } catch (e) {
        JDRepoConsole.error(
          "Parsing error in getLandingData: $e",
          context: LogContext(
            module: "TestRepo",
            method: "getLandingData",
            metadata: result.data,
          ),
        );
        return RemoteBaseModel(
          status: StatusModel.error,
          message: result.error?.message ?? "خطأ في معالجة البيانات التجريبية",
          data: null,
        );
      }
    }

    JDRepoConsole.warn(
      "No data found in getLandingData",
      context: LogContext(module: "TestRepo", method: "getLandingData"),
    );
    return RemoteBaseModel(status: StatusModel.error, message: "No data found");
  }
}
