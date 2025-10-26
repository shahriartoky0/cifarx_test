import 'dart:ui';
import 'package:cifarx_test/core/config/app_sizes.dart';
import 'package:cifarx_test/core/design/app_colors.dart';
import 'package:cifarx_test/core/utils/custom_loader.dart';
import 'package:cifarx_test/features/home/presentation/models/home_state_model.dart';
import 'package:cifarx_test/features/home/presentation/models/product_model.dart';
import 'package:cifarx_test/features/home/presentation/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadProducts();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final HomeState state = ref.read(homeControllerProvider);
      if (state.hasMoreData && !state.isLoadingMore) {
        if (_currentSearchQuery.isEmpty) {
          ref.read(homeControllerProvider.notifier).loadProducts(
            isLoadMore: true,
          );
        } else {
          ref.read(homeControllerProvider.notifier).searchProducts(
            _currentSearchQuery,
            isLoadMore: true,
          );
        }
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentSearchQuery = query;
    });

    if (query.isEmpty) {
      ref.read(homeControllerProvider.notifier).loadProducts();
    } else {
      ref.read(homeControllerProvider.notifier).searchProducts(query);
    }
  }

  void _onRefresh() async {
    _searchController.clear();
    _currentSearchQuery = '';
    await ref.read(homeControllerProvider.notifier).refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    final HomeState state = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),
          _buildBody(state),
        ],
      ),
    );
  }

  /// Modern gradient AppBar with glass morphism
  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: FlexibleSpaceBar(
          centerTitle: false,
          titlePadding: const EdgeInsets.only(
            left: AppSizes.md,
            bottom: AppSizes.md,
          ),
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
              // Animated gradient overlay
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            AppColors.white.withValues(alpha:0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Decorative circles
              Positioned(
                right: -20,
                top: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha:0.1),
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
                    color: AppColors.white.withValues(alpha:0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: AppSizes.sm),

          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.white),
            onPressed: _onRefresh,
            tooltip: 'Refresh',
          ),
        ),
      ],
    );
  }

  /// Modern search bar with glass effect
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(
          fontSize: AppSizes.fontSizeBodyM,
          color: AppColors.headlineText,
        ),
        decoration: InputDecoration(
          hintText: 'Search amazing products...',
          hintStyle: TextStyle(
            color: AppColors.grey.withValues(alpha:0.5),
            fontSize: AppSizes.fontSizeBodyM,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.white,
              size: AppSizes.iconMd,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.grey.withValues(alpha:0.5),
            ),
            onPressed: () {
              _searchController.clear();
              _onSearchChanged('');
            },
          )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.md,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state.isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              const Text(
                'Loading products...',
                style: TextStyle(
                  color: AppColors.bodyText,
                  fontSize: AppSizes.fontSizeBodyM,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isError) {
      return SliverFillRemaining(
        child: ModernErrorView(
          message: state.errorMessage ?? 'Something went wrong',
          onRetry: _onRefresh,
        ),
      );
    }

    if (state.isEmpty && state.isSuccess) {
      return SliverFillRemaining(
        child: ModernEmptyView(
          message: _currentSearchQuery.isEmpty
              ? 'No products available'
              : 'No products found',
          subtitle: _currentSearchQuery.isEmpty
              ? 'Pull down to refresh'
              : 'Try searching with different keywords',
          icon: _currentSearchQuery.isEmpty
              ? Icons.shopping_bag_outlined
              : Icons.search_off_rounded,
          onAction: _currentSearchQuery.isEmpty ? _onRefresh : null,
          actionLabel: _currentSearchQuery.isEmpty ? 'Refresh' : null,
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            if (index == state.products.length) {
              return CustomLoading();
            }

            final ProductModel product = state.products[index];
            return FadeInAnimation(
              delay: Duration(milliseconds: index * 50),
              child: ModernProductCard(
                product: product,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped on ${product.title}'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusMd,
                        ),
                      ),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  );
                },
              ),
            );
          },
          childCount: state.products.length + (state.isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }
}

class ModernProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ModernProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ModernProductCard> createState() => _ModernProductCardState();
}

