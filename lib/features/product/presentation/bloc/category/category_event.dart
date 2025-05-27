import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class SelectCategory extends CategoryEvent {
  final String categoryId;

  const SelectCategory({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
