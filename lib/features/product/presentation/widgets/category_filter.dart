// lib/features/product/presentation/widgets/category_filter.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/dimensions.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/category.dart';

class CategoryFilter extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: 8,
        ),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: const Text('All'),
                selected: selectedCategoryId == null,
                onSelected: (_) => onCategorySelected(null),
                selectedColor: AppColors.primary.withOpacity(0.2),
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: selectedCategoryId == null
                      ? AppColors.primary
                      : Colors.grey[700],
                  fontWeight: selectedCategoryId == null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                side: BorderSide(
                  color: selectedCategoryId == null
                      ? AppColors.primary
                      : Colors.transparent,
                ),
              ),
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategoryId == category.id;

          // Truncate long category names
          String displayName = category.name;
          if (displayName.length > 12) {
            displayName = '${displayName.substring(0, 10)}...';
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(displayName),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category.id),
              selectedColor: AppColors.primary.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }
}
