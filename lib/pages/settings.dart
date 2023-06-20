import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late bool isLoading,
      bioAuthSupport,
      useBioOrLocalAuth,
      detailedView,
      isReorderable;
  List<String>? tokens;
  String? email;
  late String dateFormat;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  DocumentReference? docRef;

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
    bioAuthSupport = await LocalAuthentication().isDeviceSupported();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthCredential? authCredential = await loginGoogle();
    if (authCredential != null) {
      user = await loginFirebase(authCredential);
      if (user != null) {
        docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
        if (docRef != null) {
          DocumentSnapshot doc = await docRef!.get();
          if (doc.exists) {
            Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
            if (docData.containsKey('preferences')) {
              useBioOrLocalAuth =
                  docData['preferences']['useBioOrLocalAuth'] ?? bioAuthSupport;
              detailedView = docData['preferences']['detailedView'] ?? false;
              isReorderable = docData['preferences']['isReorderable'] ?? false;
              dateFormat = docData['preferences']['dateFormat'] ?? 'dd/MM/yyyy';
            } else {
              getPrefs(prefs);
            }
          } else {
            getPrefs(prefs);
          }
        } else {
          getPrefs(prefs);
        }
      } else {
        getPrefs(prefs);
      }
    } else {
      getPrefs(prefs);
    }
    tokens = prefs.getStringList('tokens');
    if (tokens != null) {
      email = prefs.getString('email');
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getPrefs(SharedPreferences prefs) {
    useBioOrLocalAuth = prefs.getBool('useBioOrLocalAuth') ?? bioAuthSupport;
    detailedView = prefs.getBool('detailedView') ?? false;
    isReorderable = prefs.getBool('isReorderable') ?? false;
    dateFormat = prefs.getString('dateFormat') ?? 'dd/MM/yyyy';
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
                      value: useBioOrLocalAuth,
                      onChanged: (newValue) async {
                        await Functions.setOrUpdateFirestore(
                            docRef,
                            'preferences',
                            'preferences.useBioOrLocalAuth',
                            newValue!);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('useBioOrLocalAuth', newValue);
                        setState(() {
                          useBioOrLocalAuth = newValue;
                        });
                      },
                    ),
                  CheckboxListTile(
                    title: const Text('Detailed View'),
                    value: detailedView,
                    onChanged: (newValue) async {
                      await Functions.setOrUpdateFirestore(docRef,
                          'preferences', 'preferences.detailedView', newValue!);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('detailedView', newValue);
                      setState(() {
                        detailedView = newValue;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reorderable Vehicles'),
                    value: isReorderable,
                    onChanged: (newValue) async {
                      await Functions.setOrUpdateFirestore(
                          docRef,
                          'preferences',
                          'preferences.isReorderable',
                          newValue!);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isReorderable', newValue);
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
                          await Functions.setOrUpdateFirestore(
                              docRef,
                              'preferences',
                              'preferences.dateFormat',
                              newDateFormat!);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('dateFormat', newDateFormat);
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
                        if (docRef != null) {
                          await docRef!.delete();
                          user = null;
                        }
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
