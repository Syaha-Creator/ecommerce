// lib/features/product/di/product_module.dart
import 'package:get_it/get_it.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_info.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/product_local_datasource.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_product_details_usecase.dart';
import '../domain/usecases/search_products_usecase.dart';
import '../domain/usecases/get_product_reviews_usecase.dart';
import '../presentation/bloc/product_list/product_list_bloc.dart';
import '../presentation/bloc/product_detail/product_detail_bloc.dart';
import '../presentation/bloc/product_search/product_search_bloc.dart';
import '../presentation/bloc/category/category_bloc.dart';

final sl = GetIt.instance;

Future<void> registerProductDependencies() async {
  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      localDataSource: sl<ProductLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(
      () => GetProductDetailsUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(
      () => SearchProductsUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(
      () => GetProductReviewsUseCase(sl<ProductRepository>()));

  // BLoCs
  sl.registerFactory(
    () => ProductListBloc(
      getProductsUseCase: sl<GetProductsUseCase>(),
    ),
  );

  sl.registerFactory(
    () => ProductDetailBloc(
      getProductDetailsUseCase: sl<GetProductDetailsUseCase>(),
      getProductReviewsUseCase: sl<GetProductReviewsUseCase>(),
      productRepository: sl<ProductRepository>(),
    ),
  );

  sl.registerFactory(
    () => ProductSearchBloc(
      searchProductsUseCase: sl<SearchProductsUseCase>(),
    ),
  );

  sl.registerFactory(
    () => CategoryBloc(
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
    ),
  );
}
