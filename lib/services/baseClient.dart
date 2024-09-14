import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fazzmi/services/app_exception.dart';
import "package:http/http.dart" as http;

class BaseClientt {
  static const int TIME_OUT_DURATION = 20;

  // get
  Future<dynamic> get(String baseUrl, String api) async {
    var url = Uri.parse(baseUrl + api);

    try {
      var response =
          await http.get(url).timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", url.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responding in time', url.toString());
    }
  }
  // post

  Future<dynamic> post(String baseUrl, String api, dynamic payloadObj) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj);

    try {
      var response = await http
          .post(url, body: payload)
          .timeout(Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", url.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responding in time', url.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());

      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());

      case 500:
        throw FetchDataException(
            "Error occured with code : ${response.statusCode}",
            response.request!.url.toString());

      default:
    }
  }
}
