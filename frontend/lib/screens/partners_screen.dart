import 'package:flutter/material.dart';
import 'package:frontend/widget/glassmorphic_card.dart';

class PartnersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> partners = [
    {'name': 'Coffee Shop', 'category': 'Food & Beverage', 'logo': 'assets/coffee_shop_logo.png'},
    {'name': 'Supermarket', 'category': 'Grocery', 'logo': 'assets/supermarket_logo.png'},
    {'name': 'Cinema', 'category': 'Entertainment', 'logo': 'assets/cinema_logo.png'},
    {'name': 'Fine Dining', 'category': 'Restaurants', 'logo': 'assets/fine_dining_logo.png'},
    {'name': 'Bookstore', 'category': 'Retail', 'logo': 'assets/bookstore_logo.png'},
    {'name': 'Gym', 'category': 'Fitness', 'logo': 'assets/gym_logo.png'},
  ];

  PartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Stores'),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: partners.length,
        itemBuilder: (context, index) {
          return _buildPartnerCard(context, partners[index]);
        },
      ),
    );
  }

  Widget _buildPartnerCard(BuildContext context, Map<String, dynamic> partner) {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              partner['logo'],
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 16),
            Text(
              partner['name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              partner['category'],
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('View Offers'),
            ),
          ],
        ),
      ),
    );
  }
}
