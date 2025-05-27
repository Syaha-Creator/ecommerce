// lib/features/product/presentation/widgets/related_products.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/dimensions.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';

class RelatedProducts extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function(Product) onAddToCart;
  final Function(Product) onToggleFavorite;
  final Set<String> favoriteProductIds;

  const RelatedProducts({
    Key? key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onToggleFavorite,
    this.favoriteProductIds = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 370,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        itemCount: products.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 12),
            child: ProductCard(
              product: product,
              isFavorite: favoriteProductIds.contains(product.id),
              onTap: () => onProductTap(product),
              onAddToCart: () => onAddToCart(product),
              onToggleFavorite: () => onToggleFavorite(product),
            ),
          );
        },
      ),
    );
  }
}
