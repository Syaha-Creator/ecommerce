import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductListEvent {
  final int page;
  final int limit;
  final String? categoryId;
  final String? sortBy;
  final bool? featured;
  final bool isRefresh;

  const LoadProducts({
    this.page = 1,
    this.limit = 10,
    this.categoryId,
    this.sortBy,
    this.featured,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props =>
      [page, limit, categoryId, sortBy, featured, isRefresh];
}

class LoadMoreProducts extends ProductListEvent {
  const LoadMoreProducts();
}

class RefreshProducts extends ProductListEvent {
  const RefreshProducts();
}

class ChangeProductFilter extends ProductListEvent {
  final String? categoryId;
  final String? sortBy;
  final bool? featured;

  const ChangeProductFilter({
    this.categoryId,
    this.sortBy,
    this.featured,
  });

  @override
  List<Object?> get props => [categoryId, sortBy, featured];
}
