import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_permits_app/variables.dart';

import '../functions.dart';
import '../instances.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    if (mounted) {
      setState(() {
        Variables.isLoading = true;
      });
    }
    Variables.tokens = Instances.prefs.getStringList('tokens') ?? [];
    if (Variables.tokens.isNotEmpty) {
      Variables.parkingEmail = Instances.prefs.getString('email');
    }
    if (mounted) {
      setState(() {
        Variables.isLoading = false;
      });
    }
  }

  Future<AuthCredential?> loginGoogle({bool pressed = false}) async {
    GoogleSignInAccount? googleAccount;
    googleAccount = await Instances.googleSignIn.signInSilently();
    if (pressed && googleAccount == null) {
      googleAccount = await Instances.googleSignIn.signIn();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Variables.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Animate(
              effects: const [
                FadeEffect(),
              ],
              child: Column(
                children: [
                  if (Variables.bioOrLocalAuthIsSupported)
                    CheckboxListTile(
                      title: const Text('Local/Biometric Authentication'),
                      value: Variables.useBioOrLocalAuth,
                      onChanged: (newValue) async {
                        if (Instances.user != null) {
                          await Functions.setOrUpdateFirestore('preferences',
                              'preferences.useBioOrLocalAuth', newValue!);
                        }
                        Instances.prefs.setBool('useBioOrLocalAuth', newValue!);
                        setState(() {
                          Variables.useBioOrLocalAuth = newValue;
                        });
                      },
                    ),
                  CheckboxListTile(
                    title: const Text('Detailed View'),
                    value: Variables.useDetailedView,
                    onChanged: (newValue) async {
                      if (Instances.user != null) {
                        await Functions.setOrUpdateFirestore('preferences',
                            'preferences.detailedView', newValue!);
                      }
                      Instances.prefs.setBool('detailedView', newValue!);
                      setState(() {
                        Variables.useDetailedView = newValue;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reorderable Vehicles'),
                    value: Variables.isReorderable,
                    onChanged: (newValue) async {
                      if (Instances.user != null) {
                        await Functions.setOrUpdateFirestore('preferences',
                            'preferences.isReorderable', newValue!);
                      }
                      Instances.prefs.setBool('isReorderable', newValue!);
                      setState(() {
                        Variables.isReorderable = newValue;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField(
                      value: Variables.dateFormat,
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
                        if (newDateFormat != Variables.dateFormat) {
                          if (Instances.user != null) {
                            await Functions.setOrUpdateFirestore('preferences',
                                'preferences.dateFormat', newDateFormat!);
                          }
                          await Instances.prefs
                              .setString('dateFormat', newDateFormat!);
                          setState(() {
                            Variables.dateFormat = newDateFormat;
                          });
                        }
                      },
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Text(Variables.parkingEmail != null
                      ? 'Logged in as ${Variables.parkingEmail}'
                      : 'Not logged in to parking account'),
                  if (Instances.user != null)
                    Text('Signed in to Google as ${Instances.user!.email}'),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () async {
                      if (Instances.user == null) {
                        AuthCredential? authCredential =
                            await loginGoogle(pressed: true);
                        if (authCredential != null) {
                          try {
                            setState(() {
                              Variables.isLoading = true;
                            });
                            Instances.user = (await Instances.auth
                                    .signInWithCredential(authCredential))
                                .user;
                            Instances.docRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(Instances.user!.uid);
                            DocumentSnapshot doc =
                                await Instances.docRef!.get();
                            await Functions.syncFirestore(!doc.exists);
                            // ignore: empty_catches
                          } catch (e) {}
                          if (mounted) {
                            setState(() {
                              Variables.isLoading = false;
                            });
                          }
                        }
                      } else {
                        await Instances.googleSignIn.signOut();
                        await Instances.auth.signOut();
                        Instances.user = null;
                        Instances.docRef = null;
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                    child: Text(
                      Instances.user == null
                          ? 'Sign in with Google to unlock more features'
                          : 'Sign out of Google',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        Variables.isLoading = true;
                      });
                      if (Instances.docRef != null) {
                        await Instances.docRef!.delete();
                        await Instances.googleSignIn.signOut();
                        await Instances.auth.signOut();
                        Instances.user = null;
                      }
                      await Instances.prefs.clear();
                      var secureStorage = const FlutterSecureStorage();
                      await secureStorage.delete(key: 'password');
                      setState(() {
                        Variables.useDetailedView = false;
                        Variables.isReorderable = false;
                        Variables.tokens.clear();
                        Variables.parkingEmail = null;
                        Variables.isLoading = false;
                      });
                    },
                    child: const Text(
                      'Delete user data',
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
    );
  }
}
