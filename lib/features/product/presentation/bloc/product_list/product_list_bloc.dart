import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  static const int _productsLimit = 10;

  ProductListBloc({
    required this.getProductsUseCase,
  }) : super(ProductListInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<ChangeProductFilter>(_onChangeProductFilter);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(ProductListLoading());
    }

    final result = await getProductsUseCase(
      GetProductsParams(
        page: event.page,
        limit: event.limit,
        categoryId: event.categoryId,
        sortBy: event.sortBy,
        featured: event.featured,
      ),
    );

    result.fold(
      (failure) => emit(ProductListError(message: failure.message)),
      (products) => emit(
        ProductListLoaded(
          products: products,
          hasReachedMax: products.length < event.limit,
          currentPage: event.page,
          currentCategoryId: event.categoryId,
          currentSortBy: event.sortBy,
          currentFeatured: event.featured,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;

      if (currentState.hasReachedMax) return;

      emit(ProductListLoadingMore(currentProducts: currentState.products));

      final result = await getProductsUseCase(
        GetProductsParams(
          page: currentState.currentPage + 1,
          limit: _productsLimit,
          categoryId: currentState.currentCategoryId,
          sortBy: currentState.currentSortBy,
          featured: currentState.currentFeatured,
        ),
      );

      result.fold(
        (failure) => emit(currentState),
        (products) => emit(
          currentState.copyWith(
            products: List.of(currentState.products)..addAll(products),
            hasReachedMax: products.length < _productsLimit,
            currentPage: currentState.currentPage + 1,
          ),
        ),
      );
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;

      add(LoadProducts(
        page: 1,
        limit: _productsLimit,
        categoryId: currentState.currentCategoryId,
        sortBy: currentState.currentSortBy,
        featured: currentState.currentFeatured,
        isRefresh: true,
      ));
    } else {
      add(const LoadProducts(isRefresh: true));
    }
  }

  Future<void> _onChangeProductFilter(
    ChangeProductFilter event,
    Emitter<ProductListState> emit,
  ) async {
    add(LoadProducts(
      page: 1,
      limit: _productsLimit,
      categoryId: event.categoryId,
      sortBy: event.sortBy,
      featured: event.featured,
    ));
  }
}
