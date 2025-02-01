import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/partners_screen.dart';
import 'package:frontend/screens/redeem_screen.dart';
import 'package:frontend/screens/transfer_screen.dart';

void main() {
  runApp(const UnifiedRewardSystemsApp());
}

class UnifiedRewardSystemsApp extends StatelessWidget {
  const UnifiedRewardSystemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unified Reward Systems',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00C6FF),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Inter',
            ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFD700)),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    TransferScreen(),
    RedeemScreen(),
    PartnersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Transfer'),
          BottomNavigationBarItem(icon: Icon(Icons.redeem), label: 'Redeem'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Partners'),
          // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
