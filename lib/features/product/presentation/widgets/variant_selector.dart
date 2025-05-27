import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/variant.dart';

class VariantSelector extends StatelessWidget {
  final List<Variant> variants;
  final String? selectedVariantId;
  final Function(Variant) onVariantSelected;
  final Map<String, List<Variant>> groupedVariants;

  VariantSelector({
    Key? key,
    required this.variants,
    this.selectedVariantId,
    required this.onVariantSelected,
  })  : groupedVariants = _groupVariantsByType(variants),
        super(key: key);

  static Map<String, List<Variant>> _groupVariantsByType(
      List<Variant> variants) {
    final grouped = <String, List<Variant>>{};
    for (final variant in variants) {
      grouped.putIfAbsent(variant.type, () => []).add(variant);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedVariants.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildVariantGroup(
            context,
            type: entry.key,
            variants: entry.value,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVariantGroup(
    BuildContext context, {
    required String type,
    required List<Variant> variants,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatVariantType(type),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: variants.map((variant) {
            final isSelected = variant.id == selectedVariantId;
            final isAvailable = variant.inStock;

            if (type.toLowerCase() == 'color') {
              return _buildColorVariant(
                context,
                variant: variant,
                isSelected: isSelected,
                isAvailable: isAvailable,
              );
            } else {
              return _buildTextVariant(
                context,
                variant: variant,
                isSelected: isSelected,
                isAvailable: isAvailable,
              );
            }
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorVariant(
    BuildContext context, {
    required Variant variant,
    required bool isSelected,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable ? () => onVariantSelected(variant) : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getColorFromName(variant.value),
                  image: variant.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(variant.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              if (!isAvailable)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextVariant(
    BuildContext context, {
    required Variant variant,
    required bool isSelected,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable ? () => onVariantSelected(variant) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isAvailable
                    ? Colors.grey[300]!
                    : Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              variant.value,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black87
                        : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (variant.additionalPrice != null && variant.additionalPrice! > 0)
              Text(
                '+${_formatPrice(variant.additionalPrice!)}',
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white70
                      : isAvailable
                          ? Colors.grey[600]
                          : Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatVariantType(String type) {
    return type[0].toUpperCase() + type.substring(1);
  }

  Color _getColorFromName(String colorName) {
    final colors = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'black': Colors.black,
      'white': Colors.white,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'brown': Colors.brown,
    };

    return colors[colorName.toLowerCase()] ?? Colors.grey;
  }

  String _formatPrice(double price) {
    final formatter = price.toStringAsFixed(0);
    final result = formatter.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $result';
  }
}
