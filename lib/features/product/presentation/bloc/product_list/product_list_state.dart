import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentCategoryId;
  final String? currentSortBy;
  final bool? currentFeatured;

  const ProductListLoaded({
    required this.products,
    required this.hasReachedMax,
    required this.currentPage,
    this.currentCategoryId,
    this.currentSortBy,
    this.currentFeatured,
  });

  ProductListLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? currentPage,
    String? currentCategoryId,
    String? currentSortBy,
    bool? currentFeatured,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      currentSortBy: currentSortBy ?? this.currentSortBy,
      currentFeatured: currentFeatured ?? this.currentFeatured,
    );
  }

  @override
  List<Object?> get props => [
        products,
        hasReachedMax,
        currentPage,
        currentCategoryId,
        currentSortBy,
        currentFeatured,
      ];
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductListLoadingMore extends ProductListState {
  final List<Product> currentProducts;

  const ProductListLoadingMore({required this.currentProducts});

  @override
  List<Object> get props => [currentProducts];
}
