import 'package:cifarx_test/core/config/app_url.dart';
import 'package:cifarx_test/features/home/presentation/models/product_response_model.dart';

import '../../../core/network/network_caller.dart';
import '../../../core/network/network_response.dart';

class ProductsDataSource {
  final NetworkCaller _networkCaller;

  ProductsDataSource(this._networkCaller);

  static const String _baseUrl = AppUrl.baseUrl;
  static const int _limit = 10;

  Future<NetworkResponse> fetchProducts({required int skip}) async {
    try {
      final NetworkResponse response = await _networkCaller.getRequest(
        '$_baseUrl/products?limit=$_limit&skip=$skip',
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final ProductsResponseModel productsResponse =
        ProductsResponseModel.fromJson(response.jsonResponse!);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          jsonResponse: productsResponse.toJson(),
        );
      }


      return response;
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Failed to fetch products: ${e.toString()}',
      );
    }
  }

  Future<NetworkResponse> searchProducts({
    required String query,
    required int skip,
  }) async {
    try {
      final NetworkResponse response = await _networkCaller.getRequest(
        '$_baseUrl/products/search?q=$query&limit=$_limit&skip=$skip',
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final ProductsResponseModel productsResponse =
        ProductsResponseModel.fromJson(response.jsonResponse!);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          jsonResponse: productsResponse.toJson(),
        );
      }

      return response;
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Failed to search products: ${e.toString()}',
      );
    }
  }
}