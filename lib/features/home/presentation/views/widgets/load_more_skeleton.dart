import 'package:cifarx_test/features/home/presentation/views/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/app_sizes.dart';
import '../../../../../core/design/app_colors.dart';

/// Load more skeleton widget
class LoadMoreSkeleton extends StatelessWidget {
  const LoadMoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: <Widget>[SkeletonProductCard(), SkeletonProductCard()]);
  }
}

/// Skeleton loading card
class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: AppColors.shadowMedium, blurRadius: 16, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.borderRadiusXl),
                  topRight: Radius.circular(AppSizes.borderRadiusXl),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    height: 18,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Container(
                    height: 14,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 32,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
