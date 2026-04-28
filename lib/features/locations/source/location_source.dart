import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:matger_pro_core_logic/features/locations/data/location_models.dart';

class LocationSource {
  LocationSource();

  Future<Result<RemoteBaseModel, dynamic>> getCountries() async {
    try {
      JDRepoConsole.info(
        "Fetching countries",
        context: LogContext(module: "LocationSource", method: "getCountries"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.countries}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Countries fetched successfully",
          context: LogContext(module: "LocationSource", method: "getCountries"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getCountries", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getGovernorates() async {
    try {
      JDRepoConsole.info(
        "Fetching governorates",
        context: LogContext(module: "LocationSource", method: "getGovernorates"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.governorates}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Governorates fetched successfully",
          context:
              LogContext(module: "LocationSource", method: "getGovernorates"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getGovernorates", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getGovernoratesOfCountry(
    String countryId,
  ) async {
    try {
      JDRepoConsole.info(
        "Fetching governorates for country: $countryId",
        context:
            LogContext(module: "LocationSource", method: "getGovernoratesOfCountry"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.governoratesOfCountry(countryId)}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Governorates for country fetched successfully",
          context:
              LogContext(module: "LocationSource", method: "getGovernoratesOfCountry"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getGovernoratesOfCountry", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> addGovernorate(
    Governorate governorate,
  ) async {
    try {
      JDRepoConsole.info(
        "Adding governorate: ${governorate.name.ar}",
        context: LogContext(module: "LocationSource", method: "addGovernorate"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.governorates}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: governorate.toJson(),
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Governorate added successfully",
          context: LogContext(module: "LocationSource", method: "addGovernorate"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("addGovernorate", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getCitiesOfGovernorate(
    String governorateId,
  ) async {
    try {
      JDRepoConsole.info(
        "Fetching cities for governorate: $governorateId",
        context:
            LogContext(module: "LocationSource", method: "getCitiesOfGovernorate"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.citiesInGovernorate(governorateId)}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Cities fetched successfully",
          context: LogContext(
            module: "LocationSource",
            method: "getCitiesOfGovernorate",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getCitiesOfGovernorate", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> addCity(City city) async {
    try {
      JDRepoConsole.info(
        "Adding city: ${city.name.ar}",
        context: LogContext(module: "LocationSource", method: "addCity"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.cities}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: city.toJson(),
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "City added successfully",
          context: LogContext(module: "LocationSource", method: "addCity"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("addCity", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> seedLocationData() async {
    try {
      JDRepoConsole.info(
        "Seeding location data",
        context: LogContext(module: "LocationSource", method: "seedLocationData"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.seedLocations}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Location data seeded successfully",
          context: LogContext(module: "LocationSource", method: "seedLocationData"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("seedLocationData", e);
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
      context: LogContext(module: "LocationSource", method: method),
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
