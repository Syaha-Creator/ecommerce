// lib/features/product/presentation/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/dimensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../app/di.dart';
import '../../domain/entities/variant.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_event.dart';
import '../bloc/product_list/product_list_state.dart';
import '../widgets/variant_selector.dart';
import '../widgets/product_reviews.dart';
import '../widgets/related_products.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductDetailBloc _productDetailBloc;
  late ProductListBloc _relatedProductsBloc;
  final _pageController = PageController();
  int _quantity = 1;
  Variant? _selectedVariant;
  bool _isFavorite = false; // TODO: Get from wishlist
  final Set<String> _favoriteProductIds = {}; // TODO: Get from wishlist

  @override
  void initState() {
    super.initState();
    _productDetailBloc = locator<ProductDetailBloc>();
    _relatedProductsBloc = locator<ProductListBloc>();

    _productDetailBloc.add(LoadProductDetail(productId: widget.productId));
    // TODO: Load related products based on category
  }

  @override
  void dispose() {
    _pageController.dispose();
    _productDetailBloc.close();
    _relatedProductsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productDetailBloc),
        BlocProvider.value(value: _relatedProductsBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailError) {
              return _buildErrorWidget(state.message);
            }

            if (state is ProductDetailLoaded) {
              // Load related products when product is loaded
              if (_relatedProductsBloc.state is! ProductListLoaded) {
                _relatedProductsBloc.add(LoadProducts(
                  categoryId: state.product.category.id,
                  limit: 10,
                ));
              }

              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      // App Bar with Image
                      _buildSliverAppBar(state),

                      // Product Info
                      SliverToBoxAdapter(
                        child: _buildProductInfo(state),
                      ),

                      // Variants
                      if (state.product.variants != null &&
                          state.product.variants!.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildVariantSection(state),
                        ),

                      // Description
                      SliverToBoxAdapter(
                        child: _buildDescriptionSection(state),
                      ),

                      // Reviews
                      SliverToBoxAdapter(
                        child: _buildReviewsSection(state),
                      ),

                      // Related Products
                      SliverToBoxAdapter(
                        child: _buildRelatedProducts(),
                      ),

                      // Bottom padding for fixed button
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 100),
                      ),
                    ],
                  ),

                  // Fixed Bottom Button
                  _buildBottomBar(state),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ProductDetailLoaded state) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Image Carousel
            PageView.builder(
              controller: _pageController,
              itemCount: state.product.images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: state.product.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                );
              },
            ),

            // Page Indicator
            if (state.product.images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: state.product.images.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: Colors.white54,
                    ),
                  ),
                ),
              ),

            // Discount Badge
            if (state.product.hasDiscount)
              Positioned(
                top: MediaQuery.of(context).padding.top + 56,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '-${state.product.discountPercentage}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? AppColors.error : null,
          ),
          onPressed: _toggleFavorite,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareProduct,
        ),
      ],
    );
  }

  Widget _buildProductInfo(ProductDetailLoaded state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          if (state.product.brand != null)
            Text(
              state.product.brand!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),

          const SizedBox(height: 8),

          // Product Name
          Text(
            state.product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          // Rating & Reviews
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[700], size: 20),
              const SizedBox(width: 4),
              Text(
                state.product.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${state.product.reviewCount} reviews)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const Spacer(),
              // Stock Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: state.product.inStock
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.product.inStock
                      ? 'In Stock (${state.product.stock})'
                      : 'Out of Stock',
                  style: TextStyle(
                    color: state.product.inStock ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (state.product.hasDiscount) ...[
                Text(
                  _formatPrice(state.product.price),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                _formatPrice(_calculateFinalPrice(state)),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSection(ProductDetailLoaded state) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Variant',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          VariantSelector(
            variants: state.product.variants!,
            selectedVariantId: _selectedVariant?.id,
            onVariantSelected: (variant) {
              setState(() {
                _selectedVariant = variant;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ProductDetailLoaded state) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            state.product.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(ProductDetailLoaded state) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews (${state.product.reviewCount})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (state.reviews.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all reviews page
                  },
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ProductReviews(
            reviews: state.reviews,
            maxReviewsToShow: 3,
            onViewAllPressed: () {
              // TODO: Navigate to all reviews page
            },
          ),
          const SizedBox(height: 16),
          // Add Review Button
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Show add review dialog
            },
            icon: const Icon(Icons.edit),
            label: const Text('Write a Review'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding:
          const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: Text(
              'Related Products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ProductListBloc, ProductListState>(
            bloc: _relatedProductsBloc,
            builder: (context, state) {
              if (state is ProductListLoaded) {
                // Filter out current product
                final relatedProducts = state.products
                    .where((p) => p.id != widget.productId)
                    .take(10)
                    .toList();

                return RelatedProducts(
                  products: relatedProducts,
                  favoriteProductIds: _favoriteProductIds,
                  onProductTap: (product) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/product-detail',
                      arguments: product.id,
                    );
                  },
                  onAddToCart: _onAddToCart,
                  onToggleFavorite: _onToggleFavorite,
                );
              }

              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductDetailLoaded state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _quantity > 1
                        ? () {
                            setState(() {
                              _quantity--;
                            });
                          }
                        : null,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      _quantity.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _quantity < state.product.stock
                        ? () {
                            setState(() {
                              _quantity++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: state.product.inStock ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _productDetailBloc.add(
                LoadProductDetail(productId: widget.productId),
              );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  double _calculateFinalPrice(ProductDetailLoaded state) {
    var price = state.product.finalPrice;
    if (_selectedVariant?.additionalPrice != null) {
      price += _selectedVariant!.additionalPrice!;
    }
    return price;
  }

  String _formatPrice(double price) {
    final formatter = price.toStringAsFixed(0);
    final result = formatter.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $result';
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // TODO: Update wishlist
  }

  void _shareProduct() {
    // TODO: Implement share functionality
  }

  void _addToCart() {
    // TODO: Implement add to cart with selected variant and quantity
    final product = (_productDetailBloc.state as ProductDetailLoaded).product;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity ${product.name} to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  void _onAddToCart(product) {
    // TODO: Implement add to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  void _onToggleFavorite(product) {
    setState(() {
      if (_favoriteProductIds.contains(product.id)) {
        _favoriteProductIds.remove(product.id);
      } else {
        _favoriteProductIds.add(product.id);
      }
    });
    // TODO: Update wishlist
  }
}
