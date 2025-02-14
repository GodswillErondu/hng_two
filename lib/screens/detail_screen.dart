import 'package:flutter/material.dart';
import 'package:hng_two/widgets/build_text.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final dynamic country;

  const DetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(country['name']['common'] ?? 'Country Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Border radius of 8
              child: Image.network(
                country['flags']['png'] ?? 'https://flagcdn.com/w320/ng.png',
                width: 380,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRichText('Name', country['name']['official'] ?? 'N/A'),
                const SizedBox(height: 4.0),
                if (country['subregion'] != null)
                  Column(
                    children: [
                      buildRichText('Province', country['subregion']),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                buildRichText(
                  'Population',
                  country['population'] != null
                      ? NumberFormat.decimalPattern()
                          .format(country['population'])
                      : 'N/A',
                ),
                const SizedBox(height: 24.0),
                buildRichText(
                  'Capital',
                  country['capital'] != null ? country['capital'][0] : 'N/A',
                ),
                const SizedBox(height: 4.0),
                if (country['president'] != null)
                  Column(
                    children: [
                      buildRichText('President', country['president']),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                if (country['president'] != null)
                  Column(
                    children: [
                      buildRichText('President', country['president']),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                buildRichText('Continent', country['region'] ?? 'N/A'),
                const SizedBox(height: 4.0),
                buildRichText('Country Code', country['cca3'] ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
