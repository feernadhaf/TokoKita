import 'package:flutter/material.dart';
import 'package:testtoko/data/models/cart_item.dart';

import 'data/dummy/dummy_cart.dart';
import 'theme/app_theme.dart';

// =========================
// CART PAGE (Keranjang Belanja)
// =========================

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Copy dari dummy data, biar perubahan (qty/hapus) gak ikut ngubah
  // list global `cartItems` kalau halaman ini dibuka ulang.
  late List<CartItem> _items = List<CartItem>.from(cartItems);

  // Bonus 2 — total jumlah semua produk (bukan jenis produk)
  int get _totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.jumlah);

  // Tahap 5 — total belanja = jumlah semua subtotal
  int get _totalBelanja =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  // Bonus 3 — format Rupiah pakai titik pemisah ribuan
  String _formatRupiah(int value) {
    final rounded = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < rounded.length; i++) {
      final posFromEnd = rounded.length - i;
      buffer.write(rounded[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  // Tahap 6 — tombol + (gak ada batas atas)
  void _increment(CartItem item) {
    setState(() => item.jumlah++);
  }

  // Tahap 6 — tombol - (gak boleh kurang dari 1)
  void _decrement(CartItem item) {
    if (item.jumlah <= 1) return;
    setState(() => item.jumlah--);
  }

  // Bonus 1 — hapus produk dari keranjang
  void _removeItem(CartItem item) {
    setState(() => _items.removeWhere((i) => i.id == item.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Keranjang ($_totalItemCount)'),
      ),
      body: _items.isEmpty
          ? _emptyState()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _cartItemCard(_items[index]);
                    },
                  ),
                ),
                _checkoutBar(),
              ],
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Keranjang kamu masih kosong',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Card 1 produk di keranjang
  // =========================
  Widget _cartItemCard(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppTheme.productImage(
              item.gambar,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // Bonus 1 — tombol hapus
                    InkWell(
                      onTap: () => _removeItem(item),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _formatRupiah(item.harga),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol +/-
                    Row(
                      children: [
                        _qtyButton(Icons.remove, () => _decrement(item)),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '${item.jumlah}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _qtyButton(Icons.add, () => _increment(item)),
                      ],
                    ),
                    // Tahap 4 — subtotal per produk
                    Text(
                      'Subtotal: ${_formatRupiah(item.subtotal)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: AppColors.primary),
      ),
    );
  }

  // =========================
  // Bar bawah: Total Belanja + Checkout
  // =========================
  Widget _checkoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Belanja',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupiah(_totalBelanja),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout berhasil (dummy)')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
