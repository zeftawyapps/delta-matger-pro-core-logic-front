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
    } catch (e) {
      return _catchError("login", e);
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
    } catch (e) {
      return _catchError("loginOrg", e);
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
      return _wrap(result);
    } catch (e) {
      return _catchError("register", e);
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
      return _wrap(result);
    } catch (e) {
      return _catchError("getProfile", e);
    }
  }

  Result<RemoteBaseModel, dynamic> _wrap(
    Result<RemoteBaseModel, RemoteBaseModel> result,
  ) {
    if (result.data?.status == StatusModel.success) {
      return Result.data(result.data?.data);
    }

    String? message = result.error?.message ?? result.data?.message;

    if (result.data?.data is Map) {
      final dataMap = result.data?.data as Map;
      final msg = dataMap['message'] ??
          dataMap['error'] ??
          dataMap['errors'] ??
          dataMap['detail'];
      if (msg != null) {
        if (msg is List) {
          message = msg.join(', ');
        } else {
          message = msg.toString();
        }
      }
    }

    return Result.error(
      RemoteBaseModel(
        message: message ?? 'خطأ غير معروف',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "AuthSource", method: method),
    );

    String message = "حدث خطأ غير متوقع";
    dynamic errorData;

    if (e is DioException) {
      errorData = e.response?.data;
      if (errorData is Map) {
        final msg = errorData['message'] ??
            errorData['error'] ??
            errorData['errors'] ??
            errorData['detail'];
        if (msg != null) {
          if (msg is List) {
            message = msg.join(', ');
          } else {
            message = msg.toString();
          }
        } else {
          message = e.message ?? "خطأ في الاتصال بالسيرفر";
        }
      } else {
        message = e.message ?? "خطأ في الاتصال بالسيرفر";
      }
    } else {
      message = e.toString();
    }

    return Result.error(
      RemoteBaseModel(
        message: message,
        status: StatusModel.error,
        data: errorData,
      ),
    );
  }
}
