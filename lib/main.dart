import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:testtoko/feeds_screen.dart';
import 'package:testtoko/home_screen.dart';
import 'package:testtoko/login_screen.dart';
import 'package:testtoko/mall_screen.dart';
import 'package:testtoko/profile_screen.dart';
import 'package:testtoko/register_screen.dart';
import 'package:testtoko/splah_screen.dart';
import 'package:testtoko/theme/app_theme.dart';
import 'package:testtoko/transactions_screen.dart';



/// Flutter code sample for [NavigationBar].

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      themeMode: AppTheme.themeMode, // dikunci ke light

      // Splash tampil pertama, dia yang nentuin lanjut ke /home atau /login
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const NavigationExample(),
      },
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  List<Widget> pages = [
    HomeScreen(),
    FeedsScreen(),
    MallScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];
  // Kondisi navbar muncul atau tidak
  bool _showNavigationBar = true;

  // Penentu kondisi navbar muncul atau tidak
  void _handleScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        setState(() {
          _showNavigationBar = false;
        });
      }

      if (notification.direction == ScrollDirection.forward) {
        setState(() {
          _showNavigationBar = true;
        });
      }
    }
  }

  // Biar dialog "Login Berhasil!" cuma muncul sekali
  bool dialogsSudahMuncul = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (dialogsSudahMuncul) return;
    dialogsSudahMuncul = true;

    // Ambil data yang dikirim dari LoginScreen lewat Navigator arguments
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final datadiri = arguments?['data'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (datadiri != null) {
        _showWelcomeDialog(datadiri);
      }
    });
  }

  // =========================
  // Dialog selamat datang setelah login
  // =========================
  void _showWelcomeDialog(Map<String, dynamic> datadiri) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon sukses
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 55,
              ),
            ),
            const SizedBox(height: 18),

            // Judul
            const Text(
              'Login Berhasil!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            // Nama
            Text(
              'Selamat datang, ${datadiri['nama']}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Role
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Role: ${datadiri['role']}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Lanjutkan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _handleScroll(notification);
              return false;
            },
            child: pages[currentPageIndex]),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: 16,
            right: 16,
            bottom: _showNavigationBar ? 12 : -100,
            child: MyNav(context),
          )
          
        ],
      ),

    );
  }

  Card MyNav(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      elevation: 8,
      child: NavigationBar(
        onDestinationSelected: (int selectedMenu) {
          setState(() {
            currentPageIndex = selectedMenu;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          // menu-menu di bawah
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.video_collection, color: Colors.white),
            icon: Icon(Icons.video_collection_outlined),
            label: 'Feeds',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.store, color: Colors.white),
            icon: Icon(Icons.store_outlined),
            label: 'Mall',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            icon: Badge(label: Text('2'), child: Icon(Icons.list_alt_outlined)),
            label: 'Transactions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: Colors.white),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}