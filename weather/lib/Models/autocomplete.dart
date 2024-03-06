// To parse this JSON data, do
//
//     final autoComplete = autoCompleteFromJson(jsonString);

import 'dart:convert';

List<AutoComplete> autoCompleteFromJson(String str) => List<AutoComplete>.from(
    json.decode(str).map((x) => AutoComplete.fromJson(x)));

String autoCompleteToJson(List<AutoComplete> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AutoComplete {
  int id;
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String url;

  AutoComplete({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory AutoComplete.fromJson(Map<String, dynamic> json) => AutoComplete(
        id: json["id"],
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
        "url": url,
      };
}
