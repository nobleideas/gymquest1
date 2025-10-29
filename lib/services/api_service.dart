import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {


  static const String baseUrl = "http://127.0.0.1:5000"; 
  // ⚠️ For real device testing: use your computer’s local IP (e.g. 192.168.x.x)

  // --- USER REGISTRATION ---
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );
    return jsonDecode(response.body);
  }

  // --- USER LOGIN ---
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    return jsonDecode(response.body);
  }

  // --- GET EQUIPMENT + EXERCISES BY QR CODE ---
  static Future<Map<String, dynamic>?> getEquipmentByQR(String qrCode) async {
    final response = await http.get(Uri.parse("$baseUrl/equipment/$qrCode"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // --- LOG A WORKOUT SESSION ---
  static Future<Map<String, dynamic>> logSession({
    required int userId,
    required int exerciseId,
    double? weight,
    int? reps,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/sessions"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "exercise_id": exerciseId,
        "weight": weight,
        "reps": reps,
        "notes": notes,
      }),
    );
    return jsonDecode(response.body);
  }

  // --- GET USER SESSIONS ---
  static Future<List<dynamic>> getUserSessions(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/sessions/$userId"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["sessions"];
    }
    return [];
  }

  // --- GET USER STATS (Calculated On-The-Fly) ---
  static Future<List<dynamic>> getUserStats(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/stats/$userId"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["stats"];
    }
    return [];
  }
}
