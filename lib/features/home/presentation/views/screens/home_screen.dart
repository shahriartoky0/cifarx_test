import 'package:cifarx_test/core/config/app_sizes.dart';
import 'package:cifarx_test/core/design/app_colors.dart';
import 'package:cifarx_test/core/routes/app_routes.dart';
import 'package:cifarx_test/features/home/presentation/models/home_state_model.dart';
import 'package:cifarx_test/features/home/presentation/models/product_model.dart';
import 'package:cifarx_test/features/home/presentation/providers/home_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/animated_product_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/load_more_skeleton.dart';
import '../widgets/modern_error_view.dart';
import '../widgets/sticky_searchbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadProducts();
      final HomeState op = ref.read(homeControllerProvider);
      if (op.errorCode == 403 || op.errorCode == 401) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;

    // Trigger load more at 85% scroll
    if (currentScroll >= (maxScroll * 0.85)) {
      final HomeState state = ref.read(homeControllerProvider);
      final bool isLoadingMore = ref.read(isLoadingMoreProvider);
      final String query = ref.read(searchQueryProvider);

      if (state.hasMoreData && !isLoadingMore && !state.isLoading) {
        ref.read(isLoadingMoreProvider.notifier).state = true;

        final Future<void> future = query.isEmpty
            ? ref.read(homeControllerProvider.notifier).loadProducts(isLoadMore: true)
            : ref.read(homeControllerProvider.notifier).searchProducts(query, isLoadMore: true);

        future.whenComplete(() {
          if (mounted) {
            ref.read(isLoadingMoreProvider.notifier).state = false;
          }
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).state = query;

    if (query.isEmpty) {
      ref.read(homeControllerProvider.notifier).loadProducts();
    } else {
      ref.read(homeControllerProvider.notifier).searchProducts(query);
    }
  }

  Future<void> _onRefresh() async {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(isLoadingMoreProvider.notifier).state = false;
    await ref.read(homeControllerProvider.notifier).refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    final HomeState state = ref.watch(homeControllerProvider);
    final String searchQuery = ref.watch(searchQueryProvider);
    final bool isLoadingMore = ref.watch(isLoadingMoreProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(), // Smooth iOS-like scrolling
        slivers: <Widget>[
          _buildModernAppBar(),
          // iOS-style pull to refresh - placed after AppBar to avoid white space
          CupertinoSliverRefreshControl(
            onRefresh: _onRefresh,
            builder:
                (
                  BuildContext context,
                  RefreshIndicatorMode refreshState,
                  double pulledExtent,
                  double refreshTriggerPullDistance,
                  double refreshIndicatorExtent,
                ) {
                  // Return empty SizedBox - completely invisible
                  return const SizedBox.shrink();
                },
          ),
          _buildStickySearchBar(),
          _buildBody(state, searchQuery, isLoadingMore),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      stretch: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: FlexibleSpaceBar(
          centerTitle: false,
          titlePadding: const EdgeInsets.only(left: AppSizes.md, bottom: AppSizes.md),
          title: const Text(
            'Discover Products',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSizeH2,
            ),
          ),
          background: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[AppColors.white.withValues(alpha: 0.1), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -20,
                top: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _onRefresh();
                    },
                    icon: const Icon(CupertinoIcons.refresh_bold, color: AppColors.white, size: 28),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickySearchBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickySearchBarDelegate(
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildBody(HomeState state, String searchQuery, bool isLoadingMore) {
    // Initial loading
    if (state.isLoading && state.products.isEmpty) {
      return _buildSkeletonLoading();
    }

    // Error with no products
    if (state.isError && state.products.isEmpty) {
      return SliverFillRemaining(
        child: ModernErrorView(
          message: state.errorMessage ?? 'Something went wrong',
          onRetry: _onRefresh,
        ),
      );
    }

    // Empty state
    if (state.isEmpty && state.isSuccess) {
      return SliverFillRemaining(
        child: ModernEmptyView(
          message: searchQuery.isEmpty ? 'No products available' : 'No products found',
          subtitle: searchQuery.isEmpty
              ? 'Pull down to refresh'
              : 'Try searching with different keywords',
          icon: searchQuery.isEmpty ? Icons.shopping_bag_outlined : Icons.search_off_rounded,
          onAction: searchQuery.isEmpty ? _onRefresh : null,
          actionLabel: searchQuery.isEmpty ? 'Refresh' : null,
        ),
      );
    }

    // Products list with load more
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          // Load more skeleton at the end
          if (index == state.products.length) {
            if (isLoadingMore && state.hasMoreData) {
              return const Padding(
                padding: EdgeInsets.only(bottom: AppSizes.md),
                child: LoadMoreSkeleton(),
              );
            }
            // Extra space at bottom
            return const SizedBox(height: AppSizes.xl);
          }

          final ProductModel product = state.products[index];
          return AnimatedProductCard(
            key: ValueKey<int>(product.id),
            product: product,
            index: index,
          );
        }, childCount: state.products.length + 1),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return const SkeletonProductCard();
        }, childCount: 6),
      ),
    );
  }
}
