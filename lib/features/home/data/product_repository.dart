import 'package:cifarx_test/core/network/network_response.dart';
import 'package:cifarx_test/core/utils/get_storage_model.dart';
import 'package:cifarx_test/features/home/data/product_data.dart';
import 'package:cifarx_test/features/home/presentation/models/product_response_model.dart';



class ProductsRepository {
  final ProductsDataSource _dataSource;
  final GetStorageModel _storage;

  ProductsRepository(this._dataSource, this._storage);

  static const String _productsKey = 'cached_products';
  static const String _lastFetchKey = 'last_fetch_time';
  static const int _cacheValidityMinutes = 10;

  Future<ProductsResponseModel> fetchProducts({
    required int skip,
    bool forceRefresh = false,
  }) async {
    // Check cache first if skip is 0 (first page) and not forcing refresh
    if (skip == 0 && !forceRefresh) {
      final ProductsResponseModel? cachedData = _getCachedProducts();
      if (cachedData != null && _isCacheValid()) {
        return cachedData;
      }
    }

    final NetworkResponse response = await _dataSource.fetchProducts(skip: skip);

    if (!response.isSuccess) {
      // If network fails and we have cache, return cached data
      if (skip == 0) {
        final ProductsResponseModel? cachedData = _getCachedProducts();
        if (cachedData != null) {
          return cachedData;
        }
      }

      throw Exception(
        response.errorMessage ?? 'Failed to fetch products',
      );
    }

    final ProductsResponseModel productsResponse =
    ProductsResponseModel.fromJson(response.jsonResponse!);

    // Cache first page data
    if (skip == 0) {
      await _cacheProducts(productsResponse);
    }

    return productsResponse;
  }

  Future<ProductsResponseModel> searchProducts({
    required String query,
    required int skip,
  }) async {
    final NetworkResponse response = await _dataSource.searchProducts(
      query: query,
      skip: skip,
    );

    if (!response.isSuccess) {
      throw Exception(
        response.errorMessage ?? 'Failed to search products',
      );
    }

    return ProductsResponseModel.fromJson(response.jsonResponse!);
  }

  ProductsResponseModel? _getCachedProducts() {
    try {
      final Map<String, dynamic>? cachedMap = _storage.getMap(_productsKey);
      if (cachedMap != null) {
        return ProductsResponseModel.fromJson(cachedMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool _isCacheValid() {
    try {
      final DateTime? lastFetch = _storage.getDateTime(_lastFetchKey);
      if (lastFetch == null) return false;

      final Duration difference = DateTime.now().difference(lastFetch);
      return difference.inMinutes < _cacheValidityMinutes;
    } catch (e) {
      return false;
    }
  }

  Future<void> _cacheProducts(ProductsResponseModel response) async {
    try {
      await _storage.saveMap(_productsKey, response.toJson());
      await _storage.saveDateTime(_lastFetchKey, DateTime.now());
    } catch (e) {
      // Silently fail caching
    }
  }

  Future<void> clearCache() async {
    await _storage.delete(_productsKey);
    await _storage.delete(_lastFetchKey);
  }
}