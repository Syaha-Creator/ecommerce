// lib/features/product/domain/usecases/get_categories_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'usecase.dart';
import '../entities/category.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
