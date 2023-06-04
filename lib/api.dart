import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'models/mini_permit_model.dart';
import 'models/permit_model.dart';

class Api {
  static String baseUrl = 'https://permits.paysmarti.co.uk/';
  static String accountUrl = '${baseUrl}acct/peterborough/';
  static String processorUrl = '${accountUrl}api/RequestProcessor/';

  Future<List<String>> login(String email, String password) async {
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
      return [
        fedAuthToken,
        fedAuthArpToken,
        xsrfToken,
        iXsrfToken,
        expiry,
      ];
    } catch (e) {
      return [];
    }
  }

  Future<List> getMiniPermits(String fedAuthArpToken, String xsrfToken,
      String iXsrfToken, bool firstOnly) async {
    Map<String, dynamic> body = {
      '\u0024type':
          'Permits.Account.Common.Request.GetPermitsRequest, Permits.Account.Common',
      'pagedSearchDetails': {
        'pageSize': firstOnly ? 1 : 1000,
        'pageNumber': 1,
        'orderBy': 'permitNumber',
        'isAscending': false
      }
    };
    Map<String, String> headers = {
      'cookie': '$fedAuthArpToken; $xsrfToken; $iXsrfToken',
      'x-xsrf-token': xsrfToken.split('peterborough=')[1]
    };
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
      PermitModel permit =
          await getPermit(permitId, fedAuthArpToken, xsrfToken, iXsrfToken);
      return [miniPermit, permit];
    }
    List<dynamic> miniPermitsData = response.data['items'];
    List<MiniPermitModel> miniPermits = [];
    for (Map<String, dynamic> miniPermit in miniPermitsData) {
      miniPermits.add(miniPermitModelFromJson(json.encode(miniPermit)));
    }
    return miniPermits;
  }

  Future<PermitModel> getPermit(String permitId, String fedAuthArpToken,
      String xsrfToken, String iXsrfToken) async {
    Map<String, String> headers = {
      'cookie': '$fedAuthArpToken; $xsrfToken; $iXsrfToken',
      'x-xsrf-token': xsrfToken.split('peterborough=')[1]
    };
    Map<String, String> body = {
      '\u0024type':
          'Permits.Account.Common.Request.GetPermitRequest, Permits.Account.Common',
      'id': permitId
    };
    var response = await Dio()
        .post(processorUrl, data: body, options: Options(headers: headers));
    PermitModel permit =
        permitModelFromJson(json.encode(response.data['permit']));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (Vehicle vehicle in permit.vehicles) {
      vehicle.note = prefs.getString(vehicle.id.toString()) ?? '';
    }
    return permit;
  }

  Future<void> setActiveVehicle(String permitId, String newVehicleId,
      String fedAuthArpToken, String xsrfToken, String iXsrfToken) async {
    Map<String, String> headers = {
      'cookie': '$fedAuthArpToken; $xsrfToken; $iXsrfToken',
      'x-xsrf-token': xsrfToken.split('peterborough=')[1]
    };
    Map<String, String> body = {
      "\u0024type":
          "Permits.Account.Common.Request.ChangeActiveVehicleRequest, Permits.Account.Common",
      "permitId": permitId,
      "vehicleId": newVehicleId
    };
    await Dio().post(
      processorUrl,
      data: body,
      options: Options(
        headers: headers,
      ),
    );
  }
}
