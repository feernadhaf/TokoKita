
import 'package:testtoko/data/models/model_produk_transaksi.dart';

import 'dummy_produk.dart';

// =========================
// DUMMY TRANSAKSI
// Riwayat transaksi tetep dummy (bukan dari API), karena order history
// itu snapshot yang udah kejadian, bukan data live katalog produk.
// =========================

final List<Transaction> transactions = List.generate(
  products.length,
  (index) {
    final statuses = TxStatus.values;
    return Transaction(
      orderId: 'INV/2026/${(1000 + index).toString()}',
      date: '${(index % 28) + 1} Sep 2026',
      product: products[index],
      quantity: (index % 3) + 1,
      status: statuses[index % statuses.length],
    );
  },
);