// lib/features/home/presentation/widgets/featured_products.dart (FINAL CLEAN)
import 'package:flutter/material.dart';
import '../../../../core/theme/dimensions.dart';

class FeaturedProducts extends StatelessWidget {
  final String title;

  const FeaturedProducts({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data produk sampel
    final products = [
      {
        'id': 1,
        'name': 'Smartphone X Pro',
        'price': 5999000,
        'image': 'https://via.placeholder.com/300',
        'discount': 10,
      },
      {
        'id': 2,
        'name': 'Laptop Ultra Slim',
        'price': 12500000,
        'image': 'https://via.placeholder.com/300',
        'discount': 0,
      },
      {
        'id': 3,
        'name': 'Wireless Earbuds',
        'price': 1500000,
        'image': 'https://via.placeholder.com/300',
        'discount': 20,
      },
      {
        'id': 4,
        'name': 'Smart Watch',
        'price': 2500000,
        'image': 'https://via.placeholder.com/300',
        'discount': 0,
      },
    ];

    return Container(
      padding: const EdgeInsets.only(
        top: AppDimensions.paddingMedium,
        bottom: AppDimensions.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigasi ke halaman produk
                  },
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Product List dengan Fixed Height
          Container(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                // Konversi ke double secara eksplisit
                final discount = product['discount'] as int? ?? 0;
                final hasDiscount = discount > 0;
                final price = (product['price'] as int? ?? 0).toDouble();
                final discountPrice =
                    hasDiscount ? price * (100 - discount) / 100 : price;

                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigasi ke detail produk
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Gambar Produk dengan Fixed Height
                            Container(
                              height: 140,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      product['image'] as String? ??
                                          'https://via.placeholder.com/300',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 140,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Badge Diskon
                                  if (hasDiscount)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '-$discount%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Tombol Wishlist
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.favorite_border,
                                            size: 18),
                                        onPressed: () {
                                          // TODO: Tambahkan ke wishlist
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content Area dengan Fixed Height
                            Container(
                              height: 150,
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nama Produk dengan Fixed Height
                                  SizedBox(
                                    height: 40,
                                    child: Text(
                                      product['name'] as String? ??
                                          'Nama Produk',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Spacer untuk push price ke bawah
                                  const Spacer(),

                                  // Harga Area
                                  if (hasDiscount)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Rp ${_formatPrice(price)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp ${_formatPrice(discountPrice)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      'Rp ${_formatPrice(price)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  // Helper method untuk format harga
  String _formatPrice(double price) {
    if (price >= 1000000) {
      final millions = price / 1000000;
      if (millions == millions.roundToDouble()) {
        return '${millions.round()}M';
      } else {
        return '${millions.toStringAsFixed(1)}M';
      }
    } else if (price >= 1000) {
      final thousands = price / 1000;
      if (thousands == thousands.roundToDouble()) {
        return '${thousands.round()}K';
      } else {
        return '${thousands.toStringAsFixed(0)}K';
      }
    } else {
      return price.round().toString();
    }
  }
}
