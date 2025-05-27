// lib/features/product/presentation/bloc/product_search/product_search_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/search_products_usecase.dart';
import 'product_search_event.dart';
import 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  final SearchProductsUseCase searchProductsUseCase;
  static const int _searchLimit = 10;
  static const Duration _debounceTime = Duration(milliseconds: 300);

  ProductSearchBloc({
    required this.searchProductsUseCase,
  }) : super(ProductSearchInitial()) {
    on<SearchProducts>(
      _onSearchProducts,
      transformer: debounce(_debounceTime),
    );
    on<ClearSearch>(_onClearSearch);
    on<LoadSearchSuggestions>(_onLoadSearchSuggestions);
    on<UpdateSearchFilters>(_onUpdateSearchFilters);
  }

  // Debounce transformer
  EventTransformer<Event> debounce<Event>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductSearchState> emit,
  ) async {
    // Don't search if query is empty
    if (event.query.trim().isEmpty) {
      emit(ProductSearchInitial());
      return;
    }

    // Check if this is a new search or pagination
    final isNewSearch = state is! ProductSearchLoaded ||
        (state is ProductSearchLoaded &&
            (state as ProductSearchLoaded).query != event.query);

    if (isNewSearch) {
      emit(ProductSearchLoading());
    } else if (state is ProductSearchLoaded) {
      final currentState = state as ProductSearchLoaded;
      if (currentState.hasReachedMax) return;

      emit(ProductSearchLoadingMore(currentProducts: currentState.products));
    }

    final result = await searchProductsUseCase(
      SearchProductsParams(
        query: event.query,
        page: event.page,
        limit: _searchLimit,
        categoryId: event.categoryId,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      ),
    );

    result.fold(
      (failure) => emit(ProductSearchError(message: failure.message)),
      (products) {
        if (products.isEmpty && event.page == 1) {
          emit(ProductSearchEmpty(query: event.query));
        } else {
          final currentProducts = state is ProductSearchLoaded
              ? (state as ProductSearchLoaded).products
              : <Product>[];

          emit(
            ProductSearchLoaded(
              products: event.page == 1
                  ? products
                  : [...currentProducts, ...products],
              query: event.query,
              hasReachedMax: products.length < _searchLimit,
              currentPage: event.page,
              categoryId: event.categoryId,
              minPrice: event.minPrice,
              maxPrice: event.maxPrice,
              suggestions: _generateSuggestions(event.query),
            ),
          );
        }
      },
    );
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<ProductSearchState> emit,
  ) {
    emit(ProductSearchInitial());
  }

  Future<void> _onLoadSearchSuggestions(
    LoadSearchSuggestions event,
    Emitter<ProductSearchState> emit,
  ) async {
    if (state is ProductSearchLoaded) {
      final currentState = state as ProductSearchLoaded;
      emit(
        currentState.copyWith(
          suggestions: _generateSuggestions(event.query),
        ),
      );
    }
  }

  void _onUpdateSearchFilters(
    UpdateSearchFilters event,
    Emitter<ProductSearchState> emit,
  ) {
    if (state is ProductSearchLoaded) {
      final currentState = state as ProductSearchLoaded;

      // Re-search with new filters
      add(SearchProducts(
        query: currentState.query,
        page: 1,
        categoryId: event.categoryId,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      ));
    }
  }

  // Generate search suggestions (mock for now)
  List<String> _generateSuggestions(String query) {
    if (query.isEmpty) return [];

    // Mock suggestions - replace with actual logic later
    final suggestions = [
      '${query} terbaru',
      '${query} murah',
      '${query} original',
      '${query} promo',
      '${query} terlaris',
    ];

    return suggestions.take(5).toList();
  }
}
