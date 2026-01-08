import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ahp_provider.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AhpProvider>(context, listen: false);
    _tabController = TabController(length: 1 + provider.criteria.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AhpProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text("Input Perbandingan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.green.shade900.withOpacity(0.8), // Tabs darker bg
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.yellowAccent,
              indicatorWeight: 4,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: [
                const Tab(text: "Antar Kriteria"),
                ...provider.criteria.map((c) => Tab(text: c)),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFE8F5E9)],
            stops: [0.0, 0.3],
          )
        ),
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildComparisonList(
                context,
                items: provider.criteria,
                keyPrefix: "criteria",
                title: "Prioritas Kriteria Utama",
                subtitle: "Mana yang lebih penting untuk tujuan maintenance?",
              ),
              ...provider.criteria.asMap().entries.map((entry) {
                return _buildComparisonList(
                  context,
                  items: provider.alternatives,
                  keyPrefix: "alt-${entry.key}",
                  title: "Evaluasi Alternatif",
                  subtitle: "Bandingkan mesin berdasarkan '${entry.value}'",
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(provider),
    );
  }

  Widget _buildBottomBar(AhpProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (_tabController.index > 0) {
                  _tabController.animateTo(_tabController.index - 1);
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text("KEMBALI"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                } else {
                  // Submit logic
                  _showLoadingDialog(context);
                  bool success = await provider.submitData();
                  Navigator.pop(context); // Close loading
                  
                  if (success && context.mounted) {
                    Navigator.pushNamed(context, '/result');
                  } else if (context.mounted) {
                    _showErrorDialog(context, provider.errorMessage);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: Text(_tabController.index == _tabController.length - 1 ? "HITUNG AHP" : "LANJUT SESI"),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  void _showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Koneksi Error"),
        content: Text(message ?? "Terjadi kesalahan. Coba nyalakan Mock Mode jika backend belum siap."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
        ],
      ),
    );
  }

  Widget _buildComparisonList(BuildContext context, {required List<String> items, required String keyPrefix, required String title, required String subtitle}) {
    List<Widget> cards = [];
    
    cards.add(Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    ));

    for (int i = 0; i < items.length; i++) {
      for (int j = i + 1; j < items.length; j++) {
        cards.add(_buildSliderCard(context, items[i], items[j], "$keyPrefix-$i-$j"));
      }
    }
    
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: cards,
    );
  }

  Widget _buildSliderCard(BuildContext context, String itemA, String itemB, String key) {
    final provider = Provider.of<AhpProvider>(context, listen: false); 
    double rawVal = provider.getComparisonValue(key);
    double sliderVal = 0;
    
    if (rawVal >= 1) {
      if (rawVal == 1) sliderVal = 0;
      else sliderVal = -(rawVal - 1);
    } else {
      double x = 1 / rawVal;
      sliderVal = x - 1;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(itemA, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Text("VS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                Expanded(child: Text(itemB, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("A Leading", style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                    Text("B Leading", style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 16,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                  ),
                  child: Slider(
                    value: sliderVal,
                    min: -8,
                    max: 8,
                    divisions: 16,
                    label: _getLabel(sliderVal),
                    activeColor: Colors.green.shade600,
                    inactiveColor: Colors.green.shade100,
                    onChanged: (val) {
                      double finalVal = 1.0;
                      if (val == 0) finalVal = 1.0;
                      else if (val < 0) finalVal = 1 + val.abs();
                      else finalVal = 1.0 / (1 + val);
                      
                      provider.updateComparison(key, finalVal);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getDescription(sliderVal),
                  style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel(double sliderVal) {
    if (sliderVal == 0) return "1";
    int val = (sliderVal.abs() + 1).round();
    return "$val";
  }

  String _getDescription(double sliderVal) {
    if (sliderVal == 0) return "Sama Penting (1)";
    int val = (sliderVal.abs() + 1).round();
    String side = sliderVal < 0 ? "Kiri (A)" : "Kanan (B)";
    return "$side Lebih Penting: Nilai $val";
  }
}
