import 'package:flutter/material.dart';
import 'package:hng_two/widgets/build_text.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailScreen extends StatelessWidget {
  final dynamic country;

  const DetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    final double lat = country['latlng'][0];
    final double lng = country['latlng'][1];

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
            CarouselSlider(
              items: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    country['flags']['png'] ??
                        'https://flagcdn.com/w320/ng.png',
                    width: 380,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                // Coat of Arms
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    country['coatOfArms']['png'] ??
                        'https://via.placeholder.com/150',
                    width: 380,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                // Interactive Map
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(lat, lng),
                      zoom: 5.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(lat, lng),
                            builder: (ctx) => const Icon(Icons.location_on,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
