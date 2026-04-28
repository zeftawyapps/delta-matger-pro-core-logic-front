import 'package:matger_pro_core_logic/features/commrec/data/offer_model.dart';
import 'package:matger_pro_core_logic/features/commrec/source/offer_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'dart:typed_data';

class OfferRepo {
  late final OfferSource _offerSource;

  OfferRepo({OfferSource? offerSource}) {
    _offerSource = offerSource ?? OfferSource();
  }

  Future<RemoteBaseModel<OfferData>> createOffer({
    required Map<String, String> name,
    required String organizationId,
    Map<String, String>? description,
    required String targetType,
    required String targetId,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool isActive = true,
    int? sortOrder,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    JDRepoConsole.info(
      "Creating offer in repo",
      context: LogContext(module: "OfferRepo", method: "createOffer"),
    );
    final result = await _offerSource.createOffer(
      name: name,
      organizationId: organizationId,
      description: description,
      targetType: targetType,
      targetId: targetId,
      discountPercentage: discountPercentage,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      sortOrder: sortOrder,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createOffer: ${result.error?.message}",
        context: LogContext(module: "OfferRepo", method: "createOffer"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final Map<String, dynamic> data;
      if (rawData is Map<String, dynamic>) {
        data = (rawData.containsKey('data') && rawData['data'] is Map)
            ? rawData['data'] as Map<String, dynamic>
            : rawData;
      } else {
        throw "Unexpected response data format";
      }

      final offer = OfferData.fromJson(data);
      JDRepoConsole.success(
        "Offer parsed successfully in repo",
        context: LogContext(module: "OfferRepo", method: "createOffer"),
      );
      return RemoteBaseModel(data: offer, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createOffer: $e",
        context: LogContext(
          module: "OfferRepo",
          method: "createOffer",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في إنشاء العرض",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<OfferData>>> getOffersByOrganization(
    String organizationId, {
    String? lang,
    bool? activeOnly,
  }) async {
    JDRepoConsole.info(
      "Getting offers for organization: $organizationId",
      context: LogContext(
        module: "OfferRepo",
        method: "getOffersByOrganization",
      ),
    );
    final result = await _offerSource.getOffersByOrganization(
      organizationId,
      lang: lang,
      activeOnly: activeOnly,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOffersByOrganization: ${result.error?.message}",
        context: LogContext(
          module: "OfferRepo",
          method: "getOffersByOrganization",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List offersList;

      if (rawData is List) {
        offersList = rawData;
      } else if (rawData is Map) {
        final data = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('offers') && rawData['offers'] is List)
            ? rawData['offers'] as List
            : [];
        offersList = data;
      } else {
        offersList = [];
      }

      final offers = offersList
          .map((e) => OfferData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${offers.length} offers successfully",
        context: LogContext(
          module: "OfferRepo",
          method: "getOffersByOrganization",
        ),
      );
      return RemoteBaseModel(data: offers, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOffersByOrganization: $e",
        context: LogContext(
          module: "OfferRepo",
          method: "getOffersByOrganization",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب العروض",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OfferData>> getOfferById(
    String offerId, {
    String? lang,
  }) async {
    JDRepoConsole.info(
      "Getting offer by ID: $offerId",
      context: LogContext(module: "OfferRepo", method: "getOfferById"),
    );
    final result = await _offerSource.getOfferById(offerId, lang: lang);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOfferById: ${result.error?.message}",
        context: LogContext(module: "OfferRepo", method: "getOfferById"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final Map<String, dynamic> data;
      if (rawData is Map<String, dynamic>) {
        data = (rawData.containsKey('data') && rawData['data'] is Map)
            ? rawData['data'] as Map<String, dynamic>
            : rawData;
      } else {
        throw "Unexpected response data format";
      }

      final offer = OfferData.fromJson(data);
      return RemoteBaseModel(data: offer, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOfferById: $e",
        context: LogContext(
          module: "OfferRepo",
          method: "getOfferById",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب بيانات العرض",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OfferData>> updateOffer({
    required String offerId,
    Map<String, String>? name,
    Map<String, String>? description,
    String? targetType,
    String? targetId,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? sortOrder,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    JDRepoConsole.info(
      "Updating offer in repo: $offerId",
      context: LogContext(module: "OfferRepo", method: "updateOffer"),
    );
    final result = await _offerSource.updateOffer(
      offerId: offerId,
      name: name,
      description: description,
      targetType: targetType,
      targetId: targetId,
      discountPercentage: discountPercentage,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      sortOrder: sortOrder,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOffer: ${result.error?.message}",
        context: LogContext(module: "OfferRepo", method: "updateOffer"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final Map<String, dynamic> data;
      if (rawData is Map<String, dynamic>) {
        data = (rawData.containsKey('data') && rawData['data'] is Map)
            ? rawData['data'] as Map<String, dynamic>
            : rawData;
      } else {
        throw "Unexpected response data format";
      }

      final offer = OfferData.fromJson(data);
      JDRepoConsole.success(
        "Offer updated and parsed successfully",
        context: LogContext(module: "OfferRepo", method: "updateOffer"),
      );
      return RemoteBaseModel(data: offer, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateOffer: $e",
        context: LogContext(
          module: "OfferRepo",
          method: "updateOffer",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تحديث العرض",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> deleteOffer(String offerId) async {
    JDRepoConsole.info(
      "Deleting offer in repo: $offerId",
      context: LogContext(module: "OfferRepo", method: "deleteOffer"),
    );
    final result = await _offerSource.deleteOffer(offerId);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in deleteOffer: ${result.error?.message}",
        context: LogContext(module: "OfferRepo", method: "deleteOffer"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      "Offer deleted successfully in repo",
      context: LogContext(module: "OfferRepo", method: "deleteOffer"),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}
