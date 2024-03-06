// To parse this JSON data, do
//
//     final astronomy = astronomyFromJson(jsonString);

import 'dart:convert';

Astronomy astronomyFromJson(String str) => Astronomy.fromJson(json.decode(str));

String astronomyToJson(Astronomy data) => json.encode(data.toJson());

class Astronomy {
  Location location;
  AstronomyClass astronomy;

  Astronomy({
    required this.location,
    required this.astronomy,
  });

  factory Astronomy.fromJson(Map<String, dynamic> json) => Astronomy(
        location: Location.fromJson(json["location"]),
        astronomy: AstronomyClass.fromJson(json["astronomy"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "astronomy": astronomy.toJson(),
      };
}

class AstronomyClass {
  Astro astro;

  AstronomyClass({
    required this.astro,
  });

  factory AstronomyClass.fromJson(Map<String, dynamic> json) => AstronomyClass(
        astro: Astro.fromJson(json["astro"]),
      );

  Map<String, dynamic> toJson() => {
        "astro": astro.toJson(),
      };
}

class Astro {
  String sunrise;
  String sunset;
  String moonrise;
  String moonset;
  String moonPhase;
  int moonIllumination;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
  });

  factory Astro.fromJson(Map<String, dynamic> json) => Astro(
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        moonrise: json["moonrise"],
        moonset: json["moonset"],
        moonPhase: json["moon_phase"],
        moonIllumination: json["moon_illumination"],
      );

  Map<String, dynamic> toJson() => {
        "sunrise": sunrise,
        "sunset": sunset,
        "moonrise": moonrise,
        "moonset": moonset,
        "moon_phase": moonPhase,
        "moon_illumination": moonIllumination,
      };
}

class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  int localtimeEpoch;
  String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        tzId: json["tz_id"],
        localtimeEpoch: json["localtime_epoch"],
        localtime: json["localtime"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
        "tz_id": tzId,
        "localtime_epoch": localtimeEpoch,
        "localtime": localtime,
      };
}
