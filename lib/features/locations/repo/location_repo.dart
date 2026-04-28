import 'package:matger_pro_core_logic/features/locations/data/location_models.dart';
import 'package:matger_pro_core_logic/features/locations/source/location_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class LocationRepo {
  final LocationSource _locationSource;

  LocationRepo({LocationSource? locationSource})
    : _locationSource = locationSource ?? LocationSource();

  Future<RemoteBaseModel<List<Country>>> getCountries() async {
    JDRepoConsole.info(
      "Getting countries in repo",
      context: LogContext(module: "LocationRepo", method: "getCountries"),
    );
    final result = await _locationSource.getCountries();

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
      final list = listData.map((json) => Country.fromJson(json)).toList();
      return RemoteBaseModel(data: list, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getCountries: $e",
        context: LogContext(module: "LocationRepo", method: "getCountries"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب قائمة الدول",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<Governorate>>> getGovernorates() async {
    JDRepoConsole.info(
      "Getting governorates in repo",
      context: LogContext(module: "LocationRepo", method: "getGovernorates"),
    );
    final result = await _locationSource.getGovernorates();

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
      final list = listData.map((json) => Governorate.fromJson(json)).toList();
      return RemoteBaseModel(data: list, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getGovernorates: $e",
        context: LogContext(module: "LocationRepo", method: "getGovernorates"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب قائمة المحافظات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<Governorate>>> getGovernoratesOfCountry(
    String countryId,
  ) async {
    JDRepoConsole.info(
      "Getting governorates for $countryId in repo",
      context:
          LogContext(module: "LocationRepo", method: "getGovernoratesOfCountry"),
    );
    final result = await _locationSource.getGovernoratesOfCountry(countryId);

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
      final list = listData.map((json) => Governorate.fromJson(json)).toList();
      return RemoteBaseModel(data: list, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب المحافظات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<Governorate>> addGovernorate(
    Governorate governorate,
  ) async {
    JDRepoConsole.info(
      "Adding governorate in repo",
      context: LogContext(module: "LocationRepo", method: "addGovernorate"),
    );
    final result = await _locationSource.addGovernorate(governorate);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data['data'] ?? result.data;
      final item = Governorate.fromJson(data);
      return RemoteBaseModel(data: item, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في إضافة المحافظة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<City>>> getCitiesOfGovernorate(
    String governorateId,
  ) async {
    JDRepoConsole.info(
      "Getting cities for $governorateId in repo",
      context:
          LogContext(module: "LocationRepo", method: "getCitiesOfGovernorate"),
    );
    final result = await _locationSource.getCitiesOfGovernorate(governorateId);

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
      final list = listData.map((json) => City.fromJson(json)).toList();
      return RemoteBaseModel(data: list, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب المدن",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<City>> addCity(City city) async {
    JDRepoConsole.info(
      "Adding city in repo",
      context: LogContext(module: "LocationRepo", method: "addCity"),
    );
    final result = await _locationSource.addCity(city);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data['data'] ?? result.data;
      final item = City.fromJson(data);
      return RemoteBaseModel(data: item, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في إضافة المدينة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> seedLocationData() async {
    JDRepoConsole.info(
      "Seeding location data in repo",
      context: LogContext(module: "LocationRepo", method: "seedLocationData"),
    );
    final result = await _locationSource.seedLocationData();

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success, message: "تم تهيئة البيانات بنجاح");
  }
}
