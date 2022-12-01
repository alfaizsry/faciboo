import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class HttpService {
  static HttpService instance = HttpService.internal();
  HttpService.internal();
  factory HttpService() => instance;

  final LocalStorage storage = LocalStorage('faciboo');
  Map<String, String> headers = {};
  final JsonDecoder _decoder = const JsonDecoder();
  static const _baseUrl = 'http://103.23.199.203:3000/';

  Future<dynamic> post(String desturl,
      {Map<String, String> headers, body, encoding}) {
    body ??= {};

    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "auth-token": storage.getItem("authKey")
    };
    return http
        .post(Uri.parse(_baseUrl + desturl),
            body: json.encode(body),
            headers: requestHeaders,
            encoding: encoding)
        .then((http.Response response) {
      log("res ==============> $desturl == ${response.body}");
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }

      return _decoder.convert(response.body);
    }, onError: (error) {
      throw Exception(error.toString());
    });
  }
}
