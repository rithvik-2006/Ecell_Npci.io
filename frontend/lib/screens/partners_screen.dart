import 'package:flutter/material.dart';
import 'package:frontend/models/company.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/bottom_navigation.dart';
import 'package:frontend/widgets/glassmorphic_card.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  List<Company> partners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPartners();
  }

  Future<void> fetchPartners() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<Company> companies = await ApiService().fetchCompanies();
      setState(() {
        partners = companies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load partners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Our Partners',
              style: TextStyle(
                fontSize: 42,
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
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
      bottomNavigationBar: const BottomNavigation(initialIndex: 3),
    );
  }

  Widget _buildPartnerCard(BuildContext context, Company partner) {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(
            //   partner.image_path,
            //   width: 80,
            //   height: 80,
            // ),
            const SizedBox(height: 16),
            Text(
              partner.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              partner.company_type,
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
