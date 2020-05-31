class ItemResponse {
  int errorCode;
  String mensaje;
  List<ItemModel> datos;

  ItemResponse(this.errorCode, this.mensaje, this.datos);

  ItemResponse.fromJson(parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '',
        datos = List<ItemModel>.from(
            parsedJson["datos"].map((i) => ItemModel.fromJson(i)).toList());
}

class ItemModel {
  final String codigo;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String codCategoria;
  final String categoria;
  final String imgCategoria;
  final String codGrupo;
  final String grupo;
  final String imgGrupo;
  final int tieneModificadores;
  final double valorPuntos;
  final int prodUnico;

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : codigo = parsedJson['codigo'] ?? '',
        nombre = parsedJson['nombre'] ?? '',
        descripcion = parsedJson['descripcion'] ?? '',
        precio = parsedJson['precio'] ?? 0.0,
        imagen = parsedJson['imagen'] ?? '',
        codCategoria = parsedJson['codCategoria'] ?? '',
        categoria = parsedJson['categoria'] ?? '',
        imgCategoria = parsedJson['imgCategoria'] ?? '',
        codGrupo = parsedJson['codGrupo'] ?? '',
        grupo = parsedJson['grupo'] ?? '',
        imgGrupo = parsedJson['imgGrupo'] ?? '',
        tieneModificadores = parsedJson['tieneModificadores'] ?? 0,
        valorPuntos = parsedJson['valorPuntos'] ?? 0.0,
        prodUnico = parsedJson['prodUnico'] ?? 0;

  ItemModel.fromDb(Map<String, dynamic> parsedJson)
      : codigo = parsedJson['codigo'] ?? '',
        nombre = parsedJson['nombre'] ?? '',
        descripcion = parsedJson['descripcion'] ?? '',
        precio = parsedJson['precio'] ?? 0.0,
        imagen = parsedJson['imagen'] ?? '',
        codCategoria = parsedJson['codCategoria'] ?? '',
        categoria = parsedJson['categoria'] ?? '',
        imgCategoria = parsedJson['imgCategoria'] ?? '',
        codGrupo = parsedJson['codGrupo'] ?? '',
        grupo = parsedJson['grupo'] ?? '',
        imgGrupo = parsedJson['imgGrupo'] ?? '',
        tieneModificadores = parsedJson['tieneModificadores'] ?? 0,
        valorPuntos = parsedJson['valorPuntos'] ?? 0.0,
        prodUnico = parsedJson['prodUnico'] ?? 0;

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "codigo": codigo,
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio,
      "imagen": imagen,
      "codCategoria": codCategoria,
      "categoria": categoria,
      "imgCategoria": imgCategoria,
      "codGrupo": codGrupo,
      "grupo": grupo,
      "imgGrupo": imgGrupo,
      "tieneModificadores": tieneModificadores,
      "valorPuntos": valorPuntos,
      "prodUnico": prodUnico,
    };
  }
}
