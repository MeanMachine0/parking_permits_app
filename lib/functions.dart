import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'instances.dart';
import 'variables.dart';

class Functions {
  static Future<void> silentSignIn() async {
    try {
      Variables.notSilentlySigningIn = false;
      GoogleSignInAccount? googleAccount;
      googleAccount = await Instances.googleSignIn.signInSilently();
      if (googleAccount == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      Instances.user =
          (await Instances.auth.signInWithCredential(authCredential)).user;
      await updateStatics();
      Variables.notSilentlySigningIn = true;
    } catch (e) {
      Variables.notSilentlySigningIn = true;
      return;
    }
  }

  static Future<void> googleFirebaseSignOut() async {
    await Instances.googleSignIn.signOut();
    await Instances.auth.signOut();
    Instances.user = null;
    Instances.docRef = null;
  }

  static Future<void> updateStatics() async {
    Instances.docRef =
        FirebaseFirestore.instance.collection('users').doc(Instances.user!.uid);
    DocumentSnapshot doc = await Instances.docRef!.get();
    if (doc.exists) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      if (docData.containsKey('preferences')) {
        if (docData['preferences']['useBioOrLocalAuth'] != null) {
          Variables.useBioOrLocalAuth = docData['preferences']
                  ['useBioOrLocalAuth'] &&
              Variables.bioOrLocalAuthIsSupported;
          await Instances.prefs.setBool(
              'preferences.useBioOrLocalAuth', Variables.useBioOrLocalAuth);
          if (docData['preferences']['useBioOrLocalAuth'] &&
              !Variables.bioOrLocalAuthIsSupported) {
            Instances.docRef!.update({'preferences.useBioOrLocalAuth': false});
          }
        }
        if (docData['preferences']['useDetailedView'] != null) {
          Variables.useDetailedView = docData['preferences']['useDetailedView'];
          await Instances.prefs.setBool(
              'preferences.useDetailedView', Variables.useDetailedView);
        }
        if (docData['preferences']['isReorderable'] != null) {
          Variables.isReorderable = docData['preferences']['isReorderable'];
          await Instances.prefs
              .setBool('preferences.isReorderable', Variables.isReorderable);
        }
        if (docData['preferences']['dateFormat'] != null) {
          Variables.dateFormat = docData['preferences']['dateFormat'];
          await Instances.prefs
              .setString('preferences.dateFormat', Variables.dateFormat);
        }
      }
    }
  }

  static Future<void> setOrUpdateFirestore(
      String dictRoot, String path, var value) async {
    if (Instances.docRef != null) {
      DocumentSnapshot doc = await Instances.docRef!.get();
      if (doc.exists) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        if (!docData.containsKey(dictRoot)) {
          await Instances.docRef!.update({dictRoot: {}});
        }
      } else {
        await Instances.docRef!.set({dictRoot: {}});
      }
      await Instances.docRef!.update({path: value});
    }
  }

  static Future<bool> syncFirestore(
      bool overwriteFirestore, Map<String, dynamic> prefsFormatted) async {
    late DocumentSnapshot doc;
    Variables.isSyncing = true;
    Set<String> prefsKeys = Instances.prefs.getKeys();
    Map<String, dynamic> prefsBackup = {};
    for (String key in prefsKeys) {
      prefsBackup[key] = Instances.prefs.get(key);
    }
    try {
      doc = await Instances.docRef!.get();
      if (overwriteFirestore) {
        await Instances.prefs.clear();
        await Instances.prefs.setStringList('tokens', prefsBackup['tokens']);
        await Instances.prefs
            .setString('parkingEmail', prefsBackup['parkingEmail']);
        await Instances.docRef!.set({'permits': {}});
        Map? permits = prefsFormatted['permits'];
        if (permits != null) {
          permits.forEach((id, data) async {
            data.forEach((key, value) async {
              await Instances.docRef!.update({'permits.$id.$key': value});
            });
          });
        }
        Map? vehicles = prefsFormatted['vehicles'];
        if (vehicles != null) {
          vehicles.forEach((vrm, data) async {
            data.forEach((key, value) async {
              await Instances.docRef!.update({'vehicles.$vrm.$key': value});
            });
          });
        }
        Map? preferences = prefsFormatted['preferences'];
        if (preferences != null) {
          preferences.forEach((key, value) async {
            await Instances.docRef!.update({'preferences.$key': value});
          });
        }
      } else {
        List<String>? permitOrderedVehicleVrms, favourites;
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        if (docData.containsKey('permits')) {
          Map<String, dynamic> idMap =
              docData['permits'] as Map<String, dynamic>;
          List<String> permitIds = idMap.keys.toList();
          for (String permitId in permitIds) {
            if (idMap[permitId].containsKey('orderedVehicleVrms')) {
              permitOrderedVehicleVrms =
                  (idMap[permitId]['orderedVehicleVrms'] as List)
                      .map((vehicleId) => vehicleId.toString())
                      .toList();
              await Instances.prefs.setStringList(
                  'permits.$permitId.orderedVehicleVrms',
                  permitOrderedVehicleVrms);
            }
            if (idMap[permitId]['favourites'] != null) {
              favourites = (idMap[permitId]['favourites'] as List)
                  .map((vrm) => vrm as String)
                  .toList();
            }
            if (favourites != null) {
              await Instances.prefs
                  .setStringList('permits.$permitId.favourites', favourites);
            }
          }
        }
        if (docData.containsKey('vehicles')) {
          Map<String, dynamic> vehicleMap = docData['vehicles'];
          List<String> vehicleVrms = vehicleMap.keys.toList();
          for (String vrm in vehicleVrms) {
            String? note = vehicleMap[vrm]['note']?.toString();
            if (note != null) {
              await Instances.prefs.setString('vehicles.$vrm.note', note);
            }
          }
        }
      }
    } catch (e) {
      for (String key in prefsKeys) {
        Type valueType = prefsBackup[key].runtimeType;
        switch (valueType) {
          case String:
            await Instances.prefs.setString(key, prefsBackup[key]);
            break;

          case List<String>:
            await Instances.prefs.setStringList(key, prefsBackup[key]);
            break;

          case bool:
            await Instances.prefs.setBool(key, prefsBackup[key]);
            break;
        }
      }
      Variables.isSyncing = false;
      return false;
    }
    for (String key in prefsKeys) {
      Type valueType = prefsBackup[key].runtimeType;
      switch (valueType) {
        case String:
          await Instances.prefs.setString(key, prefsBackup[key]);
          break;

        case List<String>:
          await Instances.prefs.setStringList(key, prefsBackup[key]);
          break;

        case bool:
          await Instances.prefs.setBool(key, prefsBackup[key]);
          break;
      }
    }
    Variables.isSyncing = false;
    return true;
  }
}
