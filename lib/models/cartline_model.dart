class CartLineModel {
  final int noLinea;
  final String noItem;
  final String itemDesc;
  final int qty;
  final double precioPuntos;
  final double precioUnitario;
  final double totalPuntos;
  final double totalLinea;
  final String codMod1;
  final String descMod1;
  final String valMod1;
  final int tipMod1;
  final double preMod1;
  final double ptsMod1;
  final String codMod2;
  final String descMod2;
  final String valMod2;
  final int tipMod2;
  final double preMod2;
  final double ptsMod2;
  final String codMod3;
  final String descMod3;
  final String valMod3;
  final int tipMod3;
  final double preMod3;
  final double ptsMod3;
  final String codMod4;
  final String descMod4;
  final String valMod4;
  final int tipMod4;
  final double preMod4;
  final double ptsMod4;
  final String imageUrl;

  CartLineModel({
    this.noLinea,
    this.noItem,
    this.itemDesc,
    this.qty,
    this.precioPuntos,
    this.precioUnitario,
    this.totalPuntos,
    this.totalLinea,
    this.codMod1,
    this.descMod1,
    this.valMod1,
    this.tipMod1,
    this.preMod1,
    this.ptsMod1,
    this.codMod2,
    this.descMod2,
    this.valMod2,
    this.tipMod2,
    this.preMod2,
    this.ptsMod2,
    this.codMod3,
    this.descMod3,
    this.valMod3,
    this.tipMod3,
    this.preMod3,
    this.ptsMod3,
    this.codMod4,
    this.descMod4,
    this.valMod4,
    this.tipMod4,
    this.preMod4,
    this.ptsMod4,
    this.imageUrl,
  });

  CartLineModel.fromDb(Map<String, dynamic> parsedJson)
      : noLinea = parsedJson['noLinea'] ?? 0,
        noItem = parsedJson['noItem'] ?? '',
        itemDesc = parsedJson['itemDesc'] ?? '',
        qty = parsedJson['qty'] ?? 1,
        precioPuntos = parsedJson['precioPuntos'] ?? 0.0,
        precioUnitario = parsedJson['precioUnitario'] ?? 0.0,
        totalPuntos = parsedJson['totalPuntos'] ?? 0.0,
        totalLinea = parsedJson['totalLinea'] ?? 0.0,
        codMod1 = parsedJson['codMod1'] ?? '',
        descMod1 = parsedJson['descMod1'] ?? '',
        valMod1 = parsedJson['valMod1'] ?? '',
        tipMod1 = parsedJson['tipMod1'] ?? 0,
        preMod1 = parsedJson['preMod1'] ?? 0.0,
        ptsMod1 = parsedJson['ptsMod1'] ?? 0.0,
        codMod2 = parsedJson['codMod2'] ?? '',
        descMod2 = parsedJson['descMod2'] ?? '',
        valMod2 = parsedJson['valMod2'] ?? '',
        tipMod2 = parsedJson['tipMod2'] ?? 0,
        preMod2 = parsedJson['preMod2'] ?? 0.0,
        ptsMod2 = parsedJson['ptsMod2'] ?? 0.0, 
        codMod3 = parsedJson['codMod3'] ?? '',
        descMod3 = parsedJson['descMod3'] ?? '',
        valMod3 = parsedJson['valMod3'] ?? '',
        tipMod3 = parsedJson['tipMod3'] ?? 0,
        preMod3 = parsedJson['preMod3'] ?? 0.0,
        ptsMod3 = parsedJson['ptsMod3'] ?? 0.0, 
        codMod4 = parsedJson['codMod4'] ?? '',
        descMod4 = parsedJson['descMod4'] ?? '',
        valMod4 = parsedJson['valMod4'] ?? '',
        tipMod4 = parsedJson['tipMod4'] ?? 0,
        preMod4 = parsedJson['preMod4'] ?? 0.0,
        ptsMod4 = parsedJson['ptsMod4'] ?? 0.0, 
        imageUrl = parsedJson['imageUrl'] ?? '';

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "noLinea": noLinea,
      "noItem": noItem,
      "itemDesc": itemDesc,
      "qty": qty,
      "precioPuntos": precioPuntos,
      "precioUnitario": precioUnitario,
      "totalPuntos": ((precioPuntos + ptsMod1 + ptsMod2 + ptsMod3 + ptsMod4) * qty),
      "totalLinea": ((precioUnitario + preMod1 + preMod2 + preMod3 + preMod4) * qty),
      "codMod1": codMod1,
      "descMod1": descMod1,
      "valMod1": valMod1,
      "tipMod1": tipMod1,
      "preMod1": preMod1,
      "ptsMod1": ptsMod1,
      "codMod2": codMod2,
      "descMod2": descMod2,
      "valMod2": valMod2,
      "tipMod2": tipMod2,
      "preMod2": preMod2,
      "ptsMod2": ptsMod2,
      "codMod3": codMod3,
      "descMod3": descMod3,
      "valMod3": valMod3,
      "tipMod3": tipMod3,
      "preMod3": preMod3,
      "ptsMod3": ptsMod3,
      "codMod4": codMod4,
      "descMod4": descMod4,
      "valMod4": valMod4,
      "tipMod4": tipMod4, 
      "preMod4": preMod4, 
      "ptsMod4": ptsMod4, 
      "imageUrl": imageUrl
    };
  }

  String toJsonLine() {
    return '{"noItem": "$noItem", "prePuntos": $precioPuntos, "precUnitario": $precioUnitario, "qtyItem": $qty, "codMod1": "$codMod1", "codMod2": "$codMod2", "codMod3": "$codMod3", "codMod4": "$codMod4", "valMod1": "$valMod1", "valMod2": "$valMod2", "valMod3": "$valMod3", "valMod4": "$valMod4"}';
  }
}
