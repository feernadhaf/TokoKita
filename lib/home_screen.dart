import 'package:flutter/material.dart';
import 'package:testtoko/cart_page.dart';
import 'package:testtoko/detail_produk.dart';
import 'package:testtoko/widgets/product_grid.dart';

import 'data/dummy/dummy_kategori.dart';
import 'data/models/model_kategori.dart';
import 'data/models/model_produk.dart';
import 'package:testtoko/data/models/cart_item.dart';
import 'theme/app_theme.dart';

// =========================
// HOME PAGE
// Produk ditarik dari ProductRepository (shared, fetch sekali,
// dipakai bareng sama Mall & Feeds). Kategori masih dummy.
// =========================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );
  int _bannerIndex = 0;
  final Set<String> _favoriteNames = {};

  final ProductRepository _repo = ProductRepository.instance;

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
                          _topBar(),
                          const SizedBox(height: 20),
                          _greetingRow(),
                          const SizedBox(height: 18),
                          _bannerCarousel(),
                          const SizedBox(height: 24),
                          _sectionHeader('Kategori'),
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
                          _sectionHeader('Promo Hari Ini 🔥'),
                          const SizedBox(height: 12),
                          _promoSection(),
                          const SizedBox(height: 24),
                          _sectionHeader('Produk Terbaru'),
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
  // Promo section (horizontal) dengan state loading/error
  // =========================
  Widget _promoSection() {
    if (_repo.isLoading && _repo.products.isEmpty) {
      return const SizedBox(
        height: 210,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_repo.errorMessage != null && _repo.products.isEmpty) {
      return _errorState();
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _repo.products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return _promoItemView(_repo.products[index], context);
        },
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
        delegate: SliverChildBuilderDelegate((context, index) {
          return _productItemView(_repo.products[index], context);
        }, childCount: _repo.products.length),
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
  // Top Bar: search + chat + cart
  // =========================
  Widget _topBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.primary, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cari produk yang kamu inginkan...',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _iconWithBadge(icon: Icons.chat_bubble_outline, count: 3),
        const SizedBox(width: 10),
        _iconWithBadge(
          icon: Icons.shopping_cart_outlined,
          count: 2,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _iconWithBadge({
    required IconData icon,
    required int count,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Badge(
          label: Text('$count'),
          backgroundColor: AppColors.accent,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }

  // =========================
  // Greeting + quick action
  // =========================
  Widget _greetingRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang 👋',
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Mau belanja apa hari ini?',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
        ),
      ],
    );
  }

  // =========================
  // Section Header with "Lihat semua"
  // =========================
  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Text(
          'Lihat semua',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // =========================
  // Flash Sale Banner Carousel
  // =========================
  Widget _bannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: 3,
            onPageChanged: (index) => setState(() => _bannerIndex = index),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'FLASH SALE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Diskon hingga 50%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Belanja Sekarang',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 28,
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
            3,
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
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Center(
            child: Icon(
              _categoryIcon(category.name),
              size: 30,
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
  // Promo Card (horizontal, with discount + favorite)
  // =========================
  Widget _promoItemView(Product product, BuildContext context) {
    final isFavorite = _favoriteNames.contains(product.name);

    return SizedBox(
      width: 160,
      child: Container(
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
                      Positioned(
                        top: 6,
                        right: 6,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isFavorite) {
                                _favoriteNames.remove(product.name);
                              } else {
                                _favoriteNames.add(product.name);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 15,
                              color: isFavorite
                                  ? Colors.red
                                  : AppColors.textSecondary,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${product.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
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
      ),
    );
  }

  // =========================
  // Product Card Widget (grid)
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
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12, color: AppColors.accent),
                            SizedBox(width: 3),
                            Text(
                              '4.8',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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