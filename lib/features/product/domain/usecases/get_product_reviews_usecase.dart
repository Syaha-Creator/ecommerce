// lib/features/product/domain/usecases/get_product_reviews_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/review.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class GetProductReviewsUseCase
    implements UseCase<List<Review>, ProductReviewsParams> {
  final ProductRepository repository;

  GetProductReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(
      ProductReviewsParams params) async {
    return await repository.getProductReviews(
      productId: params.productId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ProductReviewsParams extends Equatable {
  final String productId;
  final int page;
  final int limit;

  const ProductReviewsParams({
    required this.productId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object> get props => [productId, page, limit];
}
