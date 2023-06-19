import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late bool isLoading, bioAuthSupport, useBioAuth, detailedView, isReorderable;
  List<String>? tokens;
  String? email;
  late String dateFormat;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bioAuthSupport = await LocalAuthentication().isDeviceSupported();
    useBioAuth = prefs.getBool('useBioAuth') ?? bioAuthSupport;
    detailedView = prefs.getBool('detailedView') ?? false;
    isReorderable = prefs.getBool('isReorderable') ?? false;
    dateFormat = prefs.getString('dateFormat') ?? 'dd/MM/yyyy';
    tokens = prefs.getStringList('tokens');
    if (tokens != null) {
      email = prefs.getString('email');
    }
    AuthCredential? authCredential = await loginGoogle();
    if (authCredential != null) {
      user = await loginFirebase(authCredential);
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<AuthCredential?> loginGoogle({bool pressed = false}) async {
    GoogleSignInAccount? googleAccount;
    googleAccount = await googleSignIn.signInSilently();
    if (pressed && googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }
    if (googleAccount == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return authCredential;
  }

  Future<User?> loginFirebase(AuthCredential authCredential) async {
    final User? user = auth.currentUser ??
        (await auth.signInWithCredential(authCredential)).user;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Animate(
              effects: const [
                FadeEffect(),
              ],
              child: Column(
                children: [
                  if (bioAuthSupport)
                    CheckboxListTile(
                      title: const Text('Local/Biometric Authentication'),
                      value: useBioAuth,
                      onChanged: (newValue) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('useBioAuth', newValue!);
                        setState(() {
                          useBioAuth = newValue;
                        });
                      },
                    ),
                  CheckboxListTile(
                    title: const Text('Detailed View'),
                    value: detailedView,
                    onChanged: (newValue) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('detailedView', newValue!);
                      setState(() {
                        detailedView = newValue;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reorderable Vehicles'),
                    value: isReorderable,
                    onChanged: (newValue) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isReorderable', newValue!);
                      setState(() {
                        isReorderable = newValue;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField(
                      value: dateFormat,
                      decoration:
                          const InputDecoration(labelText: 'Date Format'),
                      items: ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy/MM/dd']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newDateFormat) async {
                        if (newDateFormat != dateFormat) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('dateFormat', newDateFormat!);
                          setState(() {
                            dateFormat = newDateFormat;
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        var secureStorage = const FlutterSecureStorage();
                        await secureStorage.delete(key: 'password');
                        setState(() {
                          detailedView = false;
                          isReorderable = false;
                          tokens = null;
                          email = null;
                        });
                      },
                      child: const Text(
                        'Delete user data',
                      ),
                    ),
                  ),
                  Text(email ?? 'Not logged in'),
                  if (user == null)
                    ElevatedButton(
                      onPressed: () async {
                        AuthCredential? authCredential =
                            await loginGoogle(pressed: true);
                        if (authCredential != null) {
                          user = await loginFirebase(authCredential);
                          setState(() {});
                        }
                      },
                      child: const Text(
                        'Sign in with Google to get more features',
                      ),
                    ),
                  if (user != null) Text(user!.uid)
                ],
              ),
            ),
    );
  }
}
