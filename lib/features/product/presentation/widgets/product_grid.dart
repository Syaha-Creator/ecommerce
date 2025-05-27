// lib/features/product/presentation/widgets/product_grid.dart
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function(Product) onAddToCart;
  final Function(Product) onToggleFavorite;
  final Set<String> favoriteProductIds;
  final ScrollController? scrollController;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onToggleFavorite,
    this.favoriteProductIds = const {},
    this.scrollController,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoading &&
            hasMore &&
            onLoadMore != null &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore!();
        }
        return false;
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.50,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(
                  product: products[index],
                  isFavorite: favoriteProductIds.contains(products[index].id),
                  onTap: () => onProductTap(products[index]),
                  onAddToCart: () => onAddToCart(products[index]),
                  onToggleFavorite: () => onToggleFavorite(products[index]),
                ),
                childCount: products.length,
              ),
            ),
          ),
          if (isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
