// lib/features/product/domain/usecases/get_product_details_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import 'usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase
    implements UseCase<Product, ProductDetailsParams> {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductDetailsParams params) async {
    return await repository.getProductById(params.productId);
  }
}

class ProductDetailsParams extends Equatable {
  final String productId;

  const ProductDetailsParams({required this.productId});

  @override
  List<Object> get props => [productId];
}
