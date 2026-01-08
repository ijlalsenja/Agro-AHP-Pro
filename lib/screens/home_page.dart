import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ahp_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AhpProvider>(context);

    // Background gradient
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B5E20), // Dark green
            Color(0xFF2E7D32), // Green
            Color(0xFFF1F8E9), // Light green surface
          ],
          stops: [0.0, 0.4, 0.8],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important for background to show
        appBar: AppBar(
          title: const Text("AGRO-AHP PRO"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildModernHeader(),
              const SizedBox(height: 30),
              _buildSectionHeader("KRITERIA ANALISIS"),
              _buildModernList(provider.criteria, Icons.analytics_outlined),
              const SizedBox(height: 20),
              _buildSectionHeader("ALTERNATIF MESIN"),
              _buildModernList(provider.alternatives, Icons.precision_manufacturing_outlined),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  provider.reset();
                  Navigator.pushNamed(context, '/comparison');
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 28),
                label: const Text(
                  "MULAI ANALISIS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDD835), // Yellow contrast accent
                  foregroundColor: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Card(
      elevation: 10,
      shadowColor: Colors.black45,
      color: Colors.white.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.eco, size: 60, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              "Pabrik Pengolahan Kakao",
              style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            const Text(
              "Decision Support System",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Metode AHP • Skala Saaty • Ranking Real-time",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildModernList(List<String> items, IconData icon) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.green.shade700, size: 20),
            ),
            title: Text(
              items[index],
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            trailing: Text(
              "0${index + 1}",
              style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}
