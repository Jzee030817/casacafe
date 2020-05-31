class StoresListModel {
  final int errorCode;
  final String mensaje;
  final List<StoreModel> datos;

  StoresListModel({this.errorCode, this.mensaje, this.datos});

  StoresListModel.fromJson(parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '',
        datos = List<StoreModel>.from(
            parsedJson["datos"].map((i) => StoreModel.fromJson(i)).toList());
}

class StoreModel {
  final String codTienda;
  final String nomTienda;
  final String nomCorto;
  final String direcc1;
  final String direcc2;
  final String direcc3;
  final String direcc4;
  final String numTelef;
  final double gpsLat;
  final double gpsLong;
  final String imagen;

  StoreModel.fromJson(Map<String, dynamic> parsedJson)
      : codTienda = parsedJson['codTienda'] ?? '',
        nomTienda = parsedJson['nomTienda'] ?? '',
        nomCorto = parsedJson['nomCorto'] ?? '',
        direcc1 = parsedJson['direcc1'] ?? '',
        direcc2 = parsedJson['direcc2'] ?? '',
        direcc3 = parsedJson['direcc3'] ?? '',
        direcc4 = parsedJson['direcc4'] ?? '',
        numTelef = parsedJson['numTelef'] ?? '',
        gpsLat = parsedJson['gpsLat'] ?? 0.0,
        gpsLong = parsedJson['gpsLong'] ?? 0.0,
        imagen = parsedJson['imagen'] ?? '';

  StoreModel.fromDb(Map<String, dynamic> parsedJson)
      : codTienda = parsedJson['codTienda'] ?? '',
        nomTienda = parsedJson['nomTienda'] ?? '',
        nomCorto = parsedJson['nomCorto'] ?? '',
        direcc1 = parsedJson['direcc1'] ?? '',
        direcc2 = parsedJson['direcc2'] ?? '',
        direcc3 = parsedJson['direcc3'] ?? '',
        direcc4 = parsedJson['direcc4'] ?? '',
        numTelef = parsedJson['numTelef'] ?? '',
        gpsLat = parsedJson['gpsLat'] ?? 0.0,
        gpsLong = parsedJson['gpsLong'] ?? 0.0,
        imagen = parsedJson['imagen'] ?? '';

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "codTienda": codTienda,
      "nomTienda": nomTienda,
      "nomCorto": nomCorto,
      "direcc1": direcc1,
      "direcc2": direcc2,
      "direcc3": direcc3,
      "direcc4": direcc4,
      "numTelef": numTelef,
      "gpsLat": gpsLat,
      "gpsLong": gpsLong,
      "imagen": imagen,
    };
  }
}
