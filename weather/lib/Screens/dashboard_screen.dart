// ignore_for_file: deprecated_member_use, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/Models/astronomy.dart';
import 'package:weather/Models/weather_currentdata.dart';
import 'package:weather/Screens/login_screen.dart';
import 'package:weather/Screens/weather_detail_screen.dart';
import 'package:weather/constant.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String ser = "";

  @override
  void initState() {
    super.initState();
    // getCity();
    clearData();
    getWeather();
    getAstronomy();
  }

  List<String> cities = [];
  Future<void> getCity(String search) async {
    final response = await http.get(
        Uri.parse("${Const.baseUrl}search.json?q=$search&key=${Const.apiKey}"));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        cities = data.map((e) => e['name'].toString()).toList();
        print(cities);
      });
    }
  }

  List<CurrentWeather> currentWeather = [];
  CurrentWeather? currentWeatherdata;

  List<Astronomy> astronomy = [];
  Astronomy? astronomydata;
  List localtime = [];
  List weatherCondition = [];
  List weathericon = [];
  List weatherDeg = [];
  String localtimeStr = "";
  String weatherConditionStr = "";
  String weathericonStr = "";
  String weatherDegStr = "";

  Future<void> getAstronomy() async {
    for (int i = 0; i < Const.city.length; i++) {
      final response = await http.get(Uri.parse(
          "${Const.baseUrl}astronomy.json?q=${Const.city[i]}&dt=${DateFormat('yyyy-MM-dd').format(DateTime.now())})}&key=${Const.apiKey}"));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          astronomydata = Astronomy.fromJson(data);
        });
      }
    }
    // final response = await http.get(Uri.parse(
    //     "${Const.baseUrl}astronomy.json?q=${"New York"}&dt=${DateFormat('yyyy-MM-dd').format(DateTime.now())})}&key=${Const.apiKey}"));
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> data = json.decode(response.body);
    //   setState(() {
    //     astronomydata = Astronomy.fromJson(data);
    //   });
    // }
  }

  final User = FirebaseAuth.instance.currentUser!;

  Future<void> getWeather() async {
    for (int i = 0; i < Const.city.length; i++) {
      final response = await http.get(Uri.parse(
          "${Const.baseUrl}current.json?q=${Const.city[i]}&key=${Const.apiKey}"));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          currentWeatherdata = CurrentWeather.fromJson(data);
          weatherCondition.add(currentWeatherdata!.current!.condition!.text);
          weathericon.add(currentWeatherdata!.current!.condition!.icon);
          weatherDeg.add(currentWeatherdata!.current!.tempC);
          localtime.add(currentWeatherdata!.location!.localtime);
        });
      }
    }
    final response = await http.get(Uri.parse(
        "${Const.baseUrl}current.json?q=${"Nagpur"}&key=${Const.apiKey}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(
        () {
          currentWeatherdata = CurrentWeather.fromJson(data);
          weatherConditionStr = currentWeatherdata!.current!.condition!.text!;
          weathericonStr = currentWeatherdata!.current!.condition!.icon!;
          weatherDegStr = currentWeatherdata!.current!.tempC.toString();
          localtimeStr = currentWeatherdata!.location!.localtime!;
        },
      );
    }
  }

  Future<void> apiCall() async {
    await getWeather();
    await getAstronomy();
  }

  void clearData() {
    setState(() {
      localtime = [];
      weatherCondition = [];
      weathericon = [];
      weatherDeg = [];

      localtimeStr = "";
      weatherConditionStr = "";
      weathericonStr = "";
      weatherDegStr = "";
    });
  }

  Future<void> clearUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userUid');
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await clearUserUid();
    // Add any additional logout logic you may have
  }

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "City List",
                        style: Const.headfont,
                      ),
                      Text(
                        "Weather Details",
                        style: Const.subheadfont,
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Get.snackbar(
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                          "Name: ${User.displayName.toString()}",
                          "Email: ${User.email.toString()}",
                        );
                        // showModalBottomSheet(
                        //   isDismissible: false,
                        //   context: context,
                        //   builder: (context) {
                        //     return Container(
                        //       // height: 200,

                        //       width: double.infinity,
                        //       child: Column(
                        //         children: [
                        //           Text(
                        //             "Name: ${User.displayName.toString()}",
                        //             style: Const.headfontmedblc,
                        //           ),
                        //           Text(
                        //             "Name: ${User.email.toString()}",
                        //             style: Const.subheadfontblc,
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                  IconButton(
                    onPressed: () {
                      print("hy");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    child: const Text(
                                      "Logout",
                                    ),
                                  )
                                ]);
                          });
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: TypeAheadField(
                noItemsFoundBuilder: (context) => SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "No Item Found!",
                      style: Const.subheadfontblc,
                    ),
                  ),
                ),
                animationStart: 1,
                // hideKeyboard: true,
                loadingBuilder: (context) => SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please wait a moment...",
                      style: Const.subheadfontblc,
                    ),
                  ),
                ),
                // hideKeyboardOnDrag: true,
                hideSuggestionsOnKeyboardHide: false,

                textFieldConfiguration: TextFieldConfiguration(
                    style: Const.subheadfont,
                    controller: searchController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(
                          FontAwesomeIcons.search,
                          color: Colors.black54,
                          size: 20,
                        ),
                        hintText: "Search",
                        hintStyle: Const.subheadfont,
                        // fillColor: Colors.white,
                        filled: true)),
                suggestionsCallback: (value) async {
                  ser = value;
                  if (ser.length < 3) {
                    ser = "";
                    cities.clear();
                  }
                  if (ser.length >= 3) {
                    await getCity(ser);
                  }

                  return cities;
                },
                itemBuilder: (context, suggestion) {
                  return Card(
                      // color: Colors.white,
                      child: ListTile(
                          title: Text(
                    suggestion,
                  )));
                },
                onSuggestionSelected: (suggestion) {
                  // Handle when a suggestion is selected.
                  searchController.text = suggestion;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WeatherDetailScreen(
                      name: suggestion,
                    ),
                  ));
                },
                // onChanged: (value) {
                //   if (value.isNotEmpty) {
                //     ser = value;
                //     getCity(ser);
                //   }
                // },
                // controller: searchController,
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  hasScrollbar: false,
                  scrollbarThumbAlwaysVisible: false,
                  scrollbarTrackAlwaysVisible: false,
                  elevation: 8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Your City",
                style: Const.headfontmed,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WeatherDetailScreen(
                            name: "Nagpur",
                          )));
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  weathericonStr.isEmpty
                                      ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3nhYdA7jH5DSbsbH_Xqbhwy4PnDp466zkjHp5B3fDMQ&s'
                                      : "https:$weathericonStr",
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nagpur",
                                      style: Const.headfontmedblc,
                                    ),
                                    Text(
                                        localtimeStr.isEmpty
                                            ? ''
                                            : localtimeStr,
                                        style: Const.subheadfont),
                                  ],
                                )
                              ],
                            ),
                            Text(
                                weatherConditionStr.isEmpty
                                    ? ''
                                    : weatherConditionStr,
                                style: Const.subheadfontblc)
                          ],
                        ),
                        Text(weatherDegStr.isEmpty ? '' : "$weatherDegStr°C",
                            style: Const.headfontmedblc),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Text(
                "Your Favourite City",
                style: Const.headfontmed,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => apiCall(),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => WeatherDetailScreen(
                                    name: Const.city[index],
                                  )));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          weathericon.length < 5
                                              ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3nhYdA7jH5DSbsbH_Xqbhwy4PnDp466zkjHp5B3fDMQ&s '
                                              : "https:${weathericon[index]}",
                                          height: 50,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Const.city[index],
                                              style: Const.headfontmedwhi,
                                            ),
                                            Text(
                                                localtime.length < 5
                                                    ? ""
                                                    : localtime[index],
                                                style: Const.subheadfontmidwhi),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      weatherCondition.length < 5
                                          ? ''
                                          : weatherCondition[index],
                                      style: Const.subheadfontwhi,
                                    ),
                                  ],
                                ),
                                Text(
                                    weatherDeg.length < 5
                                        ? ''
                                        : "${weatherDeg[index].toString()}°C",
                                    style: Const.headfontmedwhi),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: Const.city.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
