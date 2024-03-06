import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/Models/astronomy.dart';
import 'package:weather/Models/weather_currentdata.dart';
import 'package:weather/constant.dart';
import 'package:http/http.dart' as http;

class WeatherDetailScreen extends StatefulWidget {
  final String name;

  const WeatherDetailScreen({super.key, required this.name});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  @override
  void initState() {
    super.initState();
    getWeather();
    getAstronomy();
  }

  List<CurrentWeather> currentWeather = [];
  CurrentWeather? currentWeatherdata;

  List<Astronomy> astronomy = [];
  Astronomy? astronomydata;
  Future<void> getAstronomy() async {
    final response = await http.get(Uri.parse(
        "${Const.baseUrl}astronomy.json?q=${widget.name}&dt=${DateFormat('yyyy-MM-dd').format(DateTime.now())})}&key=${Const.apiKey}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        astronomydata = Astronomy.fromJson(data);
      });
    }
  }

  Future<void> getWeather() async {
    final response = await http.get(Uri.parse(
        "${Const.baseUrl}current.json?q=${widget.name}&key=${Const.apiKey}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(
        () {
          currentWeatherdata = CurrentWeather.fromJson(data);
        },
      );
    }
  }

  Future<void> apiCall() async {
    await getWeather();
    await getAstronomy();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: RefreshIndicator(
          onRefresh: () => apiCall(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(widget.name, style: Const.headfontmedblc),
                      ),
                      Text(
                          currentWeatherdata == null
                              ? ''
                              : currentWeatherdata!.location!.country!,
                          style: Const.subheadfont),
                      Text(
                          currentWeatherdata == null
                              ? ''
                              : "${currentWeatherdata!.current!.tempC.toString()}°C",
                          style: GoogleFonts.lexend(
                              color: Colors.black, fontSize: 70)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: currentWeatherdata != null
                                          ? NetworkImage(
                                              "https:${currentWeatherdata!.current!.condition!.icon!}",
                                            )
                                          : const NetworkImage(
                                              "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg"),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    currentWeatherdata == null
                                        ? ''
                                        : currentWeatherdata!
                                            .current!.condition!.text!,
                                    style: Const.subheadfontblc)
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    currentWeatherdata == null
                                        ? ''
                                        : currentWeatherdata!
                                            .location!.localtime!,
                                    style: Const.subheadfontblc),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white24,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Wind Speed", style: Const.subheadfont),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.wind,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${currentWeatherdata == null ? '' : currentWeatherdata!.current!.windKph!} Km/h",
                                      style: Const.subheadfont,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white24,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Humidity", style: Const.subheadfont),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.droplet,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      currentWeatherdata == null
                                          ? ''
                                          : "${currentWeatherdata!.current!.humidity!.toString()} %",
                                      style: Const.subheadfont,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white24,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sunrise", style: Const.subheadfont),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sunny,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      astronomydata == null
                                          ? ''
                                          : astronomydata!
                                              .astronomy.astro.sunrise,
                                      style: Const.subheadfont,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white24,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sunset", style: Const.subheadfont),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sunny,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      astronomydata == null
                                          ? ''
                                          : astronomydata!
                                              .astronomy.astro.sunset,
                                      style: Const.subheadfont,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
