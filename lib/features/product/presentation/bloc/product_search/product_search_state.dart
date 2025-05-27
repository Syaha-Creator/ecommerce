import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductSearchState extends Equatable {
  const ProductSearchState();

  @override
  List<Object?> get props => [];
}

class ProductSearchInitial extends ProductSearchState {}

class ProductSearchLoading extends ProductSearchState {}

class ProductSearchLoaded extends ProductSearchState {
  final List<Product> products;
  final String query;
  final bool hasReachedMax;
  final int currentPage;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final List<String> suggestions;

  const ProductSearchLoaded({
    required this.products,
    required this.query,
    required this.hasReachedMax,
    required this.currentPage,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.suggestions = const [],
  });

  ProductSearchLoaded copyWith({
    List<Product>? products,
    String? query,
    bool? hasReachedMax,
    int? currentPage,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    List<String>? suggestions,
  }) {
    return ProductSearchLoaded(
      products: products ?? this.products,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  List<Object?> get props => [
        products,
        query,
        hasReachedMax,
        currentPage,
        categoryId,
        minPrice,
        maxPrice,
        suggestions,
      ];
}

class ProductSearchError extends ProductSearchState {
  final String message;

  const ProductSearchError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductSearchEmpty extends ProductSearchState {
  final String query;

  const ProductSearchEmpty({required this.query});

  @override
  List<Object> get props => [query];
}

class ProductSearchLoadingMore extends ProductSearchState {
  final List<Product> currentProducts;

  const ProductSearchLoadingMore({required this.currentProducts});

  @override
  List<Object> get props => [currentProducts];
}
