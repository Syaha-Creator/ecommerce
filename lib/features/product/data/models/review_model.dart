import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/review.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel extends Review {
  const ReviewModel({
    required String id,
    required String productId,
    required String userId,
    required String userName,
    String? userAvatar,
    required double rating,
    String? comment,
    List<String>? images,
    required bool isVerifiedPurchase,
    required int helpfulCount,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          productId: productId,
          userId: userId,
          userName: userName,
          userAvatar: userAvatar,
          rating: rating,
          comment: comment,
          images: images,
          isVerifiedPurchase: isVerifiedPurchase,
          helpfulCount: helpfulCount,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  // Add toEntity method
  Review toEntity() {
    return Review(
      id: id,
      productId: productId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      rating: rating,
      comment: comment,
      images: images,
      isVerifiedPurchase: isVerifiedPurchase,
      helpfulCount: helpfulCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      productId: review.productId,
      userId: review.userId,
      userName: review.userName,
      userAvatar: review.userAvatar,
      rating: review.rating,
      comment: review.comment,
      images: review.images,
      isVerifiedPurchase: review.isVerifiedPurchase,
      helpfulCount: review.helpfulCount,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
    );
  }

  static ReviewModel dummy({
    required String productId,
    double? rating,
    String? comment,
  }) {
    final now = DateTime.now();
    return ReviewModel(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId,
      userId: 'user_123',
      userName: 'John Doe',
      userAvatar: 'https://via.placeholder.com/50x50',
      rating: rating ?? 4.5,
      comment: comment ?? 'Great product! Highly recommended.',
      images: null,
      isVerifiedPurchase: true,
      helpfulCount: 10,
      createdAt: now,
      updatedAt: null,
    );
  }
}
