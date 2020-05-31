class PedidoModel {
  final String idUser;
  final String nomUser;
  final String tokenSesion;
  final String codTienda;
  final int formaPago;
  final double totalOrden;
  final double totalPuntos;
  final String numAutorizacion;
  final String horaRecoger;
  final String ordenComent;
  final String digitosTC;
  final String year;
  final String month;
  final String cvc;
  final String email;
  final String nameCard;
  final List<PedidoLinea> linPedido;

  PedidoModel(
      {this.idUser,
      this.nomUser,
      this.tokenSesion,
      this.codTienda,
      this.formaPago,
      this.totalOrden,
      this.totalPuntos,
      this.numAutorizacion,
      this.horaRecoger,
      this.ordenComent,
      this.linPedido,
      this.digitosTC,
      this.nameCard,
      this.month,
      this.year, 
      this.email,
      this.cvc});
}

class PedidoLinea {
  final String noItem;
  final double qtyItem;
  final double precUnitario;
  final double prePuntos;
  final String codMod1;
  final String valMod1;
  final String codMod2;
  final String valMod2;
  final String codMod3;
  final String valMod3;
  final String codMod4;
  final String valMod4;

  PedidoLinea(
      {this.noItem,
      this.qtyItem,
      this.precUnitario,
      this.prePuntos,
      this.codMod1,
      this.valMod1,
      this.codMod2,
      this.valMod2,
      this.codMod3,
      this.valMod3,
      this.codMod4,
      this.valMod4});
}

class PedidoResult {
  final int errorCode;
  final String mensaje;
  final PedidoDetail datos;

  PedidoResult({this.errorCode, this.mensaje, this.datos});

  PedidoResult.fromJson(parsedJson)
      : errorCode = parsedJson['errorCode'] ?? 0,
        mensaje = parsedJson['mensaje'] ?? '',
        datos = PedidoDetail.fromJson(parsedJson['datos']);
}

class PedidoDetail {
  final int noPedido;
  final String noAutorizacion;
  final String noTransaccion;
  final String responseCode;
  final String fechaProceso;

  PedidoDetail(
      {this.noPedido,
      this.noAutorizacion,
      this.noTransaccion,
      this.responseCode,
      this.fechaProceso});

  PedidoDetail.fromJson(parsedJson)
      : noPedido = parsedJson['noPedido'] ?? 0,
        noAutorizacion = parsedJson['noAutorizacion'] ?? '',
        noTransaccion = parsedJson['noTransaccion'] ?? '',
        responseCode = parsedJson['responseCode'] ?? '',
        fechaProceso = parsedJson['fechaProceso'] ?? '';
}
