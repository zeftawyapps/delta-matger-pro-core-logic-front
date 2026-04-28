import 'package:matger_pro_core_logic/features/commrec/data/category_model.dart';
import 'package:matger_pro_core_logic/features/commrec/source/category_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'dart:typed_data';

class CategoryRepo {
  late final CategorySource _categorySource;

  CategoryRepo({CategorySource? categorySource}) {
    _categorySource = categorySource ?? CategorySource();
  }

  Future<RemoteBaseModel<CategoryData>> createCategory({
    required String name,
    required String shopId,
    String? description,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    JDRepoConsole.info(
      "Creating category in repo: $name",
      context: LogContext(module: "CategoryRepo", method: "createCategory"),
    );
    final result = await _categorySource.createCategory(
      name: name,
      shopId: shopId,
      description: description,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createCategory: ${result.error?.message}",
        context: LogContext(module: "CategoryRepo", method: "createCategory"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final category = CategoryData.fromJson(data);
      JDRepoConsole.success(
        "Category parsed successfully in repo",
        context: LogContext(module: "CategoryRepo", method: "createCategory"),
      );
      return RemoteBaseModel(data: category, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createCategory: $e",
        context: LogContext(
          module: "CategoryRepo",
          method: "createCategory",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة البيانات المستلمة",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<CategoryData>>> getCategoriesByOrganization(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting categories for organization: $organizationId",
      context: LogContext(
        module: "CategoryRepo",
        method: "getCategoriesByOrganization",
      ),
    );
    final result = await _categorySource.getCategoriesByOrganization(
      organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getCategoriesByOrganization: ${result.error?.message}",
        context: LogContext(
          module: "CategoryRepo",
          method: "getCategoriesByOrganization",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List categoriesList;

      if (rawData is List) {
        categoriesList = rawData;
      } else if (rawData is Map) {
        final data = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('categories') &&
                  rawData['categories'] is List)
            ? rawData['categories'] as List
            : [];
        categoriesList = data;
      } else {
        categoriesList = [];
      }

      final categories = categoriesList
          .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${categories.length} categories successfully",
        context: LogContext(
          module: "CategoryRepo",
          method: "getCategoriesByOrganization",
        ),
      );
      return RemoteBaseModel(data: categories, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getCategoriesByOrganization: $e",
        context: LogContext(
          module: "CategoryRepo",
          method: "getCategoriesByOrganization",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في عرض البيانات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<CategoryData>> updateCategory({
    required String categoryId,
    String? name,
    bool? isActive,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    JDRepoConsole.info(
      "Updating category in repo: $categoryId",
      context: LogContext(module: "CategoryRepo", method: "updateCategory"),
    );
    final result = await _categorySource.updateCategory(
      categoryId: categoryId,
      name: name,
      isActive: isActive,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateCategory: ${result.error?.message}",
        context: LogContext(module: "CategoryRepo", method: "updateCategory"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final category = CategoryData.fromJson(data);
      JDRepoConsole.success(
        "Category updated and parsed successfully in repo",
        context: LogContext(module: "CategoryRepo", method: "updateCategory"),
      );
      return RemoteBaseModel(data: category, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateCategory: $e",
        context: LogContext(
          module: "CategoryRepo",
          method: "updateCategory",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تعديل البيانات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> deleteCategory(String categoryId) async {
    JDRepoConsole.info(
      "Deleting category in repo: $categoryId",
      context: LogContext(module: "CategoryRepo", method: "deleteCategory"),
    );
    final result = await _categorySource.deleteCategory(categoryId);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in deleteCategory: ${result.error?.message}",
        context: LogContext(module: "CategoryRepo", method: "deleteCategory"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      "Category deleted successfully in repo",
      context: LogContext(module: "CategoryRepo", method: "deleteCategory"),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}
