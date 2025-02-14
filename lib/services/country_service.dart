import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  final String _baseUrl = "https://restcountries.com/v3.1/all";

  Future<List<dynamic>> fetchCountries() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
