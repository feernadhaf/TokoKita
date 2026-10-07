import 'package:flutter/material.dart';
import 'package:testtoko/detail_produk.dart';
import 'package:testtoko/widgets/product_grid.dart';

import 'data/dummy/dummy_kategori.dart';
import 'data/models/model_kategori.dart';
import 'data/models/model_produk.dart';
import 'theme/app_theme.dart';

// =========================
// MALL PAGE
// =========================

class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen> {
  final PageController _bannerController = PageController();
  int _bannerIndex = 0;

  final ProductRepository _repo = ProductRepository.instance;

  final List<Color> _bannerColors = const [
    AppColors.primary,
    Color(0xFFFF9800),
    Color(0xFF2D6CDF),
  ];

  @override
  void initState() {
    super.initState();
    _repo.fetchProducts();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _mallAppBar(),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _repo,
          builder: (context, _) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => _repo.fetchProducts(forceRefresh: true),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bannerCarousel(),
                          const SizedBox(height: 22),
                          _sectionTitle('Kategori Pilihan'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 96,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 14),
                              itemBuilder: (context, index) {
                                return _categoryItemView(categories[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          _flashSaleHeader(),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                  _productGridSliver(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================
  // Grid produk (sliver) dengan state loading/error
  // =========================
  Widget _productGridSliver() {
    if (_repo.isLoading && _repo.products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    if (_repo.errorMessage != null && _repo.products.isEmpty) {
      return SliverToBoxAdapter(child: _errorState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _productItemView(_repo.products[index], context);
          },
          childCount: _repo.products.length,
        ),
      ),
    );
  }

  Widget _errorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 36, color: AppColors.textSecondary),
            const SizedBox(height: 10),
            Text(
              _repo.errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _repo.fetchProducts(forceRefresh: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // AppBar
  // =========================
  PreferredSizeWidget _mallAppBar() {
    return AppBar(
      title: const Text('Mall'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // =========================
  // Section Title
  // =========================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  // =========================
  // Banner Carousel (promo)
  // =========================
  Widget _bannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _bannerColors.length,
            onPageChanged: (index) => setState(() => _bannerIndex = index),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _bannerColors[index],
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Diskon Spesial',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Hemat sampai 50% untuk\nproduk pilihan hari ini',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_offer_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerColors.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _bannerIndex == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _bannerIndex == index
                    ? AppColors.primary
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // Category name -> Flutter icon mapping
  // =========================
  IconData _categoryIcon(String name) {
    final key = name.toLowerCase();
    if (key.contains('elektronik')) return Icons.devices_other_rounded;
    if (key.contains('fashion')) return Icons.checkroom_rounded;
    if (key.contains('makan') || key.contains('food')) {
      return Icons.restaurant_rounded;
    }
    if (key.contains('olahraga') || key.contains('sport')) {
      return Icons.sports_soccer_rounded;
    }
    if (key.contains('buku') || key.contains('book')) {
      return Icons.menu_book_rounded;
    }
    if (key.contains('game') || key.contains('mainan')) {
      return Icons.sports_esports_rounded;
    }
    if (key.contains('otomotif') || key.contains('mobil')) {
      return Icons.directions_car_filled_rounded;
    }
    if (key.contains('kesehatan') || key.contains('health')) {
      return Icons.health_and_safety_rounded;
    }
    if (key.contains('kecantikan') || key.contains('beauty')) {
      return Icons.face_retouching_natural_rounded;
    }
    if (key.contains('rumah') || key.contains('home')) {
      return Icons.chair_rounded;
    }
    if (key.contains('bayi') || key.contains('anak')) {
      return Icons.child_friendly_rounded;
    }
    if (key.contains('elektro') || key.contains('gadget')) {
      return Icons.smartphone_rounded;
    }
    return Icons.category_rounded;
  }

  // =========================
  // Category Item Widget
  // =========================
  Widget _categoryItemView(Category category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Icon(
              _categoryIcon(category.name),
              size: 32,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // Flash Sale header (judul + timer dekoratif)
  // =========================
  Widget _flashSaleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, color: AppColors.accent, size: 20),
            const SizedBox(width: 4),
            _sectionTitle('Flash Sale'),
          ],
        ),
        Row(
          children: const [
            Text(
              'Lihat semua',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2),
            Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ],
    );
  }

  // =========================
  // Product Card Widget
  // =========================
  Widget _productItemView(Product product, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProdukScreen(product: product),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppTheme.productImage(
                      product.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '-20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rp ${product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}