import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_product_details_usecase.dart';
import '../../../domain/usecases/get_product_reviews_usecase.dart';
import '../../../domain/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetProductReviewsUseCase getProductReviewsUseCase;
  final ProductRepository productRepository;

  ProductDetailBloc({
    required this.getProductDetailsUseCase,
    required this.getProductReviewsUseCase,
    required this.productRepository,
  }) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<AddProductReview>(_onAddProductReview);
    on<LoadProductReviews>(_onLoadProductReviews);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    // Load product details
    final productResult = await getProductDetailsUseCase(
      ProductDetailsParams(productId: event.productId),
    );

    await productResult.fold(
      (failure) async => emit(ProductDetailError(message: failure.message)),
      (product) async {
        // Load initial reviews
        final reviewsResult = await getProductReviewsUseCase(
          ProductReviewsParams(productId: event.productId, page: 1),
        );

        reviewsResult.fold(
          (failure) => emit(ProductDetailError(message: failure.message)),
          (reviews) => emit(
            ProductDetailLoaded(
              product: product,
              reviews: reviews,
              hasMoreReviews: reviews.length >= 10,
              currentReviewPage: 1,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddProductReview(
    AddProductReview event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;

      emit(AddingReview(
        product: currentState.product,
        reviews: currentState.reviews,
      ));

      final result = await productRepository.addProductReview(
        productId: event.productId,
        rating: event.rating,
        comment: event.comment,
        images: event.images,
      );

      result.fold(
        (failure) => emit(ProductDetailError(message: failure.message)),
        (newReview) {
          final updatedReviews = [newReview, ...currentState.reviews];
          emit(ReviewAdded(
            product: currentState.product,
            reviews: updatedReviews,
            newReview: newReview,
          ));

          // Return to loaded state with updated reviews
          emit(ProductDetailLoaded(
            product: currentState.product,
            reviews: updatedReviews,
            hasMoreReviews: currentState.hasMoreReviews,
            currentReviewPage: currentState.currentReviewPage,
          ));
        },
      );
    }
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviews event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;

      final result = await getProductReviewsUseCase(
        ProductReviewsParams(
          productId: event.productId,
          page: event.page,
        ),
      );

      result.fold(
        (failure) => emit(currentState),
        (reviews) => emit(
          currentState.copyWith(
            reviews: event.page == 1
                ? reviews
                : [...currentState.reviews, ...reviews],
            hasMoreReviews: reviews.length >= 10,
            currentReviewPage: event.page,
          ),
        ),
      );
    }
  }
}
