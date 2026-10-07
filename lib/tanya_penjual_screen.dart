import 'package:flutter/material.dart';

import 'data/models/model_produk.dart';
import 'theme/app_theme.dart';

// =========================
// TANYA PENJUAL
// Chat sederhana antara pembeli & penjual, dibuka dari halaman detail produk.
// Belum konek ke backend chat asli — masih simulasi lokal.
// =========================

enum _Sender { seller, buyer }

class _ChatMessage {
  final _Sender sender;
  final String text;
  final String time;

  _ChatMessage({required this.sender, required this.text, required this.time});
}

class TanyaPenjualScreen extends StatefulWidget {
  final Product product;

  const TanyaPenjualScreen({super.key, required this.product});

  @override
  State<TanyaPenjualScreen> createState() => _TanyaPenjualScreenState();
}

class _TanyaPenjualScreenState extends State<TanyaPenjualScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: _Sender.seller,
      text: 'Halo, kak! Ada yang bisa dibantu soal produk ini?',
      time: '09:12',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(sender: _Sender.buyer, text: text, time: 'Baru saja'),
      );
      _messageController.clear();
    });

    // Balasan otomatis dummy, biar chat-nya kerasa hidup.
    // TODO: ganti dengan koneksi ke sistem chat/backend asli.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            sender: _Sender.seller,
            text: 'Baik kak, ditunggu ya, admin akan segera membalas 🙏',
            time: 'Baru saja',
          ),
        );
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _sellerAppBar(),
      body: Column(
        children: [
          _productPreview(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messageBubble(_messages[index]),
            ),
          ),
          _messageInput(),
        ],
      ),
    );
  }

  // =========================
  // AppBar: avatar penjual + status online
  // =========================
  PreferredSizeWidget _sellerAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storefront_rounded,
                size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Toko Online Official',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 11.5, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Preview produk yang ditanyain, nempel di atas chat
  // =========================
  Widget _productPreview() {
    final product = widget.product;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppTheme.productImage(
              product.image,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rp ${product.price}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
  // Bubble chat
  // =========================
  Widget _messageBubble(_ChatMessage message) {
    final isBuyer = message.sender == _Sender.buyer;

    return Align(
      alignment: isBuyer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isBuyer ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isBuyer ? 14 : 4),
            bottomRight: Radius.circular(isBuyer ? 4 : 14),
          ),
          boxShadow: isBuyer ? null : AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: isBuyer ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                fontSize: 10.5,
                color: isBuyer
                    ? Colors.white.withOpacity(0.75)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Input pesan
  // =========================
  Widget _messageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AppColors.primaryLight.withOpacity(0.4),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: _sendMessage,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
