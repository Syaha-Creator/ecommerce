// lib/features/product/presentation/widgets/sort_options.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/dimensions.dart';

enum SortOption {
  relevance('relevance', 'Relevance'),
  newest('newest', 'Newest'),
  priceLowToHigh('price_low_to_high', 'Price: Low to High'),
  priceHighToLow('price_high_to_low', 'Price: High to Low'),
  rating('rating', 'Highest Rating'),
  name('name', 'Name: A to Z');

  final String value;
  final String label;

  const SortOption(this.value, this.label);
}

class SortOptionsBottomSheet extends StatelessWidget {
  final String? currentSort;
  final Function(String) onSortChanged;

  const SortOptionsBottomSheet({
    Key? key,
    this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          topRight: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...SortOption.values.map((option) => _buildSortOption(
                context,
                option: option,
                isSelected: currentSort == option.value,
                onTap: () {
                  onSortChanged(option.value);
                  Navigator.of(context).pop();
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context, {
    required SortOption option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingMedium,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
