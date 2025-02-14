import 'package:flutter/material.dart';
import 'package:hng_two/providers/theme_provider.dart';
import 'package:hng_two/screens/detail_screen.dart';
import 'package:hng_two/services/country_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _countries = [];
  List<dynamic> _filteredCountries = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final service = CountryService();
    try {
      final countries = await service.fetchCountries();
      setState(() {
        _countries = countries;
        _filteredCountries = countries;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries
          .where((country) => country['name']['common']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Image.asset(
              themeProvider.isDarkMode
                  ? 'assets/images/title_dark_mode.png'
                  : 'assets/images/title_light_mode.png',
              height: 32,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                );
              },
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Country',
                      hintStyle: TextStyle(
                          fontFamily: 'Axiforma',
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18.0,
                      ),
                    ),
                    onChanged: _filterCountries,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 40, // Set the width of the leading widget
                          height: 40, // Set the height of the leading widget
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              country['flags']['png'] ??
                                  'https://flagcdn.com/w320/ng.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          country['name']['common'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          country['capital'] != null
                              ? country['capital'][0]
                              : 'N/A',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(country: country),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
