import 'package:flutter/cupertino.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return InkWell(
                            onTap: () => languageFilterBottomSheet(context),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider.borderColor,
                                  // Dynamic border color
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.language,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    _filteredCountries.isNotEmpty
                                        ? _filteredCountries[0]['languages']
                                            ['eng']
                                        : 'EN',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return InkWell(
                            onTap: () => continentZoneBottomSheet(context),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider.borderColor,
                                  // Dynamic border color
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.filter_alt_outlined,
                                    size: 24.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Filter',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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

void languageFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 750,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Languages',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      InkWell(
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.0,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bahasa',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deutsh',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Espanol',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Francaise',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Italiano',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Portugues',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pycckuu',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void continentZoneBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      InkWell(
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.0,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continent',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time Zone',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 18.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
