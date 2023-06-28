import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../instances.dart';

PermitModel permitModelFromJson(String str) =>
    PermitModel.fromJson(json.decode(str));

String permitModelToJson(PermitModel data) => json.encode(data.toJson());

class PermitModel {
  String type;
  int id;
  String permitNumber;
  DateTime startDate;
  DateTime expiryDate;
  bool isCancelled;
  bool isExpired;
  bool isSuspended;
  List<Vehicle> vehicles;
  PermitModelAddress? address;

  PermitModel({
    required this.type,
    required this.id,
    required this.permitNumber,
    required this.startDate,
    required this.expiryDate,
    required this.isCancelled,
    required this.isExpired,
    required this.isSuspended,
    required this.vehicles,
    this.address,
  });

  factory PermitModel.fromJson(Map<String, dynamic> json) => PermitModel(
        type: json["\u0024type"],
        id: json["id"],
        permitNumber: json["permitNumber"],
        startDate: DateTime.parse(json["startDate"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
        isCancelled: json["isCancelled"],
        isExpired: json["isExpired"],
        isSuspended: json["isSuspended"],
        vehicles: List<Vehicle>.from(
            json["vehicles"].map((x) => Vehicle.fromJson(x))),
        address: PermitModelAddress.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "startDate": startDate.toIso8601String(),
        "expiryDate": expiryDate.toIso8601String(),
        "isCancelled": isCancelled,
        "isExpired": isExpired,
        "isSuspended": isSuspended,
        "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
      };
}

class PafAddress {
  String? type;
  int? id;
  String? udprn;
  String? subBuildingName;
  String? buildingName;
  String? buildingNumber;
  String? departmentName;
  String? organisationName;
  String? poBoxNumber;
  String? dependentThoroughfareName;
  dynamic dependentThoroughfareDescriptor;
  String? thoroughfareName;
  dynamic thoroughfareDescriptor;
  String? doubleDependentLocality;
  String? dependentLocality;
  String? postTown;
  dynamic county;
  String? postcode;
  String? uprn;
  String? usrn;
  String? origin;
  bool? isActive;
  dynamic notes;
  dynamic lpi;
  dynamic blpuClass;
  dynamic businessOrResidentPermitsAllowed;

  PafAddress({
    this.type,
    this.id,
    this.udprn,
    this.subBuildingName,
    this.buildingName,
    this.buildingNumber,
    this.departmentName,
    this.organisationName,
    this.poBoxNumber,
    this.dependentThoroughfareName,
    this.dependentThoroughfareDescriptor,
    this.thoroughfareName,
    this.thoroughfareDescriptor,
    this.doubleDependentLocality,
    this.dependentLocality,
    this.postTown,
    this.county,
    this.postcode,
    this.uprn,
    this.usrn,
    this.origin,
    this.isActive,
    this.notes,
    this.lpi,
    this.blpuClass,
    this.businessOrResidentPermitsAllowed,
  });

  factory PafAddress.fromJson(Map<String, dynamic> json) => PafAddress(
        type: json["\u0024type"],
        id: json["id"],
        udprn: json["udprn"],
        subBuildingName: json["subBuildingName"],
        buildingName: json["buildingName"],
        buildingNumber: json["buildingNumber"],
        departmentName: json["departmentName"],
        organisationName: json["organisationName"],
        poBoxNumber: json["poBoxNumber"],
        dependentThoroughfareName: json["dependentThoroughfareName"],
        dependentThoroughfareDescriptor:
            json["dependentThoroughfareDescriptor"],
        thoroughfareName: json["thoroughfareName"],
        thoroughfareDescriptor: json["thoroughfareDescriptor"],
        doubleDependentLocality: json["doubleDependentLocality"],
        dependentLocality: json["dependentLocality"],
        postTown: json["postTown"],
        county: json["county"],
        postcode: json["postcode"],
        uprn: json["uprn"],
        usrn: json["usrn"],
        origin: json["origin"],
        isActive: json["isActive"],
        notes: json["notes"],
        lpi: json["lpi"],
        blpuClass: json["blpuClass"],
        businessOrResidentPermitsAllowed:
            json["businessOrResidentPermitsAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "udprn": udprn,
        "subBuildingName": subBuildingName,
        "buildingName": buildingName,
        "buildingNumber": buildingNumber,
        "departmentName": departmentName,
        "organisationName": organisationName,
        "poBoxNumber": poBoxNumber,
        "dependentThoroughfareName": dependentThoroughfareName,
        "dependentThoroughfareDescriptor": dependentThoroughfareDescriptor,
        "thoroughfareName": thoroughfareName,
        "thoroughfareDescriptor": thoroughfareDescriptor,
        "doubleDependentLocality": doubleDependentLocality,
        "dependentLocality": dependentLocality,
        "postTown": postTown,
        "county": county,
        "postcode": postcode,
        "uprn": uprn,
        "usrn": usrn,
        "origin": origin,
        "isActive": isActive,
        "notes": notes,
        "lpi": lpi,
        "blpuClass": blpuClass,
        "businessOrResidentPermitsAllowed": businessOrResidentPermitsAllowed,
      };
}

class PermitModelAddress {
  String? type;
  String? subAddress;
  String? name;
  String? number;
  String? street;
  int? streetId;
  String? addressLine;
  String? town;
  String? county;
  String? postcode;
  int? addressBaseId;
  PafAddress? pafAddress;

  PermitModelAddress({
    this.type,
    this.subAddress,
    this.name,
    this.number,
    this.street,
    this.streetId,
    this.addressLine,
    this.town,
    this.county,
    this.postcode,
    this.addressBaseId,
    this.pafAddress,
  });

  factory PermitModelAddress.fromJson(Map<String, dynamic> json) =>
      PermitModelAddress(
        type: json["\u0024type"],
        subAddress: json["subAddress"],
        name: json["name"],
        number: json["number"],
        street: json["street"],
        streetId: json["streetId"],
        addressLine: json["addressLine"],
        town: json["town"],
        county: json["county"],
        postcode: json["postcode"],
        addressBaseId: json["addressBaseId"],
        pafAddress: PafAddress.fromJson(json["pafAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "subAddress": subAddress,
        "name": name,
        "number": number,
        "street": street,
        "streetId": streetId,
        "addressLine": addressLine,
        "town": town,
        "county": county,
        "postcode": postcode,
        "addressBaseId": addressBaseId,
        "pafAddress": pafAddress!.toJson(),
      };
}

class Vehicle {
  String? note;
  bool isFavourite = false;
  int? index;
  String? message;
  String type;
  int id;
  String vrm;
  bool isActive;

  Vehicle({
    this.note,
    required this.isFavourite,
    this.index,
    this.message,
    required this.type,
    required this.id,
    required this.vrm,
    required this.isActive,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        isFavourite: false,
        type: json["\u0024type"],
        id: json["id"],
        vrm: json["vrm"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "vrm": vrm,
        "isActive": isActive,
      };

  static void sortByIsFavourite(List<Vehicle> vehicles) {
    vehicles.sort((a, b) {
      if (a.isFavourite == b.isFavourite) {
        return a.vrm.compareTo(b.vrm);
      } else if (a.isFavourite) {
        return -1;
      } else {
        return 1;
      }
    });
  }

  static Future<void> sortByCustom(
      List<Vehicle> vehicles, String permitId, DocumentSnapshot? doc) async {
    late List orderedVehicleVrms;
    Map<String, dynamic>? docData;
    if (doc != null && doc.exists) {
      docData = doc.data() as Map<String, dynamic>;
      orderedVehicleVrms = docData['permits']?[permitId]
              ?['orderedVehicleVrms'] ??
          Instances.prefs
              .getStringList('permits.$permitId.orderedVehicleVrms') ??
          [];
    } else {
      orderedVehicleVrms = Instances.prefs
              .getStringList('permits.$permitId.orderedVehicleVrms') ??
          [];
    }
    if (orderedVehicleVrms.isEmpty) return;
    Map<String, int> orderedVehicleVrmsToIndices = {};
    for (int i = 0; i < orderedVehicleVrms.length; i++) {
      orderedVehicleVrmsToIndices[orderedVehicleVrms[i]] = i;
    }
    for (Vehicle vehicle in vehicles) {
      vehicle.index = orderedVehicleVrmsToIndices[vehicle.vrm];
    }
    vehicles.sort((a, b) {
      return a.index!.compareTo(b.index!);
    });
  }
}
