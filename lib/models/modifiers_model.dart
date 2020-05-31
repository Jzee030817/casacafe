class ModifiersResponse {
  int errorCode;
  String mensaje;
  List<ModifierModel> datos;

  ModifiersResponse(this.errorCode, this.mensaje, this.datos);

  ModifiersResponse.fromJson(parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '',
        datos = List<ModifierModel>.from(
            parsedJson["datos"].map((i) => ModifierModel.fromJson(i)).toList());
}

class ListModifiersModel {
  final List<ModifierModel> modifiers;

  ListModifiersModel(this.modifiers);

  ListModifiersModel.fromJson(List<dynamic> parsedJson)
      : modifiers = parsedJson.map((i) => ModifierModel.fromJson(i)).toList();
}

class ModifierModel {
  final String code;
  final String description;
  final String prompt;
  final List<ElementModel> elementos;

  ModifierModel({this.code, this.description, this.prompt, this.elementos});

  ModifierModel.fromJson(Map<String, dynamic> parsedJson)
      : code = parsedJson['codigo'] ?? '',
        description = parsedJson['descripcion'] ?? '',
        prompt = parsedJson['prompt'] ?? '',
        elementos = List<ElementModel>.from(
            parsedJson["items"].map((i) => ElementModel.fromJson(i)).toList());
}

class ElementModel {
  final String subCode;
  final String description;
  final String codItem;
  final int tipoPrecio;
  final double precioAdic;
  final double puntosAdic;

  ElementModel({this.subCode, this.description, this.codItem, this.tipoPrecio, this.precioAdic, this.puntosAdic});

  ElementModel.fromJson(Map<String, dynamic> parsedJson)
      : subCode = parsedJson['subCode'] ?? '',
        description = parsedJson['descripcion'] ?? '',
        codItem = parsedJson['codItem'] ?? '',
        tipoPrecio = parsedJson['tipoPrecio'] ?? 0,
        precioAdic = ((parsedJson['precioAdic'] * 100).round() / 100) ?? 0,
        puntosAdic = parsedJson['puntosAdic'] ?? 0;
}

class ModLine {
  final String code;
  final String description;
  final String prompt;
  final String subcode;
  final String subdescription;
  final String coditem;
  final int tipoPrecio;
  final double precioAdic;
  final double puntosAdic;

  ModLine(
      {this.code,
      this.description,
      this.prompt,
      this.subcode,
      this.subdescription,
      this.coditem,
      this.tipoPrecio,
      this.precioAdic,
      this.puntosAdic
      });

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "code": code,
      "description": description,
      "prompt": prompt,
      "subcode": subcode,
      "subdescription": subdescription,
      "coditem": coditem,
      "tipoPrecio": tipoPrecio,
      "precioAdic": precioAdic,
      "puntosAdic": puntosAdic
    };
  }
}
