import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hng_two/models/country.dart';
import 'package:http/http.dart' as http;

class CountryProvider extends ChangeNotifier {
  List<Country> _countries = [];
  bool _isLoading = false;
  final String apiKey = '2140|PKumevQiQjqcR8JZDGXLK4RAkvBzeIiI5WRZmUgb';

  List<Country> get countries => _countries;

  bool get isLoading => _isLoading;

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();

    const String apiUrl = 'https://restfulcountries.com/api/v1/countries';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $apiKey'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          _countries = (responseData['data'] as List)
              .map((json) => Country.fromJson(json))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (error) {
      debugPrint('Error fetching countries: $error');
    }

    _isLoading = false;
    notifyListeners();
  }
}
