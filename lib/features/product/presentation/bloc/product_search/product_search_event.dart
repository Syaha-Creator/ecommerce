import 'package:equatable/equatable.dart';

abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProducts extends ProductSearchEvent {
  final String query;
  final int page;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;

  const SearchProducts({
    required this.query,
    this.page = 1,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [query, page, categoryId, minPrice, maxPrice];
}

class ClearSearch extends ProductSearchEvent {
  const ClearSearch();
}

class LoadSearchSuggestions extends ProductSearchEvent {
  final String query;

  const LoadSearchSuggestions({required this.query});

  @override
  List<Object> get props => [query];
}

class UpdateSearchFilters extends ProductSearchEvent {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;

  const UpdateSearchFilters({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [categoryId, minPrice, maxPrice];
}
