import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/review.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final List<Review> reviews;
  final bool hasMoreReviews;
  final int currentReviewPage;

  const ProductDetailLoaded({
    required this.product,
    required this.reviews,
    required this.hasMoreReviews,
    required this.currentReviewPage,
  });

  ProductDetailLoaded copyWith({
    Product? product,
    List<Review>? reviews,
    bool? hasMoreReviews,
    int? currentReviewPage,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      currentReviewPage: currentReviewPage ?? this.currentReviewPage,
    );
  }

  @override
  List<Object> get props =>
      [product, reviews, hasMoreReviews, currentReviewPage];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class AddingReview extends ProductDetailState {
  final Product product;
  final List<Review> reviews;

  const AddingReview({
    required this.product,
    required this.reviews,
  });

  @override
  List<Object> get props => [product, reviews];
}

class ReviewAdded extends ProductDetailState {
  final Product product;
  final List<Review> reviews;
  final Review newReview;

  const ReviewAdded({
    required this.product,
    required this.reviews,
    required this.newReview,
  });

  @override
  List<Object> get props => [product, reviews, newReview];
}
