// lib/features/home/presentation/widgets/category_slider.dart (perbaikan)
import 'package:flutter/material.dart';
import '../../../../core/theme/dimensions.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data kategori sampel
    final categories = [
      {'name': 'Smartphones', 'icon': Icons.smartphone},
      {'name': 'Laptops', 'icon': Icons.laptop},
      {'name': 'Audio', 'icon': Icons.headphones},
      {'name': 'Wearables', 'icon': Icons.watch},
      {'name': 'Accessories', 'icon': Icons.cable},
      {'name': 'TVs', 'icon': Icons.tv},
      {'name': 'Cameras', 'icon': Icons.camera_alt},
      {'name': 'Gaming', 'icon': Icons.sports_esports},
    ];

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
                    // TODO: Navigate to categories page
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120, // Tingkatkan sedikit untuk layout yang lebih baik
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 90, // Lebarkan untuk nama kategori yang lebih panjang
                  margin: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to category products
                    },
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
                              category['icon'] as IconData,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'] as String,
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
}
