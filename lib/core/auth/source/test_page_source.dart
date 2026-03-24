import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class TestPageSource {
  /// Fetches test page data.
  ///
  /// [mockResponse] optionally provides raw mock data for testing (text connection).
  Future<Result<RemoteBaseModel, Map<String, dynamic>>> getTestPages({
    Map<String, dynamic>? mockResponse,
  }) async {
    // If mock response is provided (text connection phase), return it immediately.
    if (mockResponse != null) {
      return Result.data(mockResponse);
    }

    try {
      JDRepoConsole.info("Fetching test pages",
          context: LogContext(module: "TestPageSource", method: "getTestPages"));
      // Fetch data from API
      String url = "${ApiUrls.BASE_URL}${EndPoints.test}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success("Test pages fetched successfully",
            context: LogContext(module: "TestPageSource", method: "getTestPages"));
        final data = result.data?.data;
        if (data is Map<String, dynamic>) {
          return Result.data(data);
        }
        return Result.data({});
      } else {
        JDRepoConsole.error("Failed to fetch test pages",
            context: LogContext(
                module: "TestPageSource",
                method: "getTestPages",
                metadata: result.error));
        return Result.error(
          RemoteBaseModel(
            message: result.error?.message,
            status: result.data?.status ?? StatusModel.error,
          ),
        );
      }
    } catch (e) {
      JDRepoConsole.error("Error fetching test pages: $e",
          context: LogContext(module: "TestPageSource", method: "getTestPages"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }
}
