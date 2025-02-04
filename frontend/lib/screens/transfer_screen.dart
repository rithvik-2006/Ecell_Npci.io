import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/bottom_navigation.dart';
import 'package:frontend/widgets/glassmorphic_card.dart';
import 'package:frontend/services/api_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  Map<String, dynamic>? transferData;
  List<dynamic>? filteredPartners;
  bool isLoading = true;
  String? selectedPartner;
  bool isTransferring = false;
  String? partnerName;

  @override
  void initState() {
    super.initState();
    fetchTransferData();
  }

  Future<void> fetchTransferData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService().fetchTransferPoints();
      setState(() {
        transferData = data;
        filteredPartners = data['companies'];
        selectedPartner = data['companies']?.first['name'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load transfer data. Error: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
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
                    'Transfer Page',
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
                            '${transferData?['points'] ?? '0'} URT',
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
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Partners',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (query) {
                      setState(() {
                        filteredPartners = transferData?['companies']
                            ?.where((partner) => (partner['name'] as String)
                                .toLowerCase()
                                .startsWith(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ...?filteredPartners?.map((program) => _buildRewardProgramCard(context, program)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavigation(
        initialIndex: 1,
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
                    program['image_path'],
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
                      '${program['points']} points',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: isTransferring
                    ? null
                    : () async {
                        setState(() {
                          isTransferring = true;
                        });

                        try {
                          await ApiService()
                              .depositPoints(program['name'], program['points'].toString());
                          fetchTransferData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Points deposited successfully. Your reward points will be displayed within 24 hours.')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to deposit points: ${e.toString()}')),
                          );
                        } finally {
                          setState(() {
                            isTransferring = false;
                          });
                        }
                      },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: isTransferring
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Deposit',
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
