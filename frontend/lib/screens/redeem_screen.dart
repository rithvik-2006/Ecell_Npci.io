import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/widgets/glassmorphic_card.dart';
import 'package:frontend/services/api_service.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  Map<String, dynamic>? redeemData;
  bool isLoading = true;
  String? selectedPartner;
  TextEditingController inputController = TextEditingController();
  String? convertedPoints;

  @override
  void initState() {
    super.initState();
    fetchRedeemData();
  }

  Future<void> fetchRedeemData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService().fetchOffers();
      setState(() {
        redeemData = data;
        selectedPartner = data['partners']?.first['name'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load redeem data');
    }
  }

  void convertPoints() {
    if (selectedPartner != null && inputController.text.isNotEmpty) {
      final partner = redeemData?['partners']?.firstWhere((p) => p['name'] == selectedPartner);
      final double multiplier = partner?['multiplier'] ?? 1.0;
      final double inputPoints = double.tryParse(inputController.text) ?? 0.0;
      setState(() {
        convertedPoints = (inputPoints * multiplier).toStringAsFixed(2);
      });
    }
  }

  void _showTransferModal(BuildContext context, String partnerName) {
    TextEditingController transferController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transfer Points to $partnerName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: transferController,
                decoration: const InputDecoration(
                  labelText: 'Input value',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final double points = double.tryParse(transferController.text) ?? 0.0;
                try {
                  await ApiService().transferPoints(partnerName, points);
                  context.pop();
                  fetchRedeemData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Points transferred successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to transfer points: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassmorphicCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${redeemData?['points'] ?? '0'} points',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...?redeemData?['partners']
                      ?.map((program) => _buildRewardProgramCard(context, program))
                      .toList(),
                  const SizedBox(height: 24),
                  GlassmorphicCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Smart Conversion',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Transfer points between programs with our smart conversion system.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: inputController,
                            decoration: const InputDecoration(
                              labelText: 'Enter points to convert',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedPartner,
                            decoration: const InputDecoration(
                              labelText: 'Select Partner',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                redeemData?['partners']?.map<DropdownMenuItem<String>>((partner) {
                              return DropdownMenuItem<String>(
                                value: partner['name'],
                                child: Text(partner['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPartner = value;
                                convertPoints();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: convertPoints,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Start Conversion',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (convertedPoints != null)
                            Text(
                              'Converted Points: $convertedPoints',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRewardProgramCard(BuildContext context, Map<String, dynamic> program) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassmorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF6F4E37),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${program['normalised_points']} points',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  _showTransferModal(context, program['name']);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Transfer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
