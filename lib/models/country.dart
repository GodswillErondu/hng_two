class Country {
  final String name;
  final String? state; // Assuming state is optional
  final String flag;
  final int population;
  final String capital;
  final String? president; // Assuming president is optional
  final String continent;
  final String code;

  Country({
    required this.name,
    this.state,
    required this.flag,
    required this.population,
    required this.capital,
    this.president,
    required this.continent,
    required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] ?? '',
      state: json['state'],
      flag: json['flag'] ?? '',
      population: json['population'] ?? 0,
      capital: json['capital'] ?? '',
      president: json['president'] ?? '',
      continent: json['continent'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
