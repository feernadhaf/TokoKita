import 'package:flutter/material.dart';
import 'package:testtoko/services/session_services.dart';
import 'package:testtoko/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkSession() async {
    await Future.delayed(const Duration(seconds: 3));

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
    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Lingkaran dekorasi halus di pojok
          Positioned(top: -90, right: -70, child: _circle(240, 0.07)),
          Positioned(bottom: -110, left: -80, child: _circle(280, 0.06)),
          Positioned(top: 140, left: -40, child: _circle(90, 0.05)),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutBack,
                      builder: (context, v, child) => Opacity(
                        opacity: v.clamp(0.0, 1.0),
                        child: Transform.scale(scale: 0.8 + 0.2 * v, child: child),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _logo(),
                          const SizedBox(height: 28),
                          const Text(
                            'Selamat Datang',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aplikasi Belanja Online Terpercaya',
                            style: TextStyle(
                              color: AppColors.primaryLight.withOpacity(0.9),
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Loading + versi di bawah
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Menyiapkan toko kamu...',
                  style: TextStyle(
                    color: AppColors.primaryLight.withOpacity(0.8),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            size: 58,
            color: AppColors.primary,
          ),
        ),
        // Titik aksen oranye
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: const Icon(Icons.star_rounded, size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}