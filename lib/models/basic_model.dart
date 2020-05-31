class BasicResponse {
  final errorCode;
  final mensaje;

  BasicResponse({this.errorCode, this.mensaje});

  BasicResponse.fromJson(Map<String, String> parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '';
}
