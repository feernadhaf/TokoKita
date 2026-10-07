import '../models/model_produk.dart';

// =========================
// DUMMY PRODUK
// NOTE: `image` sekarang nunjuk ke asset lokal (assets/img/...)
// bukan URL internet lagi. Pastikan folder ini udah didaftarin di pubspec.yaml.
// =========================

final List<Product> products = [
  Product(
    name: 'Sony WH-1000XM Headphone',
    image: 'assets/img/sony_headphone.png',
    price: 3499000,
  ),
  Product(
    name: 'UMEOX Smart Watch',
    image: 'assets/img/smartwatch.png',
    price: 450000,
  ),
  Product(
    name: 'Sepatu Lari Adizero',
    image: 'assets/img/running_shoes.png',
    price: 1850000,
  ),
  Product(
    name: 'Backpack Kulit Minimalis',
    image: 'assets/img/backpack.png',
    price: 620000,
  ),
  Product(
    name: 'Keyboard Mechanical 75%',
    image: 'assets/img/keyboard.png',
    price: 1250000,
  ),
  Product(
    name: 'Lamzu Maya X Wireless Mouse',
    image: 'assets/img/gaming_mouse.png',
    price: 899000,
  ),
  Product(
    name: 'Kaos Oversize Basic',
    image: 'assets/img/tshirt.png',
    price: 149000,
  ),
  Product(
    name: 'Breville Espresso Machine',
    image: 'assets/img/coffee_machine.png',
    price: 8750000,
  ),
];