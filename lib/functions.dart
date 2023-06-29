import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_permits_app/models/mini_permit_model.dart';

import 'api.dart';
import 'instances.dart';
import 'models/permit_model.dart';
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
          await Instances.prefs
              .setBool('useBioOrLocalAuth', Variables.useBioOrLocalAuth);
        }
        if (docData['preferences']['useDetailedView'] != null) {
          Variables.useDetailedView = docData['preferences']['useDetailedView'];
          await Instances.prefs
              .setBool('useDetailedView', Variables.useDetailedView);
        }
        if (docData['preferences']['isReorderable'] != null) {
          Variables.isReorderable = docData['preferences']['isReorderable'];
          await Instances.prefs
              .setBool('isReorderable', Variables.isReorderable);
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

  static Future<bool> syncFirestore(bool overwriteFirestore) async {
    late List permitData;
    List<MiniPermitModel> miniPermits = [];
    List<Vehicle> vehicles = [];
    List<Map<String, List<String>>> orderedVehicleVrms = [];
    late DocumentSnapshot doc;
    List<String> vehicleVrms = [];
    List<String>? permitOrderedVehicleVrms, favourites;
    Variables.isSyncing = true;
    Set<String> prefsKeys = Instances.prefs.getKeys();
    Map<String, dynamic> prefsBackup = {};
    for (String key in prefsKeys) {
      prefsBackup[key] = Instances.prefs.get(key);
    }
    try {
      doc = await Instances.docRef!.get();
      if (overwriteFirestore) {
        Duration buffer = const Duration(minutes: 30, seconds: 10);
        DateTime expiry = Variables.tokens.isNotEmpty
            ? DateTime.parse(Variables.tokens.last)
            : DateTime.now();
        permitData = Variables.tokens.isEmpty ||
                DateTime.now().add(buffer).toUtc().isAfter(expiry)
            ? []
            : await Api().getMiniPermits(false, false);
        if (permitData.isEmpty && Variables.tokens.isNotEmpty) {
          Variables.isSyncing = false;
          return false;
        } else if (permitData.isNotEmpty && permitData[0] == false) {
          Variables.isSyncing = false;
          return false;
        } else {
          await Instances.prefs.clear();
          await Instances.prefs.setStringList('tokens', prefsBackup['tokens']);
          await Instances.prefs
              .setString('parkingEmail', prefsBackup['parkingEmail']);
          if (permitData.isNotEmpty) {
            miniPermits = permitData as List<MiniPermitModel>;
            await Instances.docRef!.set({'permits': {}});
            favourites = [];
            for (MiniPermitModel miniPermit in miniPermits) {
              await Api()
                  .getPermit(miniPermit.id.toString(), false)
                  .then((permit) async {
                if (permit != null) {
                  List<Vehicle> permitVehicles = permit.vehicles;
                  vehicles.addAll(permitVehicles);
                  for (Vehicle vehicle in permitVehicles) {
                    if (vehicle.isFavourite) {
                      favourites!.add(vehicle.vrm);
                    }
                  }
                  await Instances.docRef!
                      .update({'permits.${permit.id}.favourites': favourites});
                  favourites!.clear();
                  permitOrderedVehicleVrms = Instances.prefs
                      .getStringList('permits.${permit.id}.orderedVehicleVrms');
                  if (permitOrderedVehicleVrms != null) {
                    Map<String, List<String>> idMap = {
                      'permits.${permit.id}.orderedVehicleVrms':
                          permitOrderedVehicleVrms!
                    };
                    orderedVehicleVrms.add(idMap);
                  }
                }
              });
            }
          }
        }
        Instances.docRef!.update({
          'preferences.useBioOrLocalAuth':
              Instances.prefs.getBool('preferences.useBioOrLocalAuth') ??
                  Variables.bioOrLocalAuthIsSupported
        });
        Instances.docRef!.update({
          'preferences.useDetailedView':
              Instances.prefs.getBool('preferences.useDetailedView') ?? false
        });
        Instances.docRef!.update({
          'preferences.isReorderable':
              Instances.prefs.getBool('preferences.isReorderable') ?? false
        });
        Instances.docRef!.update({
          'preferences.dateFormat':
              Instances.prefs.getString('preferences.dateFormat') ??
                  'dd/MM/yyyy'
        });
        if (orderedVehicleVrms.isNotEmpty) {
          for (Map<String, List<String>> idMap in orderedVehicleVrms) {
            await Instances.docRef!.update(idMap);
          }
        }
        for (Vehicle vehicle in vehicles) {
          if (vehicle.note != null && vehicle.note != '') {
            await Instances.docRef!
                .update({'vehicles.${vehicle.vrm}.note': vehicle.note});
          }
        }
      } else {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        if (docData.containsKey('preferences')) {
          await Instances.prefs.setBool(
              'preferences.useBioOrLocalAuth',
              docData['preferences']['useBioOrLocalAuth'] ??
                  Variables.bioOrLocalAuthIsSupported);
          await Instances.prefs.setBool('preferences.useDetailedView',
              docData['preferences']['useDetailedView'] ?? false);
          await Instances.prefs.setBool('preferences.isReorderable',
              docData['preferences']['isReorderable'] ?? false);
          await Instances.prefs.setString('preferences.dateFormat',
              docData['preferences']['dateFormat'] ?? 'dd/MM/yyyy');
        }
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
            favourites = idMap[permitId][favourites];
            if (favourites != null) {
              await Instances.prefs
                  .setStringList('permits.$permitId.favourites', favourites);
            }
          }
        }
        if (docData.containsKey('vehicles')) {
          Map<String, dynamic> vehicleMap = docData['vehicles'];
          vehicleVrms = vehicleMap.keys.toList();
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
    Variables.isSyncing = false;
    return true;
  }
}
