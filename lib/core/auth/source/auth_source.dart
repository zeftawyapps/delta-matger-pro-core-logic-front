import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class AuthSource {
  Future<Result<RemoteBaseModel, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      JDRepoConsole.info(
        "Attempting login for: $username",
        context: LogContext(module: "AuthSource", method: "login"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.login}";
      final data = await HttpClient(userToken: false).sendRequestJsonMap(
        method: HttpMethod.POST,
        url: url,
        body: {"emailOrUsername": username, "password": password},
        cancelToken: CancelToken(),
      );

      JDRepoConsole.success(
        "Login request successful",
        context: LogContext(module: "AuthSource", method: "login"),
      );
      return Result.data(data);
    } on DioError catch (e) {
      JDRepoConsole.error(
        "Login DioError: ${e.message}",
        context: LogContext(
          module: "AuthSource",
          method: "login",
          metadata: e.response?.data,
        ),
      );

      final errorMessage = (e.response?.data is Map)
          ? e.response?.data['message']?.toString() ?? e.message
          : e.message;

      return Result.error(
        RemoteBaseModel(
          message: errorMessage,
          status: StatusModel.error,
          data: e.response?.data,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Login Error: $e",
        context: LogContext(module: "AuthSource", method: "login"),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> loginOrg({
    required String orgName,
    required String username,
    required String password,
  }) async {
    try {
      JDRepoConsole.info(
        "Attempting login for: $username in $orgName",
        context: LogContext(module: "AuthSource", method: "loginOrg"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orgLogin(orgName)}";
      final data = await HttpClient(userToken: false).sendRequestJsonMap(
        method: HttpMethod.POST,
        url: url,
        body: {"emailOrUsername": username, "password": password},
        cancelToken: CancelToken(),
      );

      JDRepoConsole.success(
        "Login request successful for organization",
        context: LogContext(module: "AuthSource", method: "loginOrg"),
      );
      return Result.data(data);
    } on DioError catch (e) {
      JDRepoConsole.error(
        "LoginOrg DioError: ${e.message}",
        context: LogContext(
          module: "AuthSource",
          method: "loginOrg",
          metadata: e.response?.data,
        ),
      );

      final errorMessage = (e.response?.data is Map)
          ? e.response?.data['message']?.toString() ?? e.message
          : e.message;

      return Result.error(
        RemoteBaseModel(
          message: errorMessage,
          status: StatusModel.error,
          data: e.response?.data,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "LoginOrg Error: $e",
        context: LogContext(module: "AuthSource", method: "loginOrg"),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> register({
    required Map<String, dynamic> userData,
  }) async {
    try {
      JDRepoConsole.info(
        "Attempting register",
        context: LogContext(module: "AuthSource", method: "register"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.register}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: userData,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Register successful",
          context: LogContext(module: "AuthSource", method: "register"),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Register failed",
        context: LogContext(
          module: "AuthSource",
          method: "register",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Register Error: $e",
        context: LogContext(module: "AuthSource", method: "register"),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getProfile() async {
    try {
      JDRepoConsole.info(
        "Fetching profile",
        context: LogContext(module: "AuthSource", method: "getProfile"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.profile}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Profile fetched successfully",
          context: LogContext(module: "AuthSource", method: "getProfile"),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to fetch profile",
        context: LogContext(
          module: "AuthSource",
          method: "getProfile",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "GetProfile Error: $e",
        context: LogContext(module: "AuthSource", method: "getProfile"),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }
}
