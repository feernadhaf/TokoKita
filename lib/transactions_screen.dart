import 'package:flutter/material.dart';
import 'package:testtoko/data/dummy/dummy_transaksi.dart';
import 'package:testtoko/data/models/model_produk_transaksi.dart';

import 'data/dummy/dummy_transactions.dart';
import 'data/models/model_transactions.dart';
import 'detail_produk.dart';
import 'order_tracking_screen.dart';
import 'theme/app_theme.dart';

// =========================
// TRANSACTIONS PAGE
// =========================

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<String> _tabs = [
    'Semua',
    'Diproses',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  final List<Transaction> _transactions = transactions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatRupiah(num value) {
    final rounded = value.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < rounded.length; i++) {
      final posFromEnd = rounded.length - i;
      buffer.write(rounded[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  List<Transaction> _filteredFor(String tab) {
    if (tab == 'Semua') return _transactions;
    return _transactions.where((tx) => tx.status.label == tab).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Transaksi')),
      body: Column(
        children: [
          _statusTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) => _transactionList(tab)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Tab bar status
  // =========================
  Widget _statusTabBar() {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.only(bottom: 4),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  // =========================
  // List transaksi per tab
  // =========================
  Widget _transactionList(String tab) {
    final items = _filteredFor(tab);

    if (items.isEmpty) {
      return _emptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _transactionCard(items[index]),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada transaksi',
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
  // Card transaksi
  // =========================
  Widget _transactionCard(Transaction tx) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Header: order id + status badge
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.orderId,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tx.date,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(tx.status),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Body: produk
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AppTheme.productImage(
                    tx.product.image,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tx.quantity}x Rp ${tx.product.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Footer: total + tombol aksi
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total  ',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatRupiah(tx.total),
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                _actionButton(tx, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(TxStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 13, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(Transaction tx, BuildContext context) {
    late final String label;
    switch (tx.status) {
      case TxStatus.diproses:
        label = 'Lacak Pesanan';
        break;
      case TxStatus.dikirim:
        label = 'Lihat Resi';
        break;
      case TxStatus.selesai:
        label = 'Beli Lagi';
        break;
      case TxStatus.dibatalkan:
        label = 'Pesan Lagi';
        break;
    }

    return OutlinedButton(
      onPressed: () {
        if (tx.status == TxStatus.selesai) {
          // Beli Lagi -> lempar ke halaman detail produk
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProdukScreen(product: tx.product),
            ),
          );
        } else {
          // Lacak Pesanan, Lihat Resi, Pesan Lagi -> halaman lacak pesanan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(transaction: tx),
            ),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}