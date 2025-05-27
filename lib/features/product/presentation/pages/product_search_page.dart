// lib/features/product/presentation/pages/product_search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/dimensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../app/di.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_search/product_search_bloc.dart';
import '../bloc/product_search/product_search_event.dart';
import '../bloc/product_search/product_search_state.dart';
import '../widgets/product_grid.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({Key? key}) : super(key: key);

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  late ProductSearchBloc _searchBloc;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _searchFocusNode = FocusNode();
  final Set<String> _favoriteProductIds = {}; // TODO: Get from wishlist

  // Filters
  String? _selectedCategoryId;
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _searchBloc = locator<ProductSearchBloc>();

    // Focus search field on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Search Suggestions
            BlocBuilder<ProductSearchBloc, ProductSearchState>(
              builder: (context, state) {
                if (state is ProductSearchLoaded &&
                    state.suggestions.isNotEmpty &&
                    _searchController.text.isNotEmpty) {
                  return _buildSuggestions(state.suggestions);
                }
                return const SizedBox.shrink();
              },
            ),

            // Search Results
            Expanded(
              child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
                builder: (context, state) {
                  if (state is ProductSearchInitial) {
                    return _buildInitialState();
                  }

                  if (state is ProductSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductSearchError) {
                    return _buildErrorState(state.message);
                  }

                  if (state is ProductSearchEmpty) {
                    return _buildEmptyState(state.query);
                  }

                  if (state is ProductSearchLoaded ||
                      state is ProductSearchLoadingMore) {
                    final products = state is ProductSearchLoaded
                        ? state.products
                        : (state as ProductSearchLoadingMore).currentProducts;

                    final isLoadingMore = state is ProductSearchLoadingMore;
                    final hasMore = state is ProductSearchLoaded
                        ? !state.hasReachedMax
                        : true;

                    return ProductGrid(
                      products: products,
                      favoriteProductIds: _favoriteProductIds,
                      scrollController: _scrollController,
                      isLoading: isLoadingMore,
                      hasMore: hasMore,
                      onLoadMore: () {
                        if (state is ProductSearchLoaded) {
                          _searchBloc.add(SearchProducts(
                            query: state.query,
                            page: state.currentPage + 1,
                            categoryId: _selectedCategoryId,
                            minPrice: _minPrice,
                            maxPrice: _maxPrice,
                          ));
                        }
                      },
                      onProductTap: _onProductTap,
                      onAddToCart: _onAddToCart,
                      onToggleFavorite: _onToggleFavorite,
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Back Button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

          // Search Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _searchBloc.add(const ClearSearch());
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (query) {
                  setState(() {});
                  if (query.isNotEmpty) {
                    _searchBloc.add(SearchProducts(
                      query: query,
                      categoryId: _selectedCategoryId,
                      minPrice: _minPrice,
                      maxPrice: _maxPrice,
                    ));
                  } else {
                    _searchBloc.add(const ClearSearch());
                  }
                },
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    _searchBloc.add(SearchProducts(
                      query: query,
                      categoryId: _selectedCategoryId,
                      minPrice: _minPrice,
                      maxPrice: _maxPrice,
                    ));
                  }
                },
              ),
            ),
          ),

          // Filter Button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list, color: Colors.black),
                if (_hasActiveFilters())
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: suggestions.map((suggestion) {
          return InkWell(
            onTap: () {
              _searchController.text = suggestion;
              _searchBloc.add(SearchProducts(
                query: suggestion,
                categoryId: _selectedCategoryId,
                minPrice: _minPrice,
                maxPrice: _maxPrice,
              ));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.north_west,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a product name or keyword',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
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
              'Search failed',
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'No products found for "$query"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or remove filters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategoryId != null ||
        _minPrice != null ||
        _maxPrice != null;
  }

  void _showFilterOptions() {
    // TODO: Implement filter bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter options coming soon!')),
    );
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
}
