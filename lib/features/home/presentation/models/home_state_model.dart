import 'product_model.dart';

enum HomeStatus { initial, loading, loadingMore, success, error , unauthorize}

class HomeState {
  final HomeStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final int currentPage;
  final int totalProducts;
  final bool hasMoreData;
  final int? errorCode;

  HomeState({
    required this.status,
    required this.products,
    this.errorMessage,
    required this.currentPage,
    required this.totalProducts,
    required this.hasMoreData,
    this.errorCode,
  });

  factory HomeState.initial() {
    return HomeState(
      status: HomeStatus.initial,
      products: <ProductModel>[],
      currentPage: 0,
      totalProducts: 0,
      hasMoreData: true,
    );
  }

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoadingMore => status == HomeStatus.loadingMore;
  bool get isSuccess => status == HomeStatus.success;
  bool get isError => status == HomeStatus.error;
  bool get isEmpty => products.isEmpty;

  HomeState copyWith({
    HomeStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    int? currentPage,
    int? totalProducts,
    bool? hasMoreData,
    int? errorCode,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalProducts: totalProducts ?? this.totalProducts,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}