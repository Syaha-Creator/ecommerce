// lib/features/product/presentation/pages/products_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/dimensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../app/di.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_event.dart';
import '../bloc/product_list/product_list_state.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../widgets/product_grid.dart';
import '../widgets/category_filter.dart';
import '../widgets/sort_options.dart';

class ProductsPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const ProductsPage({
    Key? key,
    this.categoryId,
    this.categoryName,
  }) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _scrollController = ScrollController();
  late ProductListBloc _productListBloc;
  late CategoryBloc _categoryBloc;
  String? _currentSort = 'relevance';
  String? _selectedCategoryId;
  final Set<String> _favoriteProductIds = {}; // TODO: Get from wishlist

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _productListBloc = locator<ProductListBloc>();
    _categoryBloc = locator<CategoryBloc>();

    // Load initial data
    _productListBloc.add(LoadProducts(categoryId: _selectedCategoryId));
    _categoryBloc.add(const LoadCategories());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productListBloc.close();
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _productListBloc),
          BlocProvider.value(value: _categoryBloc),
        ],
        child: Column(
          children: [
            // Category Filter
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  return CategoryFilter(
                    categories: state.categories,
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: _onCategorySelected,
                  );
                }
                return const SizedBox(height: 50);
              },
            ),

            const Divider(height: 1),

            // Sort & Filter Bar
            _buildSortFilterBar(),

            // Products Grid
            Expanded(
              child: BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductListError) {
                    return _buildErrorWidget(state.message);
                  }

                  if (state is ProductListLoaded ||
                      state is ProductListLoadingMore) {
                    final products = state is ProductListLoaded
                        ? state.products
                        : (state as ProductListLoadingMore).currentProducts;

                    final isLoadingMore = state is ProductListLoadingMore;
                    final hasMore = state is ProductListLoaded
                        ? !state.hasReachedMax
                        : true;

                    if (products.isEmpty) {
                      return _buildEmptyWidget();
                    }

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ProductGrid(
                        products: products,
                        favoriteProductIds: _favoriteProductIds,
                        scrollController: _scrollController,
                        isLoading: isLoadingMore,
                        hasMore: hasMore,
                        onLoadMore: () {
                          _productListBloc.add(const LoadMoreProducts());
                        },
                        onProductTap: _onProductTap,
                        onAddToCart: _onAddToCart,
                        onToggleFavorite: _onToggleFavorite,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // lib/features/product/presentation/pages/products_page.dart (update bagian AppBar)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.categoryName ?? 'Products',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: _onSearchPressed,
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 24),
              onPressed: _onCartPressed,
            ),
            // TODO: Add cart badge with item count
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      color: Colors.white,
      child: Row(
        children: [
          // Product Count
          BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              final count = state is ProductListLoaded
                  ? state.products.length
                  : state is ProductListLoadingMore
                      ? (state).currentProducts.length
                      : 0;

              return Text(
                '$count Products',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              );
            },
          ),

          const Spacer(),

          // Sort Button
          TextButton.icon(
            onPressed: _showSortOptions,
            icon: const Icon(Icons.sort, size: 20),
            label: const Text('Sort'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),

          const SizedBox(width: 8),

          // Filter Button
          TextButton.icon(
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text('Filter'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _productListBloc
                    .add(LoadProducts(categoryId: _selectedCategoryId));
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Products Found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategoryId = null;
                });
                _productListBloc.add(const LoadProducts());
              },
              child: const Text('View All Products'),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _productListBloc.add(
      ChangeProductFilter(
        categoryId: categoryId,
        sortBy: _currentSort,
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SortOptionsBottomSheet(
        currentSort: _currentSort,
        onSortChanged: (sortBy) {
          setState(() {
            _currentSort = sortBy;
          });
          _productListBloc.add(
            ChangeProductFilter(
              categoryId: _selectedCategoryId,
              sortBy: sortBy,
            ),
          );
        },
      ),
    );
  }

  void _showFilterOptions() {
    // TODO: Implement filter options (price range, brand, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter options coming soon!')),
    );
  }

  Future<void> _onRefresh() async {
    _productListBloc.add(const RefreshProducts());
  }

  void _onProductTap(Product product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product.id,
    );
  }

  void _onAddToCart(Product product) {
    // TODO: Implement add to cart
    showCustomSnackBar(
      context,
      content: '${product.name} added to cart',
      action: SnackBarAction(
        label: 'VIEW CART',
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
      ),
    );
  }

  void _onToggleFavorite(Product product) {
    setState(() {
      if (_favoriteProductIds.contains(product.id)) {
        _favoriteProductIds.remove(product.id);
      } else {
        _favoriteProductIds.add(product.id);
      }
    });
    // TODO: Update wishlist
  }

  void _onSearchPressed() {
    Navigator.pushNamed(context, '/product-search');
  }

  void _onCartPressed() {
    Navigator.pushNamed(context, '/cart');
  }
}
