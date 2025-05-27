// lib/features/home/presentation/pages/home_page.dart (update category tap dan featured products)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../../../../app/di.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../product/product.dart'; // Import product feature
import '../widgets/category_slider.dart';
import '../widgets/featured_products.dart';
import '../widgets/home_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _envConfig = locator<EnvConfig>();
  int _currentIndex = 0;

  // Add product related blocs
  late ProductListBloc _featuredProductsBloc;
  late CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    // Initialize blocs
    _featuredProductsBloc = locator<ProductListBloc>();
    _categoryBloc = locator<CategoryBloc>();

    // Load data
    _featuredProductsBloc.add(const LoadProducts(featured: true, limit: 10));
    _categoryBloc.add(const LoadCategories());
  }

  @override
  void dispose() {
    _featuredProductsBloc.close();
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _featuredProductsBloc),
        BlocProvider.value(value: _categoryBloc),
      ],
      child: Scaffold(
        extendBody:
            true, // Ensures content can extend behind the bottom nav bar
        appBar: _currentIndex == 4 ? null : _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      toolbarHeight: 80,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _envConfig.appName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/product-search');
          },
        ),
        Stack(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                // TODO: Navigate to notifications page
              },
            ),
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
                    '2',
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return SingleChildScrollView(
          padding:
              const EdgeInsets.only(bottom: 90), // Increased padding for safety
          child: Column(
            children: [
              const HomeBanner(),
              // Updated CategorySlider with navigation
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    return CategorySlider(
                      categories: state.categories,
                      onCategoryTap: (category) {
                        Navigator.pushNamed(
                          context,
                          '/products',
                          arguments: {
                            'categoryId': category.id,
                            'categoryName': category.name,
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox(height: 10);
                },
              ),
              // Updated FeaturedProducts with real data
              BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListLoaded) {
                    return FeaturedProducts(
                      title: 'Featured Products',
                      products: state.products,
                      onProductTap: (product) {
                        Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: product.id,
                        );
                      },
                      onViewAll: () {
                        Navigator.pushNamed(context, '/products');
                      },
                    );
                  }
                  return const SizedBox(height: 200);
                },
              ),
            ],
          ),
        );
      case 1: // Categories
        return _buildCategoriesPage();
      case 4:
        return const ProfilePage();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Fitur ini sedang dalam pengembangan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
  }

  Widget _buildCategoriesPage() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoryLoaded) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/products',
                    arguments: {
                      'categoryId': category.id,
                      'categoryName': category.name,
                    },
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getCategoryIcon(category.name),
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      if (category.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('Failed to load categories'));
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final iconMap = {
      'Electronics': Icons.devices,
      'Fashion': Icons.checkroom,
      'Home & Living': Icons.home,
      'Beauty & Health': Icons.face,
      'Sports & Outdoor': Icons.sports_basketball,
      'Food & Drinks': Icons.fastfood,
      'Books': Icons.book,
      'Toys': Icons.toys,
    };
    return iconMap[categoryName] ?? Icons.category;
  }

  Widget _buildBottomNavBar() {
    return Container(
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
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
