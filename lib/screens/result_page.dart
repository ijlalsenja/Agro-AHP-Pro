import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/ahp_provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AhpProvider>(context);
    final results = provider.results;

    if (results == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hasil Analisis")),
        body: const Center(child: Text("Belum ada data hasil.")),
      );
    }

    final List<dynamic> ranking = results['ranking'] ?? [];
    final double cr = results['criteria_cr'] ?? 0.0;
    bool consistent = cr < 0.1;

    return Scaffold(
      appBar: AppBar(title: const Text("REKOMENDASI KEPUTUSAN"), backgroundColor: Colors.green.shade800),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Result
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const Text("Mesin Prioritas Utama", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    ranking.isNotEmpty ? ranking.first['name'] : "-",
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: consistent ? Colors.greenAccent.shade400 : Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(consistent ? Icons.check_circle : Icons.warning_amber_rounded, color: Colors.black, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          consistent ? "DATA KONSISTEN (CR ${(cr).toStringAsFixed(3)})" : "TIDAK KONSISTEN (CR ${(cr).toStringAsFixed(3)})",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Chart Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: ranking.isNotEmpty ? (ranking.first['score'] as double) * 1.15 : 1.0,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            tooltipPadding: const EdgeInsets.all(8),
                            tooltipMargin: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${ranking[groupIndex]['name']}\n',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: (rod.toY).toStringAsFixed(3),
                                    style: const TextStyle(color: Colors.yellowAccent, fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() >= 0 && value.toInt() < ranking.length) {
                                  // Initial only
                                  String name = ranking[value.toInt()]['name'];
                                  String initial = name.split(" ").map((e) => e[0]).join("");
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(initial, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        barGroups: ranking.asMap().entries.map((entry) {
                          bool isTop = entry.key == 0;
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: (entry.value['score'] as num).toDouble(),
                                gradient: isTop 
                                  ? const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                  : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                width: 24,
                                borderRadius: BorderRadius.circular(6),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            // Details List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const Align(alignment: Alignment.centerLeft, child: Text("DETAIL PERINGKAT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ranking.length,
              itemBuilder: (context, index) {
                final item = ranking[index];
                bool isWinner = index == 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isWinner ? 4 : 1,
                  shadowColor: isWinner ? Colors.green.withOpacity(0.4) : Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isWinner ? const BorderSide(color: Colors.green, width: 2) : BorderSide.none,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40, height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isWinner ? Colors.green : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "#${item['rank']}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isWinner ? Colors.white : Colors.black54),
                      ),
                    ),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Bobot Priority: ${(item['score'] as double).toStringAsFixed(4)}"),
                    trailing: isWinner ? const Icon(Icons.star, color: Colors.orange) : null,
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade800,
                  side: BorderSide(color: Colors.green.shade800),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("KEMBALI KE MENU"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
