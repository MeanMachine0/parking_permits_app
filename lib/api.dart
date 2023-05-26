import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:dio/dio.dart';

class Api {
  static String baseUrl = 'https://permits.paysmarti.co.uk';

  Future<List<String?>> login() async {
    Dio dio = Dio();
    var response = await dio.get('$baseUrl/acct/peterborough');
    String referral = response.realUri.toString();
    String wctx =
        Uri.decodeComponent(referral.split('&wctx=')[1].split('&wa')[0]);
    Map<String, String> body = {
      'returnUrl': '',
      'email': 'tim.carter.home@gmail.com',
      'password': 'Shopwebpa55',
    };
    Map<String, String> headers = {'Referer': referral};
    response = await dio.post(
      '$baseUrl/login/peterborough/Home',
      data: body,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          headers: headers),
    );
    String fedAuthToken = response.headers['set-cookie']![0].split(';')[0];
    headers = {
      'Cookie': fedAuthToken,
    };
    response = await dio.get(referral,
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
    response = await dio.post(
      '$baseUrl/acct/peterborough',
      data: body,
      options: Options(
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    // Unexpectedly doesn't return the following header atm:
    String fedAuthArpToken = response.headers['set-cookie']![0].split(';')[0];
    return [
      fedAuthToken,
      fedAuthArpToken,
    ];
  }
}
