import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Instances {
  static LocalAuthentication localAuth = LocalAuthentication();
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user;
  static DocumentReference? docRef;
  static late SharedPreferences prefs;

  static Future<void> initialise() async {
    prefs = await SharedPreferences.getInstance();
  }
}
