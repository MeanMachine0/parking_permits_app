import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_permits_app/models/mini_permit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      Instances.docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(Instances.user!.uid);
      DocumentSnapshot doc = await Instances.docRef!.get();
      if (doc.exists) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        if (docData.containsKey('preferences')) {
          if (docData['preferences']['useBioOrLocalAuth'] != null) {
            Variables.useBioOrLocalAuth = docData['preferences']
                    ['useBioOrLocalAuth'] &&
                Variables.bioOrLocalAuthIsSupported;
          }
          if (docData['preferences']['useDetailedView'] != null) {
            Variables.useDetailedView = docData['preferences']['detailedView'];
          }
          if (docData['preferences']['isReorderable'] != null) {
            Variables.isReorderable = docData['preferences']['isReorderable'];
          }
          if (docData['preferences']['dateFormat'] != null) {
            Variables.dateFormat = docData['preferences']['dateFormat'];
          }
        }
      }
      Variables.notSilentlySigningIn = true;
    } catch (e) {
      Variables.notSilentlySigningIn = true;
      return;
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

  static Future<bool> syncFirestore(bool overwrite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late List permitData;
    List<MiniPermitModel> miniPermits = [];
    List<Vehicle> vehicles = [];
    List<Map<String, List<String>>> orderedVehicleIds = [];
    DocumentSnapshot? doc;
    List<String> vehicleIds = [];
    try {
      if (overwrite) {
        Duration buffer = const Duration(minutes: 30, seconds: 10);
        DateTime expiry = Variables.tokens.isNotEmpty
            ? DateTime.parse(Variables.tokens.last)
            : DateTime.now();
        permitData = Variables.tokens.isEmpty ||
                DateTime.now().add(buffer).toUtc().isAfter(expiry)
            ? []
            : await Api().getMiniPermits(false, false);
        if (permitData.isEmpty && Variables.tokens.isNotEmpty) {
          return false;
        } else if (permitData.isNotEmpty && permitData[0] == false) {
          return false;
        } else if (permitData.isNotEmpty) {
          miniPermits = permitData as List<MiniPermitModel>;
          for (MiniPermitModel miniPermit in miniPermits) {
            await Api()
                .getPermit(miniPermit.id.toString(), false)
                .then((permit) {
              if (permit != null) {
                vehicles.addAll(permit.vehicles);
                List<String>? permitOrderedVehicleIds;
                permitOrderedVehicleIds =
                    prefs.getStringList(permit.id.toString());
                if (permitOrderedVehicleIds != null) {
                  Map<String, List<String>> idMap = {
                    'permitIdToOrderedVehicleIds.${permit.id.toString()}':
                        permitOrderedVehicleIds
                  };
                  orderedVehicleIds.add(idMap);
                }
              }
            });
          }
        }
        await Instances.docRef!.set({'preferences': {}});
        Instances.docRef!.update({
          'preferences.useBioOrLocalAuth': prefs.getBool('useBioOrLocalAuth') ??
              Variables.bioOrLocalAuthIsSupported
        });
        Instances.docRef!.update({
          'preferences.detailedView': prefs.getBool('detailedView') ?? false
        });
        Instances.docRef!.update({
          'preferences.isReorderable': prefs.getBool('isReorderable') ?? false
        });
        Instances.docRef!.update({
          'preferences.dateFormat':
              prefs.getString('dateFormat') ?? 'dd/MM/yyyy'
        });
        if (orderedVehicleIds.isNotEmpty) {
          for (Map<String, List<String>> idMap in orderedVehicleIds) {
            await Instances.docRef!.update(idMap);
          }
        }
        for (Vehicle vehicle in vehicles) {
          if (vehicle.isFavourite) {
            await Instances.docRef!
                .update({'vehicles.${vehicle.id}.isFavourite': true});
          }
          if (vehicle.note != null && vehicle.note != '') {
            await Instances.docRef!
                .update({'vehicles.${vehicle.id}.note': vehicle.note});
          }
        }
      } else {
        doc = await Instances.docRef!.get();
        if (doc.exists) {
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
          if (docData.containsKey('preferences')) {
            await prefs.setBool(
                'useBioOrLocalAuth',
                docData['preferences']['useBioOrLocalAuth'] ??
                    Variables.bioOrLocalAuthIsSupported);
            await prefs.setBool('detailedView',
                docData['preferences']['detailedView'] ?? false);
            await prefs.setBool('isReorderable',
                docData['preferences']['isReorderable'] ?? false);
            await prefs.setString('dateFormat',
                docData['preferences']['dateFormat'] ?? 'dd/MM/yyyy');
          }
          if (docData.containsKey('permitIdToOrderedVehicleIds')) {
            Map<String, dynamic> idMap =
                docData['permitIdToOrderedVehicleIds'] as Map<String, dynamic>;
            List<String> permitIds = idMap.keys.toList();
            for (String permitId in permitIds) {
              vehicleIds = (idMap[permitId] as List)
                  .map((vehicleId) => vehicleId.toString())
                  .toList();
              await prefs.setStringList(permitId, vehicleIds);
            }
          }
          if (docData.containsKey('vehicles')) {
            Map<String, dynamic> vehicleMap = docData['vehicles'];
            vehicleIds = vehicleMap.keys.toList();
            for (String vehicleId in vehicleIds) {
              String? note = vehicleMap[vehicleId]['note']?.toString();
              if (note != null) {
                await prefs.setString('${vehicleId}Note', note);
              }
              bool? isFavourite =
                  vehicleMap[vehicleId]?['isFavourite'] as bool?;
              if (isFavourite != null && isFavourite) {
                await prefs.setBool('${vehicleId}IsFavourite', true);
              }
            }
          }
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