class _ModernProductCardState extends State<ModernProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.md),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildImageSection(),
                _buildContentSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: <Widget>[
        // Product image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            widget.product.thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient.scale(0.3),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    size: AppSizes.iconXl,
                    color: AppColors.white,
                  ),
                ),
              );
            },
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                decoration: BoxDecoration(
                  gradient: AppColors.shimmerGradient,
                ),
              );
            },
          ),
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  AppColors.black.withValues(alpha:0.3),
                ],
              ),
            ),
          ),
        ),

        // Discount badge
        if (widget.product.discountPercentage > 0)
          Positioned(
            top: AppSizes.sm,
            right: AppSizes.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.errorGradient,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.red.withValues(alpha:0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: AppSizes.fontSizeBodyS,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Brand badge with glass effect
        Positioned(
          bottom: AppSizes.sm,
          left: AppSizes.sm,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha:0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.product.brand,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontSizeBodyS,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title and Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.product.title,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeBodyL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headlineText,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              _buildRatingBadge(),
            ],
          ),

          const SizedBox(height: AppSizes.sm),

          // Description
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: AppSizes.fontSizeBodyS,
              color: AppColors.bodyText,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSizes.md),

          // Price and Stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildPriceSection(),
              _buildStockBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.star_rounded,
            size: AppSizes.iconSm,
            color: AppColors.white,
          ),
          const SizedBox(width: 2),
          Text(
            widget.product.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: AppSizes.fontSizeBodyS,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.successGradient,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.green.withValues(alpha:0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '\$${widget.product.price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: AppSizes.fontSizeBodyL,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildStockBadge() {
    final bool inStock = widget.product.stock > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: inStock
            ? AppColors.green.withValues(alpha:0.1)
            : AppColors.red.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(
          color: inStock
              ? AppColors.green.withValues(alpha:0.3)
              : AppColors.red.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: inStock ? AppColors.green : AppColors.red,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: inStock
                      ? AppColors.green.withValues(alpha:0.5)
                      : AppColors.red.withValues(alpha:0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          Text(
            inStock ? '${widget.product.stock} left' : 'Out of stock',
            style: TextStyle(
              fontSize: AppSizes.fontSizeBodyS,
              color: inStock ? AppColors.green : AppColors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fade-in animation widget
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
class ModernErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ModernErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gradient icon container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.errorGradient.scale(0.3),
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.red.withValues(alpha:0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 60,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Title with gradient text
            ShaderMask(
              shaderCallback: (Rect bounds) => AppColors.errorGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: AppSizes.fontSizeH2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: AppSizes.fontSizeBodyM,
                color: AppColors.bodyText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSizes.xxl),

              // Gradient button
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha:0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xxl,
                      vertical: AppSizes.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusXl,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeBodyM,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modern empty view with gradient and animations
class ModernEmptyView extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const ModernEmptyView({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gradient icon container with subtle animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (BuildContext context, double value, Widget? child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient.scale(0.3),
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.accentGradient1.withValues(alpha:0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: AppColors.white,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Title with gradient text
            ShaderMask(
              shaderCallback: (Rect bounds) => AppColors.primaryGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: AppSizes.fontSizeH2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (subtitle != null) ...<Widget>[
              const SizedBox(height: AppSizes.md),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: AppSizes.fontSizeBodyM,
                  color: AppColors.bodyText,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (onAction != null && actionLabel != null) ...<Widget>[
              const SizedBox(height: AppSizes.xxl),

              // Gradient button
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.accentGradient1.withValues(alpha:0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xxl,
                      vertical: AppSizes.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusXl,
                      ),
                    ),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: AppSizes.fontSizeBodyM,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading effect for skeleton screens
class ShimmerLoading extends StatefulWidget {
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.child,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return AppColors.shimmerGradient.createShader(
              Rect.fromLTWH(
                -bounds.width + (bounds.width * 2 * _controller.value),
                0,
                bounds.width * 2,
                bounds.height,
              ),
            );
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Glass morphism container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.borderRadiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.borderRadiusLg),
            border: Border.all(
              color: AppColors.white.withValues(alpha:0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
