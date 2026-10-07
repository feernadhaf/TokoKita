import 'package:flutter/material.dart';
import 'package:testtoko/detail_produk.dart';
import 'package:testtoko/widgets/product_grid.dart';
import 'data/dummy/dummy_kategori.dart';
import 'data/models/model_kategori.dart';
import 'data/models/model_produk.dart';
import 'theme/app_theme.dart';

// =========================
// FEEDS PAGE
// Feed vertikal ala shoppable video/foto, tiap post nempel ke 1 produk.
// Produk ditarik dari ProductRepository yang sama kayak Home & Mall.
// =========================

class _FeedPost {
  final String username;
  final String caption;
  final Product product;

  _FeedPost({
    required this.username,
    required this.caption,
    required this.product,
  });
}

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final PageController _pageController = PageController();
  final Set<int> _likedIndexes = {};

  final ProductRepository _repo = ProductRepository.instance;

  @override
  void initState() {
    super.initState();
    _repo.fetchProducts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_FeedPost> _buildPosts(List<Product> products) {
    return List.generate(
      products.length,
      (index) => _FeedPost(
        username: '@toko_kece${index + 1}',
        caption:
            'Cek produk ini, kualitasnya juara! Buruan order sebelum kehabisan ✨',
        product: products[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          if (_repo.isLoading && _repo.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (_repo.errorMessage != null && _repo.products.isEmpty) {
            return _errorState();
          }

          final posts = _buildPosts(_repo.products);

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _feedItem(posts[index], index, context);
            },
          );
        },
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 40, color: Colors.white54),
          const SizedBox(height: 12),
          Text(
            _repo.errorMessage ?? 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => _repo.fetchProducts(forceRefresh: true),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }

  // =========================
  // Satu halaman feed (full screen)
  // =========================
  Widget _feedItem(_FeedPost post, int index, BuildContext context) {
    final isLiked = _likedIndexes.contains(index);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        AppTheme.productImage(
          post.product.image,
          fit: BoxFit.cover,
        ),

        // Gradient biar teks kebaca
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.35),
                Colors.transparent,
                Colors.black.withOpacity(0.75),
              ],
              stops: const [0, 0.4, 1],
            ),
          ),
        ),

        // Top bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Feeds',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right action column
        Positioned(
          right: 12,
          bottom: 130,
          child: Column(
            children: [
              _actionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: isLiked ? '${124 + 1}' : '124',
                color: isLiked ? Colors.redAccent : Colors.white,
                onTap: () {
                  setState(() {
                    if (isLiked) {
                      _likedIndexes.remove(index);
                    } else {
                      _likedIndexes.add(index);
                    }
                  });
                },
              ),
              const SizedBox(height: 18),
              _actionButton(
                icon: Icons.mode_comment_outlined,
                label: '38',
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _actionButton(
                icon: Icons.share_outlined,
                label: 'Bagikan',
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _actionButton(
                icon: Icons.bookmark_border_rounded,
                label: 'Simpan',
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom info + product chip
        Positioned(
          left: 16,
          right: 84,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                post.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              _productChip(post.product, context),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // Action button (like/comment/share/save)
  // =========================
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Product chip -> buka detail produk
  // =========================
  Widget _productChip(Product product, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProdukScreen(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppTheme.productImage(
                product.image,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rp ${product.price}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}