// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:testtoko/services/session_services.dart';
import 'package:testtoko/theme/app_theme.dart';



// Import SessionServices jika diperlukan, diasumsikan sudah ada

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkSession() async {
    // Memberikan delay 3 detik untuk menampilkan SplashScreen
    await Future.delayed(const Duration(seconds: 3));

    // Logika SessionServices kamu (ini diasumsikan sudah ada)
    final isLogin = await SessionServices.isLogin();
    if (!mounted) return;

    if (isLogin) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil logika checkSession saat inisialisasi
    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Gunakan warna primer hijau tua dari app_theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gunakan logo aplikasi kamu di sini, gunakan warna accent oranye sebagai warna ikon
            Icon(
              Icons.shopping_bag_outlined,
              size: 100,
              color: AppColors.accent, // Warna aksen oranye
            ),
            const SizedBox(height: 20),
            // Teks selamat datang, gunakan AppColors.primaryLight untuk kontras yang baik
            Text(
              'Selamat Datang',
              style: TextStyle(
                color: AppColors.primaryLight, // Warna hijau muda untuk teks primer terang
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Teks ajakan, gunakan AppColors.primaryLight juga untuk kontras
            Text(
              'Aplikasi Belanja Online Terpercaya',
              style: TextStyle(
                color: AppColors.primaryLight, // Warna hijau muda untuk teks sekunder terang
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}