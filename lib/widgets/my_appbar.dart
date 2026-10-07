
import 'package:flutter/material.dart';

class Myappbar extends StatelessWidget implements PreferredSizeWidget {
  const Myappbar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      title: Row(
        children: [
          // Search Bar
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  // fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
    
          const SizedBox(width: 8),
    
          // Tombol Chat
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline),
          ),
    
          // Tombol Keranjang
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
    );
  }
}