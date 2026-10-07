import 'package:flutter/material.dart';
import 'package:testtoko/data/models/model_produk_transaksi.dart';

import 'data/models/model_transactions.dart';
import 'tanya_penjual_screen.dart';
import 'theme/app_theme.dart';

// =========================
// LACAK PESANAN
// Dibuka dari tombol "Lacak Pesanan", "Lihat Resi", dan "Pesan Lagi"
// di TransactionsScreen. Nampilin timeline status + info pesanan.
// =========================

class OrderTrackingScreen extends StatelessWidget {
  final Transaction transaction;

  const OrderTrackingScreen({super.key, required this.transaction});

  static const List<String> _steps = [
    'Pesanan Dibuat',
    'Diproses',
    'Dikirim',
    'Selesai',
  ];

  int get _reachedStepIndex {
    switch (transaction.status) {
      case TxStatus.diproses:
        return 1;
      case TxStatus.dikirim:
        return 2;
      case TxStatus.selesai:
        return 3;
      case TxStatus.dibatalkan:
        return -1; // ditangani khusus, bukan lewat timeline normal
    }
  }

  String get _dummyResi {
    final digits = transaction.orderId.replaceAll(RegExp(r'[^0-9]'), '');
    return 'JX${digits}ID';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Lacak Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _orderHeader(),
          const SizedBox(height: 20),
          transaction.status == TxStatus.dibatalkan
              ? _cancelledCard()
              : _timelineCard(),
          const SizedBox(height: 16),
          _productCard(context),
        ],
      ),
    );
  }

  // =========================
  // Header: order id, tanggal, status badge
  // =========================
  Widget _orderHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.orderId,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: transaction.status.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(transaction.status.icon,
                    size: 13, color: transaction.status.color),
                const SizedBox(width: 4),
                Text(
                  transaction.status.label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: transaction.status.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Timeline status (normal: diproses/dikirim/selesai)
  // =========================
  Widget _timelineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Pengiriman',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (transaction.status == TxStatus.dikirim ||
              transaction.status == TxStatus.selesai) ...[
            const SizedBox(height: 6),
            Text(
              'No. Resi: $_dummyResi',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 18),
          ...List.generate(_steps.length, (index) {
            final isLast = index == _steps.length - 1;
            final isReached = index <= _reachedStepIndex;

            return _timelineStep(
              label: _steps[index],
              isReached: isReached,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _timelineStep({
    required String label,
    required bool isReached,
    required bool isLast,
  }) {
    final color = isReached ? AppColors.primary : AppColors.divider;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isReached ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: isReached
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isReached ? FontWeight.w600 : FontWeight.w400,
                color: isReached
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Card khusus kalau status dibatalkan
  // =========================
  Widget _cancelledCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          const Icon(Icons.cancel_outlined, size: 40, color: Colors.redAccent),
          const SizedBox(height: 12),
          const Text(
            'Pesanan Dibatalkan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pesanan ini udah dibatalkan dan gak diproses lebih lanjut.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Info produk yang dipesan
  // =========================
  Widget _productCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppTheme.productImage(
              transaction.product.image,
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
                  transaction.product.name,
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
                  '${transaction.quantity}x Rp ${transaction.product.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TanyaPenjualScreen(product: transaction.product),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}