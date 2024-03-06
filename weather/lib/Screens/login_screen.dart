// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/Screens/dashboard_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    print("Hello");
    if (userCredential != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ));
    }
  }

  UserCredential? userCredential;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        return null; // User canceled the sign-in process
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user credentials to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userUid', userCredential.user?.uid ?? '');

      return userCredential;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 70, right: 70, bottom: 20),
              child: Image.asset(
                "assets/images/cloud.png",
                height: 250,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Favourite",
                    style:
                        GoogleFonts.lexend(color: Colors.white, fontSize: 40),
                    // style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "Weather",
                    style:
                        GoogleFonts.lexend(color: Colors.white, fontSize: 40),

                    // style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "Compainion",
                    style:
                        GoogleFonts.lexend(color: Colors.white, fontSize: 40),

                    // style: TextStyle(color: Colors.white, fontSize: 40),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
                  onPressed: () async {
                    UserCredential? userCredential = await signInWithGoogle();
                    if (userCredential != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()));
                      print(
                          "Successfully signed in with Google: ${userCredential.user?.displayName}");
                    } else {
                      print("Google Sign-In failed.");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Started",
                          style: GoogleFonts.lexend(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.black,
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
