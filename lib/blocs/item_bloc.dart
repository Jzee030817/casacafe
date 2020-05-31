import 'package:fl_ax_cdc/models/pedido_model.dart';
import 'package:fl_ax_cdc/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/store_model.dart';
import '../models/cartline_model.dart';
import '../models/modifiers_model.dart';
import '../resources/api_response.dart';
import '../resources/repository.dart';
import '../models/item_models.dart';

class ItemBloc {
  final _repository = Repository();
  // Menu principal
  final _innerCatStream = PublishSubject<ApiResponse<List<ItemModel>>>();
  final _outerCatStream = BehaviorSubject<ApiResponse<List<ItemModel>>>();
  // Menu secundario
  final _innerGrpStream = PublishSubject<ApiResponse<List<ItemModel>>>();
  final _outerGrpStream = BehaviorSubject<ApiResponse<List<ItemModel>>>();
  // Listado de productos
  final _innerItmStream = PublishSubject<ApiResponse<List<ItemModel>>>();
  final _outerItmStream = BehaviorSubject<ApiResponse<List<ItemModel>>>();
  // Pagina de tiendas
  final _innerStoreStream = PublishSubject<ApiResponse<List<StoreModel>>>();
  final _outerStoreStream = BehaviorSubject<ApiResponse<List<StoreModel>>>();
  // Pagina de producto
  // Cantidad
  final _innerQtyStream = PublishSubject<int>();
  final _outerQtyStream = BehaviorSubject<int>();
  // Modificadores
  final _innerModStream = PublishSubject<ApiResponse<List<ModifierModel>>>();
  final _outerModStream = BehaviorSubject<ApiResponse<List<ModifierModel>>>();
  // Agregar a orden
  final _innerOrdStream = PublishSubject<Future<int>>();
  final _outerOrdStream = BehaviorSubject<Future<int>>();
  // Recuperar orden
  final _innerCartStream = PublishSubject<ApiResponse<List<CartLineModel>>>();
  final _outerCartStream = BehaviorSubject<ApiResponse<List<CartLineModel>>>();
  // Checkout
  final _innerPOStream = PublishSubject<ApiResponse<PedidoDetail>>();
  final _outerPOStream = BehaviorSubject<ApiResponse<PedidoDetail>>();

  // getter to stream
  Observable<ApiResponse<List<ItemModel>>> get itemCatStream =>
      _outerCatStream.stream;
  Observable<ApiResponse<List<ItemModel>>> get itemGrpStream =>
      _outerGrpStream.stream;
  Observable<ApiResponse<List<ItemModel>>> get itemItmStream =>
      _outerItmStream.stream;
  Observable<ApiResponse<List<StoreModel>>> get storeStream =>
      _outerStoreStream.stream;
  Observable<int> get qtyStream => _outerQtyStream.stream;
  Observable<ApiResponse<List<ModifierModel>>> get itemModStream =>
      _outerModStream.stream;
  Observable<Future<int>> get ordStream => _outerOrdStream.stream;
  Observable<ApiResponse<List<CartLineModel>>> get cartStream =>
      _outerCartStream.stream;
  Observable<ApiResponse<PedidoDetail>> get poStream => _outerPOStream.stream;

  // getter to sink
  Function get itemCatSink => _innerCatStream.sink.add;
  Function get itemGrpSink => _innerGrpStream.sink.add;
  Function get itemItmSink => _innerItmStream.sink.add;
  Function get storeSink => _innerStoreStream.sink.add;
  Function get qtySink => _innerQtyStream.sink.add;
  Function get itemModSink => _innerModStream.sink.add;
  Function get ordSink => _innerOrdStream.sink.add;
  Function get cartSink => _innerCartStream.sink.add;
  Function get poSink => _innerPOStream.sink.add;

  ItemBloc() {
    _innerCatStream.stream.pipe(_outerCatStream);
    _innerGrpStream.stream.pipe(_outerGrpStream);
    _innerItmStream.stream.pipe(_outerItmStream);
    _innerStoreStream.stream.pipe(_outerStoreStream);
    _innerQtyStream.stream.pipe(_outerQtyStream);
    _innerModStream.stream.pipe(_outerModStream);
    _innerOrdStream.stream.pipe(_outerOrdStream);
    _innerCartStream.stream.pipe(_outerCartStream);
    _innerPOStream.stream.pipe(_outerPOStream);
  }

