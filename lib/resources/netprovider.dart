import 'package:intl/intl.dart';

import '../resources/app_functions.dart';
import 'package:flutter/material.dart';

import '../models/cartline_model.dart';
import '../models/pedido_model.dart';

import '../models/store_model.dart';
import '../models/modifiers_model.dart';
import '../config/app_strings.dart';
import '../models/basic_model.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';
import '../resources/net_helper.dart';
import '../models/item_models.dart';

class NetProvider {
  NetHelper _helper = NetHelper();
  AppFunctions appf;

  Future<List<ItemModel>> populateItems(
      String idUser, String tokenSession) async {
    if (idUser == '') idUser = constDefaultUser;
    if (tokenSession == '') tokenSession = constDefaultToken;
    final String body = '{"idUser":"$idUser", "tokenSesion":"$tokenSession"}';
    final response = await _helper.post("/GetProductos", body);
    return ItemResponse.fromJson(response).datos;
  }

  Future<List<StoreModel>> populateStores(
      String idUser, String tokenSession) async {
    if (idUser == '') idUser = constDefaultUser;
    if (tokenSession == '') tokenSession = constDefaultToken;
    final String body = '{"idUser":"$idUser", "tokenSesion":"$tokenSession"}';
    final response = await _helper.post("/GetStores", body);
    return StoresListModel.fromJson(response).datos;
  }

  Future<ProfileModel> getProfileData(
      String idUser, String tokenSession) async {
    final String body = '{"idUser":"$idUser", "tokenSesion":"$tokenSession"}';
    final response = await _helper.post("/GetMonedero", body);
    return ProfileResponse.fromJson(response).datos;
  }

  Future<UserModel> getSessionData(String idUser, String password) async {
    final String body = '{"correo":"$idUser", "pwd":"$password"}';
    final response = await _helper.post("/LoginRequest", body);
    return UserResponse.fromJson(response).datos;
  }

  Future<BasicResponse> resetPassword(String _email) async {
    final String body = '{"idUser":"$_email"}';
    final response = await _helper.post("/ResetRequest", body);
    return BasicResponse.fromJson(response);
  }

  Future<PedidoResult> changePassword(String userId, String sesionId, String oldPwd, String newPwd) async {
    final String body = '{"idUser":"$userId", "tokenSesion":"$sesionId", "oldPws":"$oldPwd", "newPwd":"$newPwd"}';
    final response = await _helper.post('/CambioClave', body);
    return PedidoResult.fromJson(response);
  }

  Future<UserModel> getSignupData(String _email, String _names) async {
    final String body = '{"correo":"$_email", "nombre":"$_names"}';
    final response = await _helper.post("/SignUp", body);
    return UserResponse.fromJson(response).datos;
  }

  Future<List<ModifierModel>> getModifiers(
      String itemCod, String userId, String tokenSession) async {
    final String body =
        '{"idUser": "$userId", "tokenSesion": "$tokenSession", "codItem": "$itemCod"}';
    final response = await _helper.post("/GetModificadores", body);
    return ModifiersResponse.fromJson(response).datos;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Future<PedidoDetail> pushPedido(
      UserModel user,
      List<CartLineModel> cart,
      String selStore,
      String instrucc,
      TimeOfDay horaRec,
      int formPag,
      double totalOrden,
      double totalPuntos,
      String nameOnCard,
      String numberCard,
      String monthCard,
      String yearCard,
      String cvcCard) async {
    if (instrucc == null) instrucc = "(ninguna)";
    final String body = '{"idUser": "${user.idUser}", ' +
        '"tokenSesion": "${user.tokenSesion}", ' +
        '"nomUser": "${user.nombre}", ' +
        '"codTienda": "$selStore", ' +
        '"formaPago": $formPag, ' +
        '"totalOrden": $totalOrden, ' +
        '"totalPuntos": $totalPuntos, ' +
        '"horaRecoger": "${formatTimeOfDay(horaRec)}", ' +
        '"ordenComent": "$instrucc", ' +
        '"digitosTC": "$numberCard", ' +
        '"year": "$yearCard", ' +
        '"month": "$monthCard", ' + 
        '"cvc": "$cvcCard", ' + 
        '"email": "${user.idUser}", ' + 
        '"nameCard": "$nameOnCard", ' + 
        '"linPedido": [${cartToString(cart)}]}';
    final response = await _helper.post("/PushPedido", body);
    return PedidoResult.fromJson(response).datos;
  }

  String cartToString(List<CartLineModel> lines) {
    String cart = '';
    lines.forEach((CartLineModel line) =>
        {cart = cart + (cart == '' ? '' : ', ') + line.toJsonLine()});

    return cart;
  }
}
