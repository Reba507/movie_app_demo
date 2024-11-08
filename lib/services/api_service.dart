import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> fetchItems(String query) async {
    final response = await http.get(Uri.parse('$baseUrl?search=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // Adjust based on API structure
    } else {
      throw Exception('Failed to load data');
    }
  }
}
