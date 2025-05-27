// lib/features/home/presentation/widgets/category_slider.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/dimensions.dart';
import '../../../product/domain/entities/category.dart';

class CategorySlider extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategoryTap;

  const CategorySlider({
    Key? key,
    required this.categories,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to categories tab
                    // This should be handled by parent widget
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () => onCategoryTap(category),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(category.name),
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final iconMap = {
      'Electronics': Icons.devices,
      'Fashion': Icons.checkroom,
      'Home & Living': Icons.home,
      'Beauty & Health': Icons.face,
      'Sports & Outdoor': Icons.sports_basketball,
      'Food & Drinks': Icons.fastfood,
      'Books': Icons.book,
      'Toys': Icons.toys,
    };
    return iconMap[categoryName] ?? Icons.category;
  }
}
