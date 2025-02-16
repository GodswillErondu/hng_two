import 'dart:async';
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
  List<dynamic> _allCountries = [];
  List<dynamic> _filteredCountries = [];
  Map<String, List<dynamic>> _groupedCountries = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  String? _selectedLanguage;
  String? _selectedContinent;
  String? _selectedTimeZone;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCountries() async {
    final service = CountryService();
    try {
      final countries = await service.fetchCountries();
      setState(() {
        _allCountries = countries;
        _filteredCountries = List.from(_allCountries);
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _applyFilters() {
    List<dynamic> result = List.from(_allCountries);

    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      result = result.where((country) {
        final name = country['name']['common']?.toString().toLowerCase() ?? '';
        return name.contains(searchQuery);
      }).toList();
    }

    if (_selectedLanguage != null) {
      result = result.where((country) {
        final languages = country['languages'] ?? {};
        return languages.values.any((lang) =>
            lang.toString().toLowerCase() == _selectedLanguage!.toLowerCase());
      }).toList();
    }

    if (_selectedContinent != null) {
      result = result.where((country) {
        final region = country['region']?.toString() ?? '';
        final subregion = country['subregion']?.toString() ?? '';
        return region.toLowerCase() == _selectedContinent!.toLowerCase() ||
            subregion.toLowerCase() == _selectedContinent!.toLowerCase();
      }).toList();
    }

    if (_selectedTimeZone != null) {
      result = result.where((country) {
        final timezones = country['timezones'] as List<dynamic>? ?? [];
        return timezones
            .any((timezone) => timezone.toString() == _selectedTimeZone);
      }).toList();
    }

    setState(() {
      _filteredCountries = result;
      _sortAndGroupCountries();
    });
  }

  void _sortAndGroupCountries() {
    _filteredCountries.sort((a, b) {
      final nameA = a['name']['common']?.toString() ?? '';
      final nameB = b['name']['common']?.toString() ?? '';
      return nameA.compareTo(nameB);
    });

    _groupedCountries = {};
    for (var country in _filteredCountries) {
      final name = country['name']['common']?.toString() ?? '';
      if (name.isNotEmpty) {
        final firstLetter = name[0].toUpperCase();
        _groupedCountries.putIfAbsent(firstLetter, () => []).add(country);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedLanguage = null;
      _selectedContinent = null;
      _selectedTimeZone = null;
      _searchController.clear();
      _filteredCountries = List.from(_allCountries);
      _sortAndGroupCountries();
    });
  }

  Widget _buildFilterChips() {
    List<Widget> chips = [];

    if (_selectedLanguage != null) {
      chips.add(_buildFilterChip('Language: $_selectedLanguage'));
    }
    if (_selectedContinent != null) {
      chips.add(_buildFilterChip('Continent: $_selectedContinent'));
    }
    if (_selectedTimeZone != null) {
      chips.add(_buildFilterChip('Timezone: $_selectedTimeZone'));
    }

    return chips.isEmpty
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                ...chips,
                ActionChip(
                  label: Text('Clear All'),
                  onPressed: _clearFilters,
                ),
              ],
            ),
          );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label),
      onDeleted: () {
        if (label.startsWith('Language')) {
          setState(() => _selectedLanguage = null);
        } else if (label.startsWith('Continent')) {
          setState(() => _selectedContinent = null);
        } else if (label.startsWith('Timezone')) {
          setState(() => _selectedTimeZone = null);
        }
        _applyFilters();
      },
    );
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
          ? const Center(child: CircularProgressIndicator())
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
                    onChanged: _onSearchChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLanguageFilterButton(context),
                      _buildFilterButton(context),
                    ],
                  ),
                ),
                _buildFilterChips(),
                Expanded(
                  child: _filteredCountries.isEmpty
                      ? Center(
                          child:
                              Text('No countries match the selected filters'),
                        )
                      : _buildCountryList(),
                ),
              ],
            ),
    );
  }

  Widget _buildLanguageFilterButton(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: () => languageFilterBottomSheet(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: themeProvider.borderColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.language,
                  size: 24,
                ),
                const SizedBox(width: 8.0),
                Text(
                  _selectedLanguage ?? 'EN',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: () => continentZoneBottomSheet(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: themeProvider.borderColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryList() {
    return ListView.builder(
      itemCount: _groupedCountries.length,
      itemBuilder: (context, index) {
        final key = _groupedCountries.keys.elementAt(index);
        final countries = _groupedCountries[key]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                key,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...countries.map((country) {
              return ListTile(
                leading: SizedBox(
                  width: 40,
                  height: 40,
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
                  country['capital'] != null ? country['capital'][0] : 'N/A',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(country: country),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  void languageFilterBottomSheet(BuildContext context) {
    final List<String> languages = [
      'Bahasa',
      'Deutsh',
      'English',
      'Espanol',
      'Francaise',
      'Italiano',
      'Portugues',
      'Pycckuu',
      'Japanese',
      'Chinese',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 450,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Languages',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: languages.map((language) {
                      return ListTile(
                        title: Text(
                          language,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: _selectedLanguage == language
                            ? Icon(Icons.radio_button_checked,
                                color: Colors.blue)
                            : Icon(Icons.radio_button_off_outlined),
                        onTap: () {
                          setState(() {
                            _selectedLanguage = language;
                          });
                          _applyFilters();
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void continentZoneBottomSheet(BuildContext context) {
    final List<String> continents = [
      'Africa',
      'Asia',
      'Europe',
      'North America',
      'South America',
      'Australia',
      'Antarctica',
    ];

    final List<String> timeZones = [
      'UTC-12:00',
      'UTC-11:00',
      'UTC-10:00',
      'UTC-09:00',
      'UTC-08:00',
      'UTC-07:00',
      'UTC-06:00',
      'UTC-05:00',
      'UTC-04:00',
      'UTC-03:00',
      'UTC-02:00',
      'UTC-01:00',
      'UTC±00:00',
      'UTC+01:00',
      'UTC+02:00',
      'UTC+03:00',
      'UTC+04:00',
      'UTC+05:00',
      'UTC+06:00',
      'UTC+07:00',
      'UTC+08:00',
      'UTC+09:00',
      'UTC+10:00',
      'UTC+11:00',
      'UTC+12:00',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 450,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Continent',
                            style: Theme.of(context).textTheme.bodyMedium),
                        trailing:
                            const Icon(Icons.keyboard_arrow_down_outlined),
                        onTap: () {
                          _showContinentPicker(context, continents);
                        },
                      ),
                      ListTile(
                        title: Text('Time Zone',
                            style: Theme.of(context).textTheme.bodyMedium),
                        trailing:
                            const Icon(Icons.keyboard_arrow_down_outlined),
                        onTap: () {
                          _showTimeZonePicker(context, timeZones);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedContinent = null;
                              _selectedTimeZone = null;
                            });
                            _applyFilters();
                            Navigator.pop(context);
                          },
                          style: Theme.of(context).elevatedButtonTheme.style,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                                fontFamily: 'Axiforma',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            _applyFilters();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFCC5907),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                    color: Color(0xFFFFFFFF),
                                  ))),
                          child: const Text(
                            'Show results',
                            style: TextStyle(
                                fontFamily: 'Axiforma',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContinentPicker(BuildContext context, List<String> continents) {
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
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Select Continent',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: continents.length,
                    itemBuilder: (context, index) {
                      final continent = continents[index];
                      return ListTile(
                        title: Text(continent),
                        trailing: _selectedContinent == continent
                            ? Icon(Icons.radio_button_checked,
                                color: Colors.blue)
                            : Icon(Icons.radio_button_off_outlined),
                        onTap: () {
                          setState(() {
                            _selectedContinent = continent;
                          });
                          _applyFilters();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimeZonePicker(BuildContext context, List<String> timeZones) {
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
            height: 250,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Select Time Zone',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: timeZones.length,
                    itemBuilder: (context, index) {
                      final timeZone = timeZones[index];
                      return ListTile(
                        title: Text(timeZone),
                        trailing: _selectedTimeZone == timeZone
                            ? Icon(
                                Icons.radio_button_checked,
                              )
                            : Icon(Icons.radio_button_off_outlined),
                        onTap: () {
                          setState(() {
                            _selectedTimeZone = timeZone;
                          });
                          _applyFilters();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
