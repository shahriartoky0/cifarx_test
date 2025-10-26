import 'package:cifarx_test/core/network/network_caller.dart';
import 'package:cifarx_test/core/utils/get_storage_model.dart';
import 'package:cifarx_test/features/home/data/product_data.dart';
import 'package:cifarx_test/features/home/data/product_repository.dart';
import 'package:cifarx_test/features/home/presentation/models/home_state_model.dart';
import 'package:cifarx_test/features/home/presentation/providers/home_controller.dart';
import 'package:cifarx_test/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Core dependencies
final Provider<NetworkCaller> networkCallerProvider = Provider<NetworkCaller>((Ref ref) {
  return NetworkCaller();
});

final Provider<GetStorageModel> storageProvider = Provider<GetStorageModel>((Ref ref) {
  return GetStorageModel();
});

// Data layer
final Provider<ProductsDataSource> productsDataSourceProvider = Provider<ProductsDataSource>((
  Ref ref,
) {
  return ProductsDataSource(ref.watch(networkCallerProvider));
});

final Provider<ProductsRepository> productsRepositoryProvider = Provider<ProductsRepository>((
  Ref ref,
) {
  return ProductsRepository(ref.watch(productsDataSourceProvider), ref.watch(storageProvider));
});

// Presentation layer
final StateNotifierProvider<HomeProvider, HomeState> homeControllerProvider =
    StateNotifierProvider<HomeProvider, HomeState>((Ref ref) {
      return HomeProvider(ref.watch(productsRepositoryProvider));
    });
