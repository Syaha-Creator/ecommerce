// lib/features/product/domain/usecases/get_products_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import 'usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
      categoryId: params.categoryId,
      sortBy: params.sortBy,
      featured: params.featured,
    );
  }
}

class GetProductsParams extends Equatable {
  final int page;
  final int limit;
  final String? categoryId;
  final String? sortBy;
  final bool? featured;

  const GetProductsParams({
    this.page = 1,
    this.limit = 10,
    this.categoryId,
    this.sortBy,
    this.featured,
  });

  @override
  List<Object?> get props => [page, limit, categoryId, sortBy, featured];
}
