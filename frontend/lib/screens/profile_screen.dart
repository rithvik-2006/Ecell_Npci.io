import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/bottom_navigation.dart';
import 'package:frontend/widgets/glassmorphic_card.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoadingRewards = true;
  Map<String, dynamic>? _rewardsData;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _fetchCustomerStatistics();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          _user = user;
        });
      } else {
        _showErrorSnackbar('User not logged in');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load user profile: $e');
    }
  }

  Future<void> _fetchCustomerStatistics() async {
    try {
      final data = await ApiService().fetchCustomerStatistics();
      setState(() {
        _rewardsData = data;
        _isLoadingRewards = false;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to fetch rewards data: $e');
      setState(() {
        _isLoadingRewards = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      context.go('/login');
    } catch (e) {
      _showErrorSnackbar('Failed to log out: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
            const SizedBox(height: 24),
            if (_user != null)
              const Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://cdn-icons-png.flaticon.com/512/8847/8847419.png'),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            GlassmorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Email', _user?.email ?? 'john.doe@example.com'),
                    _buildInfoRow('Member Since', 'January 1, 2023'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GlassmorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rewards Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingRewards)
                      const Center(child: CircularProgressIndicator())
                    else if (_rewardsData != null)
                      Column(
                        children: [
                          _buildRewardRow(
                              'Total Points', _rewardsData!['totalPoints'].toString(), context),
                          _buildRewardRow('Points Redeemed',
                              _rewardsData!['pointsRedeemed'].toString(), context),
                          _buildRewardRow('Current Balance',
                              _rewardsData!['currentBalance'].toString(), context),
                        ],
                      )
                    else
                      const Center(child: Text('No rewards data available')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(
        initialIndex: 4,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRewardRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