  getItemsCat() async {
    _innerCatStream.sink.add(ApiResponse.loading('Cargando datos...'));
    try {
      List<ItemModel> items = await _repository.getCategoryList();
      _innerCatStream.sink.add(ApiResponse.completed(items));
    } catch (e) {
      _innerCatStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  getItemsGrp(String cat) async {
    _innerGrpStream.sink.add(ApiResponse.loading('Cargando datos...'));
    try {
      List<ItemModel> grps = await _repository.getGroupList(cat);
      _innerGrpStream.sink.add(ApiResponse.completed(grps));
    } catch (e) {
      _innerGrpStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  getItemLst(String grp) async {
    _innerItmStream.sink.add(ApiResponse.loading('Cargando datos...'));
    try {
      List<ItemModel> itms = await _repository.getItemList(grp);
      _innerItmStream.sink.add(ApiResponse.completed(itms));
    } catch (e) {
      _innerItmStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  incQty(int qty) async => _innerQtyStream.sink.add(qty + 1);

  decQty(int qty) async => _innerQtyStream.sink.add(qty == 1 ? 1 : qty - 1);

  getItemModifiers(String codItem, String codUser, String tokenSession) async {
    _innerModStream.sink
        .add(ApiResponse.loading('Recuperando modificadores...'));
    try {
      List<ModifierModel> mods =
          await _repository.getModifiers(codItem, codUser, tokenSession);
      _innerModStream.sink.add(ApiResponse.completed(mods));
    } catch (e) {
      _innerModStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  putCartLine(CartLineModel crline) async =>
      _innerOrdStream.sink.add(_repository.putCartLine(crline));

  getCartLines() async {
    _innerCartStream.sink.add(ApiResponse.loading('Recuperando datos...'));
    try {
      List<CartLineModel> cart = await _repository.getCartLines();
      _innerCartStream.sink.add(ApiResponse.completed(cart));
    } catch (e) {
      _innerModStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  removeCartLine(int noLinea) async {
    await _repository.removeCartLine(noLinea);
    getCartLines();
  }

  removeOrder() async {
    await _repository.removeOrder();
    getCartLines();
  }

  getStoresList() async {
    _innerStoreStream.sink.add(ApiResponse.loading('Recuperando tiendas...'));
    try {
      List<StoreModel> stores = await _repository.getStoresList();
      _innerStoreStream.sink.add(ApiResponse.completed(stores));
    } catch (e) {
      _innerStoreStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  sendOrder(
      UserModel user,
      List<CartLineModel> cart,
      String selStore,
      String instruc,
      TimeOfDay horaRec,
      int formPag,
      double totalOrden,
      double totalPuntos, 
      String nameOnCard, 
      String numberCard, 
      String monthCard, 
      String yearCard, 
      String cvcCard) async {
    _innerPOStream.sink.add(ApiResponse.loading('Enviando pedido...'));
    try {
      PedidoDetail respuesta = await _repository.pushPedido(user, cart,
          selStore, instruc, horaRec, formPag, totalOrden, totalPuntos, 
          nameOnCard, numberCard, monthCard, yearCard, cvcCard);
      _innerPOStream.sink.add(ApiResponse.completed(respuesta));
    } catch (e) {
      print(e);
      _innerPOStream.sink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _innerCatStream.close();
    _outerCatStream.close();
    _innerGrpStream.close();
    _outerGrpStream.close();
    _innerItmStream.close();
    _outerItmStream.close();
    _innerStoreStream.close();
    _outerStoreStream.close();
    _innerQtyStream.close();
    _outerQtyStream.close();
    _innerModStream.close();
    _outerModStream.close();
    _innerOrdStream.close();
    _outerOrdStream.close();
    _innerCartStream.close();
    _outerCartStream.close();
    _innerPOStream.close();
    _outerPOStream.close();
  }
}
