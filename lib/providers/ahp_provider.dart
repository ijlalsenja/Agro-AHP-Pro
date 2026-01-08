import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AhpProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Case Study: Pabrik Pengolahan Kakao
  final List<String> criteria = [
    "Kehalusan Partikel",
    "Waktu Conching",
    "Risiko Kontaminasi Logam"
  ];

  final List<String> alternatives = [
    "Mesin Grinding",
    "Mesin Conching",
    "Mesin Packaging",
    "Boiler",
    "Conveyor"
  ];

  // Matriks Perbandingan
  // Format: key = "indexA-indexB", value = score (1-9)
  // Untuk kriteria: key prefix "criteria" e.g., "criteria-0-1" -> Kriteria 0 vs Kriteria 1
  // Untuk alternatif: key prefix "alt-{criteriaIndex}" e.g., "alt-0-0-1" -> Alt 0 vs Alt 1 pada Kriteria 0
  Map<String, double> comparisons = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _results;
  Map<String, dynamic>? get results => _results;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void updateComparison(String key, double value) {
    comparisons[key] = value;
    notifyListeners();
  }

  double getComparisonValue(String key) {
    return comparisons[key] ?? 1.0;
  }

  // Buat Matrix utuh untuk dikirim ke API
  Map<String, dynamic> _buildPayload() {
    List<List<double>> criteriaMatrix = _buildMatrix(criteria.length, "criteria");
    
    Map<String, List<List<double>>> altMatrices = {};
    for (int i = 0; i < criteria.length; i++) {
      altMatrices[criteria[i]] = _buildMatrix(alternatives.length, "alt-$i");
    }

    return {
      "criteria_matrix": criteriaMatrix,
      "alternatives_matrices": altMatrices
    };
  }

  List<List<double>> _buildMatrix(int size, String keyPrefix) {
    List<List<double>> matrix = List.generate(size, (_) => List.filled(size, 1.0));
    for (int i = 0; i < size; i++) {
      for (int j = i + 1; j < size; j++) {
        String key = "$keyPrefix-$i-$j";
        double val = comparisons[key] ?? 1.0;
        
        // AHP Rule: A vs B = x, then B vs A = 1/x
        // Namun, jika val user < 1 (contoh 1/3), kita simpan sebagai value
        // Tapi slider biasanya 1-9.
        // Konvensi: Jika slider positif ke kanan (A lebih penting dari B), val = x.
        // Jika slider ke kiri (B lebih penting dari A), val = 1/x.
        // Kita simpan nilai mentah di provider, logic konversi di sini.
        
        // Asumsi input dari UI sudah berupa nilai float 1/9 sampai 9
        // Atau UI mengirim 1-9 dan arah?
        // Mari kita buat simpel: UI menyimpan nilai 1 sd 9 dan "dominan".
        // Tapi untuk simplifikasi kodok, kita asumsi UI sudah handle "invert".
        // Misal UI slider -9 sampai 9.
        
        matrix[i][j] = val;
        matrix[j][i] = 1.0 / val;
      }
    }
    return matrix;
  }

  Future<bool> submitData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final payload = _buildPayload();
      _results = await _apiService.submitMatrix(payload);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }
  
  void reset() {
    comparisons.clear();
    _results = null;
    _errorMessage = null;
    notifyListeners();
  }
}
