import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // --- KONFIGURASI ---
  // Default URL ke placeholder. Jika gagal, akan masuk Mock Mode.
  static const String _gistUrl = 'https://gist.githubusercontent.com/ijlalsenja/aa0cfefcc4f2222c2788f835b74a6357/raw/config.json'; 
  
  String? _baseUrl;
  bool _isMockMode = false;

  bool get isMockMode => _isMockMode;

  Future<String> getBaseUrl() async {
    if (_isMockMode) return "MOCK_MODE";
    if (_baseUrl != null) return _baseUrl!;
    
    try {
      final response = await http.get(Uri.parse(_gistUrl)).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _baseUrl = data['base_url'];
        if (_baseUrl!.endsWith('/')) {
          _baseUrl = _baseUrl!.substring(0, _baseUrl!.length - 1);
        }
        print("Connected to Backend: $_baseUrl");
        return _baseUrl!;
      } else {
         throw Exception('Status ${response.statusCode}');
      }
    } catch (e) {
      print("Gagal connect ke Gist ($e). Masuk ke Mock Mode.");
      _isMockMode = true;
      return "MOCK_MODE";
    }
  }

  Future<Map<String, dynamic>> submitMatrix(Map<String, dynamic> payload) async {
    final baseUrl = await getBaseUrl();
    
    if (_isMockMode) {
      // --- MOCK RESPONSE FOR DEMO ---
      await Future.delayed(const Duration(seconds: 2)); // Simulate network flutter
      return {
        "status": "success",
        "criteria_weights": [0.6, 0.3, 0.1],
        "criteria_cr": 0.05,
        "ranking": [
          {"name": "Boiler", "score": 0.45, "rank": 1},
          {"name": "Mesin Packaging", "score": 0.25, "rank": 2},
          {"name": "Mesin Conching", "score": 0.15, "rank": 3},
          {"name": "Conveyor", "score": 0.10, "rank": 4},
          {"name": "Mesin Grinding", "score": 0.05, "rank": 5}
        ]
      };
    }
    
    final url = Uri.parse('$baseUrl/api/submit-matrix');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Unknown error from server');
      }
    } catch (e) {
      // If we are here, backend might be down. Fallback to mock?
      // No, for explicit connection error lets show error, but maybe advice user.
      throw Exception('Gagal menghubungi Server ($baseUrl). Pastikan server Python jalan. Error: $e');
    }
  }
}
