import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'model_produk.dart';

// =========================
// MODEL TRANSAKSI
// =========================

enum TxStatus { diproses, dikirim, selesai, dibatalkan }

extension TxStatusX on TxStatus {
  String get label {
    switch (this) {
      case TxStatus.diproses:
        return 'Diproses';
      case TxStatus.dikirim:
        return 'Dikirim';
      case TxStatus.selesai:
        return 'Selesai';
      case TxStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case TxStatus.diproses:
        return AppColors.accent;
      case TxStatus.dikirim:
        return AppColors.primary;
      case TxStatus.selesai:
        return AppColors.primary;
      case TxStatus.dibatalkan:
        return Colors.redAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case TxStatus.diproses:
        return Icons.autorenew_rounded;
      case TxStatus.dikirim:
        return Icons.local_shipping_outlined;
      case TxStatus.selesai:
        return Icons.check_circle_outline_rounded;
      case TxStatus.dibatalkan:
        return Icons.cancel_outlined;
    }
  }
}

class Transaction {
  final String orderId;
  final String date;
  final Product product;
  final int quantity;
  final TxStatus status;

  Transaction({
    required this.orderId,
    required this.date,
    required this.product,
    required this.quantity,
    required this.status,
  });

  num get total {
    final price = num.tryParse(product.price.toString()) ?? 0;
    return price * quantity;
  }
}