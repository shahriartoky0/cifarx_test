

import 'package:cifarx_test/features/home/presentation/views/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/custom_toast.dart';
import '../../models/product_model.dart';

/// Animated product card with proper key for smooth scrolling
class AnimatedProductCard extends StatelessWidget {
  final ProductModel product;
  final int index;

  const AnimatedProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: ProductCard(
        product: product,
        onTap: () {
          ToastManager.show(message: 'Tapped on ${product.title}');
        },
      ),
    );
  }
}