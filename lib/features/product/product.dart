// Domain Layer
export 'domain/entities/product.dart';
export 'domain/entities/category.dart';
export 'domain/entities/variant.dart';
export 'domain/entities/review.dart';
export 'domain/repositories/product_repository.dart';
export 'domain/usecases/get_products_usecase.dart';
export 'domain/usecases/get_categories_usecase.dart';
export 'domain/usecases/get_product_details_usecase.dart';
export 'domain/usecases/search_products_usecase.dart';
export 'domain/usecases/get_product_reviews_usecase.dart';

// Data Layer
export 'data/models/product_model.dart';
export 'data/models/category_model.dart';
export 'data/models/variant_model.dart';
export 'data/models/review_model.dart';
export 'data/datasources/product_remote_datasource.dart';
export 'data/datasources/product_local_datasource.dart';
export 'data/repositories/product_repository_impl.dart';

// Presentation Layer - BLoCs
export 'presentation/bloc/product_list/product_list_bloc.dart';
export 'presentation/bloc/product_list/product_list_event.dart';
export 'presentation/bloc/product_list/product_list_state.dart';
export 'presentation/bloc/product_detail/product_detail_bloc.dart';
export 'presentation/bloc/product_detail/product_detail_event.dart';
export 'presentation/bloc/product_detail/product_detail_state.dart';
export 'presentation/bloc/product_search/product_search_bloc.dart';
export 'presentation/bloc/product_search/product_search_event.dart';
export 'presentation/bloc/product_search/product_search_state.dart';
export 'presentation/bloc/category/category_bloc.dart';
export 'presentation/bloc/category/category_event.dart';
export 'presentation/bloc/category/category_state.dart';

// Presentation Layer - Pages (will be added later)
// export 'presentation/pages/products_page.dart';
// export 'presentation/pages/product_detail_page.dart';
// export 'presentation/pages/product_search_page.dart';
// export 'presentation/pages/category_page.dart';

// Presentation Layer - Widgets (will be added later)
// export 'presentation/widgets/product_card.dart';
// export 'presentation/widgets/product_grid.dart';
// ...etc

// DI
export 'di/product_module.dart';
