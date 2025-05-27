// lib/features/product/domain/usecases/search_products_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class SearchProductsUseCase
    implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
      SearchProductsParams params) async {
    return await repository.searchProducts(
      query: params.query,
      page: params.page,
      limit: params.limit,
      categoryId: params.categoryId,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String query;
  final int page;
  final int limit;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;

  const SearchProductsParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props =>
      [query, page, limit, categoryId, minPrice, maxPrice];
}
