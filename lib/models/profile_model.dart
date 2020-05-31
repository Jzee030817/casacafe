class ProfileModel {
  final String tarjeta;
  final double saldo;
  final double puntos;

  ProfileModel({this.tarjeta, this.saldo, this.puntos});

  ProfileModel.fromJson(Map<String, dynamic> parsedJson)
      : tarjeta = parsedJson['tarjeta'] ?? '',
        saldo = parsedJson['saldo'] ?? 0.0,
        puntos = parsedJson['puntos'] ?? 0.0;

  ProfileModel.fromDb(Map<String, dynamic> parsedJson)
      : tarjeta = parsedJson['tarjeta'] ?? '',
        saldo = parsedJson['saldo'] ?? 0.0,
        puntos = parsedJson['puntos'] ?? 0.0;
}

class ProfileResponse {
  final int errorCode;
  final String mensaje;
  final ProfileModel datos;

  ProfileResponse({this.errorCode, this.mensaje, this.datos});

  ProfileResponse.fromJson(Map<String, dynamic> parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '',
        datos = ProfileModel.fromJson(parsedJson['datos']);
}
