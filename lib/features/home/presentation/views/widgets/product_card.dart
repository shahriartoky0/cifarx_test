import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/config/app_sizes.dart';
import '../../../../../core/design/app_colors.dart';
import '../../models/product_model.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
            boxShadow: const <BoxShadow>[
              BoxShadow(color: AppColors.shadowMedium, blurRadius: 16, offset: Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_buildImageSection(), _buildContentSection()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            widget.product.thumbnail,
            fit: BoxFit.cover,
            cacheWidth: 800, // Optimize memory
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                decoration: BoxDecoration(gradient: AppColors.accentGradient.scale(0.3)),
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
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                decoration: const BoxDecoration(gradient: AppColors.shimmerGradient),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, AppColors.black.withValues(alpha: 0.3)],
              ),
            ),
          ),
        ),
        if (widget.product.discountPercentage > 0)
          Positioned(
            top: AppSizes.sm,
            right: AppSizes.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
              decoration: BoxDecoration(
                gradient: AppColors.errorGradient,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.red.withValues(alpha: 0.3),
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
        Positioned(
          bottom: AppSizes.sm,
          left: AppSizes.sm,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  border: Border.all(color: AppColors.white.withValues(alpha: 0.3), width: 1),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_buildPriceSection(), _buildStockBadge()],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.star_rounded, size: AppSizes.iconSm, color: AppColors.white),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        gradient: AppColors.successGradient,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.green.withValues(alpha: 0.3),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: inStock
            ? AppColors.green.withValues(alpha: 0.1)
            : AppColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(
          color: inStock
              ? AppColors.green.withValues(alpha: 0.3)
              : AppColors.red.withValues(alpha: 0.3),
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
                      ? AppColors.green.withValues(alpha: 0.5)
                      : AppColors.red.withValues(alpha: 0.5),
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
