import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:matger_pro_core_logic/core/system/data/language_model.dart';
import 'package:matger_pro_core_logic/core/system/data/system_models.dart';

class SystemSource {
  SystemSource();

  Future<Result<RemoteBaseModel, dynamic>> getLanguages() async {
    try {
      JDRepoConsole.info(
        "Fetching languages",
        context: LogContext(module: "SystemSource", method: "getLanguages"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.languages}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Languages fetched successfully",
          context: LogContext(module: "SystemSource", method: "getLanguages"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getLanguages", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> addLanguage(
    Language language,
  ) async {
    try {
      JDRepoConsole.info(
        "Adding language: ${language.name}",
        context: LogContext(module: "SystemSource", method: "addLanguage"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.languages}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: language.toJson(),
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Language added successfully",
          context: LogContext(module: "SystemSource", method: "addLanguage"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("addLanguage", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getSystemInfo() async {
    try {
      JDRepoConsole.info(
        "Fetching system info",
        context: LogContext(module: "SystemSource", method: "getSystemInfo"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.systemInfo}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "System info fetched successfully",
          context: LogContext(module: "SystemSource", method: "getSystemInfo"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getSystemInfo", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> bootstrapSystem(
    BootstrapRequest request,
    String systemKey,
  ) async {
    try {
      JDRepoConsole.info(
        "Bootstrapping system",
        context: LogContext(module: "SystemSource", method: "bootstrapSystem"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.bootstrap}";

      // We pass the x-system-key in the headers
      dynamic body;
      if (request.logoPath != null) {
        body = FormData.fromMap({
          ...request.toJson(),
          'logo': await MultipartFile.fromFile(
            request.logoPath!,
            filename: request.logoPath!.split('/').last,
          ),
        });
      } else {
        body = request.toJson();
      }

      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: body,
        headers: {"x-system-key": systemKey},
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "System bootstrapped successfully",
          context: LogContext(
            module: "SystemSource",
            method: "bootstrapSystem",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("bootstrapSystem", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> seedLanguages() async {
    try {
      JDRepoConsole.info(
        "Seeding languages",
        context: LogContext(module: "SystemSource", method: "seedLanguages"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.seedLanguages}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Languages seeded successfully",
          context: LogContext(module: "SystemSource", method: "seedLanguages"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("seedLanguages", e);
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
      final msg =
          dataMap['message'] ??
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
        message: message ?? 'خطأ غير معروف في الباك اند',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "SystemSource", method: method),
    );

    String message = "حدث خطأ غير متوقع";
    dynamic errorData;

    if (e is DioError) {
      errorData = e.response?.data;
      if (errorData is Map) {
        final msg =
            errorData['message'] ??
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
