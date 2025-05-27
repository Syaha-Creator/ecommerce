import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final String productId;

  const LoadProductDetail({required this.productId});

  @override
  List<Object> get props => [productId];
}

class AddProductReview extends ProductDetailEvent {
  final String productId;
  final double rating;
  final String? comment;
  final List<String>? images;

  const AddProductReview({
    required this.productId,
    required this.rating,
    this.comment,
    this.images,
  });

  @override
  List<Object> get props => [productId, rating];
}

class LoadProductReviews extends ProductDetailEvent {
  final String productId;
  final int page;

  const LoadProductReviews({
    required this.productId,
    this.page = 1,
  });

  @override
  List<Object> get props => [productId, page];
}
