import 'dart:typed_data';
import 'package:matger_core_logic/features/commrec/repo/product_repo.dart';
import 'package:matger_core_logic/features/commrec/data/product_model.dart';
import 'package:matger_core_logic/utls/bloc/base_bloc.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:matger_core_logic/utls/bloc/remote_base_model.dart';

class ProductBloc {
  static final ProductBloc _singleton = ProductBloc._internal();
  factory ProductBloc() => _singleton;
  ProductBloc._internal();

  final ProductRepo _repo = ProductRepo();

  final DataSourceBloc<ProductData> productDataBloc =
      DataSourceBloc<ProductData>();
  final DataSourceBloc<List<ProductData>> productsListBloc =
      DataSourceBloc<List<ProductData>>();
  final DataSourceBloc<Map<String, dynamic>> rawDataBloc =
      DataSourceBloc<Map<String, dynamic>>();

  Future<void> createProduct({
    required dynamic name,
    required String categoryId,
    required String shopId,
    required double price,
    Uint8List? imageBytes,
    String? imageName,
    Map<String, dynamic>? additionalData,
    bool isNew = false,
    bool isBestSeller = false,
    bool isOnSale = false,
    bool isJoker = false,
    bool isSuperJoker = false,
    bool isAvailable = true,
    double? oldPrice,
    double? discount,
    List<PriceOption>? priceOptions,
  }) async {
    productDataBloc.loadingState();
    rawDataBloc.loadingState();

    final result = await _repo.createProduct(
      name: name,
      categoryId: categoryId,
      organizationId: shopId,
      price: price,
      imageBytes: imageBytes,
      imageName: imageName,
      additionalData: additionalData,
      isNew: isNew,
      isBestSeller: isBestSeller,
      isOnSale: isOnSale,
      isJoker: isJoker,
      isSuperJoker: isSuperJoker,
      isAvailable: isAvailable,
      oldPrice: oldPrice,
      discount: discount,
      priceOptions: priceOptions,
    );

    if (result.status == StatusModel.success && result.data != null) {
      productDataBloc.successState(result.data!);
      rawDataBloc.successState(result.data!.toJson());
    } else {
      productDataBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to create product"),
        () => createProduct(
          name: name,
          categoryId: categoryId,
          shopId: shopId,
          price: price,
          imageBytes: imageBytes,
          imageName: imageName,
          additionalData: additionalData,
          isNew: isNew,
          isBestSeller: isBestSeller,
          isOnSale: isOnSale,
          isJoker: isJoker,
          isSuperJoker: isSuperJoker,
          isAvailable: isAvailable,
          oldPrice: oldPrice,
          discount: discount,
          priceOptions: priceOptions,
        ),
      );
    }
  }

  Future<void> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    productDataBloc.loadingState();
    rawDataBloc.loadingState();

    final result = await _repo.updateProduct(
      productId: productId,
      data: data,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.status == StatusModel.success && result.data != null) {
      productDataBloc.successState(result.data!);
      rawDataBloc.successState(result.data!.toJson());
    } else {
      productDataBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to update product"),
        () => updateProduct(
          productId: productId,
          data: data,
          imageBytes: imageBytes,
          imageName: imageName,
        ),
      );
    }
  }

  Future<void> getProducts({int page = 1, int limit = 10}) async {
    productsListBloc.loadingState();
    rawDataBloc.loadingState();

    final result = await _repo.getProducts(page: page, limit: limit);

    if (result.status == StatusModel.success && result.data != null) {
      productsListBloc.successState(result.data!);
      rawDataBloc.successState({
        "count": result.data!.length,
        "items": result.data!.map((e) => e.toJson()).toList(),
      });
    } else {
      productsListBloc.failedState(
        ErrorStateModel(message: result.message ?? "Failed to get products"),
        () => getProducts(page: page, limit: limit),
      );
    }
  }
}
