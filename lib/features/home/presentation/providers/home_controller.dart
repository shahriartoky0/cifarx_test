import 'package:cifarx_test/features/home/data/product_repository.dart';
import 'package:cifarx_test/features/home/presentation/models/home_state_model.dart';
import 'package:cifarx_test/features/home/presentation/models/product_model.dart';
import 'package:cifarx_test/features/home/presentation/models/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class HomeProvider extends StateNotifier<HomeState> {
  final ProductsRepository _repository;

  HomeProvider(this._repository) : super(HomeState.initial());

  static const int _itemsPerPage = 10;

  Future<void> loadProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!state.hasMoreData || state.isLoadingMore) {
        return;
      }
      state = state.copyWith(status: HomeStatus.loadingMore);
    } else {
      if (state.isLoading) {
        return;
      }
      state = state.copyWith(status: HomeStatus.loading);
    }

    try {
      final int skip = isLoadMore ? state.products.length : 0;
      final ProductsResponseModel response = await _repository.fetchProducts(
        skip: skip,
        forceRefresh: !isLoadMore && state.isEmpty,
      );

      final List<ProductModel> updatedProducts = isLoadMore
          ? <ProductModel>[...state.products, ...response.products]
          : response.products;

      state = state.copyWith(
        status: HomeStatus.success,
        products: updatedProducts,
        currentPage: (skip / _itemsPerPage).floor() + 1,
        totalProducts: response.total,
        hasMoreData: response.hasMoreData,
      );
    } catch (e, stackTrace) {
      debugPrint('Error loading products: $e');
      debugPrint('Stack trace: $stackTrace');

      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refreshProducts() async {
    state = HomeState.initial();
    await _repository.clearCache();
    await loadProducts();
  }

  Future<void> searchProducts(String query, {bool isLoadMore = false}) async {
    if (query.isEmpty) {
      await loadProducts(isLoadMore: isLoadMore);
      return;
    }

    if (isLoadMore) {
      if (!state.hasMoreData || state.isLoadingMore) {
        return;
      }
      state = state.copyWith(status: HomeStatus.loadingMore);
    } else {
      if (state.isLoading) {
        return;
      }
      state = state.copyWith(status: HomeStatus.loading);
    }

    try {
      final int skip = isLoadMore ? state.products.length : 0;
      final ProductsResponseModel response = await _repository.searchProducts(
        query: query,
        skip: skip,
      );

      final List<ProductModel> updatedProducts = isLoadMore
          ? <ProductModel>[...state.products, ...response.products]
          : response.products;

      state = state.copyWith(
        status: HomeStatus.success,
        products: updatedProducts,
        currentPage: (skip / _itemsPerPage).floor() + 1,
        totalProducts: response.total,
        hasMoreData: response.hasMoreData,
      );
    } catch (e) {
      debugPrint('Error searching products: $e');

      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void resetState() {
    state = HomeState.initial();
  }
}