import 'package:flutter/material.dart';
import 'package:frontend/widget/glassmorphic_card.dart';

class RedeemScreen extends StatelessWidget {
  final List<Map<String, dynamic>> redeemOffers = [
    {'title': '10% Off Coffee', 'points': 500, 'store': 'Coffee Shop'},
    {'title': '\$20 Grocery Voucher', 'points': 2000, 'store': 'Supermarket'},
    {'title': 'Free Movie Ticket', 'points': 1500, 'store': 'Cinema'},
    {'title': '15% Off Restaurant Bill', 'points': 1000, 'store': 'Fine Dining'},
  ];

  RedeemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Points'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassmorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instant Redemption',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Use QR code for in-store purchases',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code),
                      onPressed: () {},
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...redeemOffers.map((offer) => _buildRedeemOfferCard(context, offer)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemOfferCard(BuildContext context, Map<String, dynamic> offer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassmorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer['title'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                offer['store'],
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${offer['points']} points',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Redeem'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
