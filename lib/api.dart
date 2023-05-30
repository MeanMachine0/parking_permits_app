import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'models/permits_model.dart';

class Api {
  static String baseUrl = 'https://permits.paysmarti.co.uk/';
  static String accountUrl = '${baseUrl}acct/peterborough/';

  Future<List<String>> login(String email, String password) async {
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
    ];
  }

  Future<PermitsModel> getPermits(
      String fedAuthArpToken, String xsrfToken, String iXsrfToken) async {
    Map<String, dynamic> body = {
      '\u0024type':
          'Permits.Account.Common.Request.GetPermitsRequest, Permits.Account.Common',
      'pagedSearchDetails': {
        'pageSize': 1,
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
    Map<String, dynamic> responseData = response.data['items'][0];
    PermitsModel permits = permitsModelFromJson(json.encode(responseData));
    return permits;
  }
}
