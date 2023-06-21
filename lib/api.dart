import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'instances.dart';
import 'models/mini_permit_model.dart';
import 'models/permit_model.dart';
import 'variables.dart';

class Api {
  static String baseUrl = 'https://permits.paysmarti.co.uk/';
  static String accountUrl = '${baseUrl}acct/peterborough/';
  static String processorUrl = '${accountUrl}api/RequestProcessor/';

  Future<void> login(String email, String password) async {
    try {
      var response = await Dio().get(accountUrl);
      String referral = response.realUri.toString();
      String wctx =
          Uri.decodeComponent(referral.split('&wctx=')[1].split('&wa')[0]);
      Map<String, String> body = {
        'returnUrl': '',
        'email': email,
        'password': password,
      };
      Map<String, String> headers = {'referer': referral};
      response = await Dio().post(
        '${baseUrl}login/peterborough/Home/',
        data: body,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          contentType: Headers.formUrlEncodedContentType,
          headers: headers,
        ),
      );
      String fedAuthToken = response.headers['set-cookie']![0].split(';')[0];
      headers = {
        'cookie': fedAuthToken,
      };
      response = await Dio().get(referral,
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: headers,
          ));
      Document doc = parser.parse(response.data);
      Element inputElement = doc.querySelector('input[name="wresult"]')!;
      String wresult = inputElement.attributes['value']!;
      String expiry = wresult.split('</wsu:Expires>')[0].split(
          '<wsu:Expires xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">')[1];
      body = {
        'wa': 'wsignin1.0',
        'wresult': wresult,
        'wctx': wctx,
      };
      response = await Dio().post(
        accountUrl,
        data: body,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      String fedAuthArpToken = response.headers['set-cookie']![0].split(';')[0];
      headers = {
        'cookie': fedAuthArpToken,
      };
      response = await Dio().get(
        accountUrl,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          headers: headers,
        ),
      );
      List<String> cookies = response.headers['set-cookie']!;
      String xsrfToken = cookies[0].split(';')[0];
      String iXsrfToken = cookies[1].split(';')[0];
      Variables.tokens = [
        fedAuthToken,
        fedAuthArpToken,
        xsrfToken,
        iXsrfToken,
        expiry,
      ];
    } catch (e) {
      return;
    }
  }

  Future<List> getMiniPermits(bool firstOnly, bool customSort) async {
    Map<String, dynamic> body = {
      '\u0024type':
          'Permits.Account.Common.Request.GetPermitsRequest, Permits.Account.Common',
      'pagedSearchDetails': {
        'pageSize': firstOnly ? 1 : 1000,
        'pageNumber': 1,
        'orderBy': 'expiryDate',
        'isAscending': false
      }
    };
    Map<String, String> headers = {
      'cookie':
          '${Variables.tokens[1]}; ${Variables.tokens[2]}; ${Variables.tokens[3]}',
      'x-xsrf-token': Variables.tokens[2].split('peterborough=')[1]
    };
    try {
      var response = await Dio().post('${accountUrl}api/RequestProcessor/',
          data: body,
          options: Options(
            headers: headers,
          ));
      if (firstOnly) {
        var itemData = response.data['items'][0];
        MiniPermitModel miniPermit =
            miniPermitModelFromJson(json.encode(itemData));
        String permitId = itemData['id'].toString();
        PermitModel? permit = await getPermit(permitId, customSort);
        if (permit == null) {
          return [false];
        }
        return [miniPermit, permit];
      }
      List<dynamic> miniPermitsData = response.data['items'];
      List<MiniPermitModel> miniPermits = [];
      for (Map<String, dynamic> miniPermit in miniPermitsData) {
        miniPermits.add(miniPermitModelFromJson(json.encode(miniPermit)));
      }
      return miniPermits;
    } catch (e) {
      return [false];
    }
  }

  Future<PermitModel?> getPermit(String permitId, bool customSort) async {
    DocumentSnapshot? doc;
    Map<String, dynamic>? docData;
    Map<String, String> headers = {
      'cookie':
          '${Variables.tokens[1]}; ${Variables.tokens[2]}; ${Variables.tokens[3]}',
      'x-xsrf-token': Variables.tokens[2].split('peterborough=')[1]
    };
    Map<String, String> body = {
      '\u0024type':
          'Permits.Account.Common.Request.GetPermitRequest, Permits.Account.Common',
      'id': permitId
    };
    try {
      if (Instances.docRef != null) {
        doc = await Instances.docRef!.get();
        if (doc.exists) {
          docData = doc.data() as Map<String, dynamic>;
        }
      }
      var response = await Dio()
          .post(processorUrl, data: body, options: Options(headers: headers));
      PermitModel permit =
          permitModelFromJson(json.encode(response.data['permit']));
      bool useFirestoreVehicles = !Variables.isSyncing &&
          Instances.docRef != null &&
          doc!.exists &&
          docData!.containsKey('vehicles');
      for (Vehicle vehicle in permit.vehicles) {
        if (useFirestoreVehicles) {
          vehicle.note = doc['vehicles']?[vehicle.id.toString()]?['note'];
          vehicle.isFavourite =
              doc['vehicles']?[vehicle.id.toString()]?['isFavourite'] ?? false;
        } else {
          vehicle.note = Instances.prefs.getString('${vehicle.id}Note');
          vehicle.isFavourite =
              Instances.prefs.getBool('${vehicle.id}IsFavourite') ?? false;
        }
      }
      if (customSort &&
          Instances.prefs.getStringList(permitId.toString()) != null) {
        await Vehicle.sortByCustom(permit.vehicles, permitId, doc);
      } else {
        Vehicle.sortByIsFavourite(permit.vehicles);
      }
      return permit;
    } catch (e) {
      return null;
    }
  }

  Future<bool> assignPermit(String permitId, String newVehicleId) async {
    Map<String, String> headers = {
      'cookie':
          '${Variables.tokens[1]}; ${Variables.tokens[2]}; ${Variables.tokens[3]}',
      'x-xsrf-token': Variables.tokens[2].split('peterborough=')[1]
    };
    Map<String, String> body = {
      "\u0024type":
          "Permits.Account.Common.Request.ChangeActiveVehicleRequest, Permits.Account.Common",
      "permitId": permitId,
      "vehicleId": newVehicleId
    };
    try {
      var response = await Dio().post(
        processorUrl,
        data: body,
        options: Options(
          headers: headers,
        ),
      );
      if (!response.data['success']) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editVehicleVrm(
      String permitId, String oldVehicleId, String newVehicleVrm) async {
    Map<String, String> headers = {
      'cookie':
          '${Variables.tokens[1]}; ${Variables.tokens[2]}; ${Variables.tokens[3]}',
      'x-xsrf-token': Variables.tokens[2].split('peterborough=')[1]
    };
    List<Map<String, dynamic>> bodies = [
      {
        "\u0024type":
            "Permits.Account.Common.Request.StartPermitVehicleEditRequest, Permits.Account.Common",
        "permitId": permitId,
        "vehicleId": oldVehicleId
      },
      {
        "\u0024type":
            "Permits.Account.Common.Request.ValidateVrmAccountRequest, Permits.Account.Common",
        "vrm": newVehicleVrm
      },
      {
        "\u0024type":
            "Permits.Account.Common.Request.SavePermitVehicleChangesRequest, Permits.Account.Common",
        "permitId": permitId,
        "vehicle": {
          "\u0024type":
              "Permits.Infrastructure.Model.PermitVehicleEditModel, Permits.Infrastructure",
          "id": oldVehicleId,
          "vrm": newVehicleVrm
        }
      }
    ];
    try {
      for (Map<String, dynamic> body in bodies) {
        var response = await Dio().post(
          processorUrl,
          data: body,
          options: Options(
            headers: headers,
          ),
        );
        if (!response.data['success']) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<PermitModel?> addVehicleToPermit(
      String vrm, PermitModel permit, bool customSort) async {
    Map<String, String> headers = {
      'cookie':
          '${Variables.tokens[1]}; ${Variables.tokens[2]}; ${Variables.tokens[3]}',
      'x-xsrf-token': Variables.tokens[2].split('peterborough=')[1]
    };
    List<Map<String, dynamic>> bodies = [
      {
        "\u0024type":
            "Permits.Account.Common.Request.StartPermitVehicleEditRequest, Permits.Account.Common",
        "permitId": permit.id.toString(),
        "vehicleId": '0'
      },
      {
        "\u0024type":
            "Permits.Account.Common.Request.ValidateVrmAccountRequest, Permits.Account.Common",
        "vrm": vrm
      },
      {
        "\u0024type":
            "Permits.Account.Common.Request.SavePermitVehicleChangesRequest, Permits.Account.Common",
        "permitId": permit.id.toString(),
        "vehicle": {
          "\u0024type":
              "Permits.Infrastructure.Model.PermitVehicleEditModel, Permits.Infrastructure",
          "id": '0',
          "vrm": vrm
        }
      }
    ];
    try {
      for (Map<String, dynamic> body in bodies) {
        var response = await Dio().post(
          processorUrl,
          data: body,
          options: Options(
            headers: headers,
          ),
        );
        if (!response.data['success']) {
          return null;
        }
      }
      PermitModel? updatedPermit =
          await getPermit(permit.id.toString(), customSort);
      return updatedPermit;
    } catch (e) {
      return null;
    }
  }
}
