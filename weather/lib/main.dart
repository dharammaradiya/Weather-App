import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/Screens/dashboard_screen.dart';
import 'package:weather/Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCQ74HBe4TZ264zl4nPIGrY1H-Xcs7C8Ew",
    appId: "1:322252362655:android:36c1cf71838ab0453e63aa",
    messagingSenderId: "322252362655",
    projectId: "weatherapp-a3ec0",
  ));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userUid = prefs.getString('userUid');

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: userUid == null ? const LoginScreen() : const DashboardScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const LoginScreen(),
    );
  }
}
