import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'app_exception.dart';

class NetHelper {
  final String _baseUrl = "http://192.168.31.40:8888/app/api";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No se pudo establecer comunicacion con el servidor.');
    }

    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    var responseJson;
    final Map<String, String> header = {"Content-type": "application/json"};
    try {
      final response =
          await http.post(_baseUrl + url, headers: header, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No se pudo establecer comunicacion con el servidor.');
    }
    return responseJson;
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      if (responseJson['errorCode'] != 0)
        throw FetchDataException(responseJson['mensaje']);
      else
        return responseJson;
      break;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorizedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error de comunicación con StatusCode : ${response.statusCode}');
  }
}
