import 'package:flutter/material.dart';
import '../../../../../core/config/app_sizes.dart';
import '../../../../../core/design/app_colors.dart';

class ModernErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ModernErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.errorGradient.scale(0.3),
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.red.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.error_outline_rounded, size: 60, color: AppColors.white),
          ),
          const SizedBox(height: AppSizes.xl),
          ShaderMask(
            shaderCallback: (Rect bounds) => AppColors.errorGradient.createShader(bounds),
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
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
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
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Try Again',
                  style: TextStyle(fontSize: AppSizes.fontSizeBodyM, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}