import 'package:cifarx_test/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../../../../core/config/app_sizes.dart';
import '../../../../../core/design/app_colors.dart';

/// Sticky search bar delegate
class StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  StickySearchBarDelegate({required this.searchController, required this.onSearchChanged});

  static const double _totalHeight = 72.0;

  @override
  double get minExtent => _totalHeight;

  @override
  double get maxExtent => _totalHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: _totalHeight,
      child: Container(
        color: AppColors.bgColor,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: AppColors.shadowLight, blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: const TextStyle(fontSize: AppSizes.fontSizeBodyM, color: AppColors.headlineText),
            decoration: InputDecoration(
              hintText: 'Search amazing products...',
              hintStyle: TextStyle(
                color: AppColors.grey.withValues(alpha: 0.5),
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
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.close_rounded, color: AppColors.grey.withValues(alpha: 0.5)),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                  context.hideKeyboard;
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
                vertical: AppSizes.sm,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}