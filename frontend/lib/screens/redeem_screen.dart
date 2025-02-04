import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/bottom_navigation.dart';
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
        convertedPoints = (inputPoints / multiplier).toStringAsFixed(2);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inputController.addListener(convertPoints);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void _showTransferModal(BuildContext context, String partnerName) {
    TextEditingController transferController = TextEditingController();
    bool isTransferring = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Transfer Points to $partnerName',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: transferController,
                    decoration: const InputDecoration(
                      labelText: 'Input value',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  isTransferring
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isTransferring = true;
                            });
                            final double points = double.tryParse(transferController.text) ?? 0.0;
                            try {
                              await ApiService().transferPoints(partnerName, points);
                              Navigator.pop(context);
                              fetchRedeemData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Points transferred successfully. Your reward points will be redeemed within 24 hours.')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to transfer points: ${e.toString()}')),
                              );
                            } finally {
                              setState(() {
                                isTransferring = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Redeem', style: TextStyle(color: Colors.white)),
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Redeem Page',
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
                            '${redeemData?['points'] ?? '0'} URT',
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
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedPartner,
                            decoration: const InputDecoration(
                              labelText: 'Select Partner',
                              labelStyle: TextStyle(color: Colors.white),
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
                          if (convertedPoints != null)
                            Text(
                              'Converted Points: $convertedPoints URT',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavigation(
        initialIndex: 2,
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: SvgPicture.network(
                    program['logo_path'],
                    fit: BoxFit.fitWidth,
                    width: 48,
                    height: 48,
                  ),
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
                  'Redeem',
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
