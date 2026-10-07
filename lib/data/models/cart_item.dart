// =========================
// MODEL CART ITEM
// =========================

class CartItem {
  final int id;
  final String nama;
  final int harga;
  final String gambar;
  int jumlah; // bukan final, karena jumlah bisa berubah (tombol +/-)

  CartItem({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.jumlah,
  });

  // Subtotal = harga satuan x jumlah produk ini di keranjang
  int get subtotal => harga * jumlah;
}
