import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_permits_app/variables.dart';

import '../constants.dart';
import '../functions.dart';
import '../instances.dart';
import 'base.dart';
import 'login.dart';

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

  bool isSynced = false;
  bool displaySyncStatus = false;

  void getData() async {
    if (mounted) {
      setState(() {
        Variables.isLoading = true;
      });
    }
    if (Instances.user != null) await Functions.updateStatics();
    Variables.tokens = Instances.prefs.getStringList('tokens') ?? [];
    if (Variables.tokens.isNotEmpty) {
      Variables.parkingEmail = Instances.prefs.getString('parkingEmail');
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
      googleAccount =
          await Instances.googleSignIn.signIn().catchError((onError) => null);
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

  Future<bool?> openDeleteUserDataDialog() => showDialog<bool>(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
                'Doing so will delete all your local and cloud data.'),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No'),
                    ),
                  ),
                ],
              )
            ],
          )));

  Future<bool?> openDataDialog() => showDialog<bool>(
      context: context,
      builder: ((context) => AlertDialog(
              title: const Text('User data conflict!'),
              content: const Text(
                  "Pressing 'DOWNLOAD' will overwrite your local data with the cloud data. Pressing 'UPLOAD' will overwrite the cloud data with your local data."),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('DOWNLOAD'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('UPLOAD'),
                      ),
                    ),
                  ],
                )
              ])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                        Instances.prefs.setBool(
                            'preferences.useBioOrLocalAuth', newValue!);
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
                            'preferences.useDetailedView', newValue!);
                      }
                      Instances.prefs
                          .setBool('preferences.useDetailedView', newValue!);
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
                      Instances.prefs
                          .setBool('preferences.isReorderable', newValue!);
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
                          await Instances.prefs.setString(
                              'preferences.dateFormat', newDateFormat!);
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
                  if (displaySyncStatus)
                    isSynced
                        ? const Text('Synced!',
                            style: TextStyle(color: Colours.green))
                        : const Text('Sync failed!',
                            style: TextStyle(color: Colours.red)),
                  Text(Variables.parkingEmail != null
                      ? 'Logged in as ${Variables.parkingEmail}'
                      : 'Not logged in to permit account'),
                  if (Instances.user != null)
                    Text('Signed in to Google as ${Instances.user!.email}'),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {});
                      if (Variables.tokens.isEmpty) {
                        Variables.isLoading = true;
                        bool success = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const Base(page: Login()))) ??
                            false;
                        if (success && mounted) {
                          setState(() {
                            Variables.isLoading1 = true;
                          });
                          getData();
                        } else {
                          setState(() {
                            Variables.isLoading = false;
                          });
                        }
                      } else {
                        Variables.tokens.clear();
                        Variables.parkingEmail = null;
                        await Instances.prefs.remove('tokens');
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                    child: Text(Variables.tokens.isEmpty
                        ? 'Login to Permit Account'
                        : 'Logout of Permit Account'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool isNewUser = false;
                      if (Instances.user == null) {
                        AuthCredential? authCredential =
                            await loginGoogle(pressed: true);
                        if (authCredential != null) {
                          try {
                            setState(() {
                              Variables.isLoading = true;
                            });
                            await Instances.auth
                                .signInWithCredential(authCredential)
                                .then((UserCredential userCredential) {
                              Instances.user = userCredential.user;
                              isNewUser =
                                  userCredential.additionalUserInfo!.isNewUser;
                            });
                            Instances.docRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(Instances.user!.uid);
                            DocumentSnapshot doc =
                                await Instances.docRef!.get();
                            Map<String, dynamic>? docData =
                                doc.data() as Map<String, dynamic>?;
                            Set<String> prefsKeys = Instances.prefs.getKeys();
                            prefsKeys.remove('tokens');
                            prefsKeys.remove('parkingEmail');
                            Map<String, dynamic> prefsFormatted = {};
                            for (String key in prefsKeys) {
                              if (key.contains('vehicles.')) {
                                prefsFormatted.putIfAbsent(
                                    'vehicles', () => {});
                                prefsFormatted['vehicles']
                                    [key.split('.')[1]] = {};
                                prefsFormatted['vehicles'][key.split('.')[1]]
                                    ['note'] = Instances.prefs.get(key);
                              } else if (key.contains('preferences.')) {
                                prefsFormatted.putIfAbsent(
                                    'preferences', () => {});
                                prefsFormatted['preferences']
                                        [key.split('.')[1]] =
                                    Instances.prefs.get(key);
                              } else if (key.contains('permits.')) {
                                prefsFormatted.putIfAbsent('permits', () => {});
                                prefsFormatted['permits']
                                    .putIfAbsent(key.split('.')[1], () => {});
                                prefsFormatted['permits'][key.split('.')[1]]
                                        [key.split('.')[2]] =
                                    Instances.prefs.get(key);
                              }
                            }
                            if (isNewUser || doc.data() == null) {
                              isSynced = await Functions.syncFirestore(
                                  true, prefsFormatted);
                              Variables.isLoading = false;
                            } else if (const DeepCollectionEquality()
                                .equals(prefsFormatted, docData)) {
                              isSynced = true;
                            } else {
                              bool? overwriteFirestore = await openDataDialog();
                              if (overwriteFirestore != null) {
                                isSynced = await Functions.syncFirestore(
                                    overwriteFirestore, prefsFormatted);
                              }
                            }
                            if (isSynced) {
                              await Functions.updateStatics();
                            } else {
                              await Functions.googleFirebaseSignOut();
                            }
                            if (mounted) {
                              setState(() {
                                displaySyncStatus = true;
                                Variables.isLoading = false;
                              });
                            }
                          } catch (e) {
                            await Functions.googleFirebaseSignOut();
                            if (mounted) {
                              setState(() {
                                Variables.isLoading = false;
                              });
                            }
                          }
                        }
                      } else {
                        await Functions.googleFirebaseSignOut();
                        if (mounted) {
                          setState(() {
                            Variables.isLoading = false;
                          });
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
                      bool? delete = await openDeleteUserDataDialog();
                      if (delete != null && delete) {
                        if (Instances.docRef != null) {
                          await Instances.docRef!.delete();
                          await Functions.googleFirebaseSignOut();
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
                      } else {
                        setState(() {
                          Variables.isLoading = false;
                        });
                      }
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
