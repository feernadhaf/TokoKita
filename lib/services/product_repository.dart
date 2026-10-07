import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:testtoko/data/models/model_produk.dart';



// =========================
// PRODUCT REPOSITORY
// Singleton, jadi data produk dari API cuma di-fetch SEKALI dan
// dipakai bareng-bareng sama Home, Mall, Feeds (gak fetch sendiri-sendiri).
// =========================

class ProductRepository extends ChangeNotifier {
  ProductRepository._internal();
  static final ProductRepository instance = ProductRepository._internal();

  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;
  bool _hasFetchedOnce = false;

  // Kalau data udah pernah berhasil di-fetch, gak fetch ulang lagi
  // kecuali forceRefresh: true (misal dari pull-to-refresh).
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_hasFetchedOnce && !forceRefresh) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('https://fakestoreapi.com/products');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat produk (${response.statusCode})');
      }

      final data = jsonDecode(response.body) as List;

      products = data.map((item) {
        final priceValue = item['price'];
        final roundedPrice = priceValue is num ? priceValue.round() : 0;

        return Product(
          name: item['title']?.toString() ?? 'Produk',
          image: item['image']?.toString() ?? '',
          price: roundedPrice,
        );
      }).toList();

      _hasFetchedOnce = true;
    } catch (e) {
      // Biar kelihatan error asli-nya di Debug Console (SocketException,
      // HandshakeException, dll) alih-alih cuma pesan generik ke user.
      debugPrint('ProductRepository fetch error: $e');
      errorMessage = 'Gagal memuat produk. Cek koneksi internet kamu.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}