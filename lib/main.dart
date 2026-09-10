import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:testtoko/feeds_screen.dart';
import 'package:testtoko/home_screen.dart';
import 'package:testtoko/login_screen.dart';
import 'package:testtoko/mall_screen.dart';
import 'package:testtoko/profile_screen.dart';
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
      themeMode: AppTheme.themeMode, // dikunci ke light, ga peduli setting laptop/HP
      home: const LoginScreen(), // pintu masuk: wajib login dulu
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