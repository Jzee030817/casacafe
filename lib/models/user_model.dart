class UserModel {
  final String idUser;
  final String tokenSesion;
  final String nombre;
  final String correo;
  final String numTarjeta;
  final double saldo;
  final double puntos;

  UserModel(
      {this.idUser,
      this.tokenSesion,
      this.nombre,
      this.correo,
      this.numTarjeta,
      this.saldo,
      this.puntos});

  UserModel.anonimous()
      : idUser = '',
        tokenSesion = '',
        nombre = '',
        correo = '',
        numTarjeta = '',
        saldo = 0.0,
        puntos = 0.0;

  UserModel.fromJson(Map<String, dynamic> parsedJson)
      : idUser = parsedJson['idUser'] ?? '',
        tokenSesion = parsedJson['tokenSesion'] ?? '',
        nombre = parsedJson['nombre'] ?? '',
        correo = parsedJson['correo'] ?? '',
        numTarjeta = parsedJson['numTarjeta'] ?? '',
        saldo = parsedJson['saldo'] ?? 0.0,
        puntos = parsedJson['puntos'] ?? 0.0;

  UserModel.fromDb(Map<String, dynamic> parsedJson)
      : idUser = parsedJson['idUser'] ?? '',
        tokenSesion = parsedJson['tokenSesion'] ?? '',
        nombre = parsedJson['nombre'] ?? '',
        correo = parsedJson['correo'] ?? '',
        numTarjeta = parsedJson['numTarjeta'] ?? '',
        saldo = parsedJson['saldo'] ?? 0.0,
        puntos = parsedJson['puntos'] ?? 0.0;

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "idUser": idUser,
      "tokenSesion": tokenSesion,
      "nombre": nombre,
      "correo": correo,
      "numTarjeta": numTarjeta,
      "saldo": saldo,
      "puntos": puntos,
    };
  }
}

class UserResponse {
  final int errorCode;
  final String mensaje;
  final UserModel datos;

  UserResponse({this.errorCode, this.mensaje, this.datos});

  UserResponse.fromJson(Map<String, dynamic> parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '',
        datos = UserModel.fromJson(parsedJson['datos']);
}
