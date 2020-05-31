import 'package:fl_ax_cdc/models/pedido_model.dart';
import 'package:flutter/material.dart';

import '../models/cartline_model.dart';
import '../models/store_model.dart';
import '../config/app_strings.dart';
import '../models/modifiers_model.dart';
import '../models/user_model.dart';
import '../models/item_models.dart';
import '../resources/netprovider.dart';
import '../resources/dbprovider.dart';

class Repository {
  DbProvider dbProv = dbProvider;
  NetProvider netProv = NetProvider();

  Future<List<ItemModel>> getCategoryList() async {
    List<ItemModel> itemList = await dbProv.getTopLevelList();

    if (itemList.length == 0) {
      itemList =
          await netProv.populateItems(constDefaultUser, constDefaultToken);

      if (!(itemList.length == 0)) {
        for (int i = 0; i < itemList.length; i++) {
          dbProv.addItem(itemList[i]);
        }

        // fetching top level items
        itemList = await dbProv.getTopLevelList();
      }
    }

    return itemList;
  }

  Future<List<ItemModel>> getGroupList(String cat) async {
    return await dbProv.getSecondLevelList(cat);
  }

  Future<List<ItemModel>> getItemList(String grp) async {
    return await dbProv.getItemList(grp);
  }

  Future<UserModel> getSessionData(String _idUser, String _pwd) async {
    UserModel user = await dbProv.getUserData();

    if (user.idUser == "") {
      user = await netProv.getSessionData(_idUser, _pwd);

      dbProv.addUser(user);
    }

    return user;
  }

  void resetPassword(String _email) async {
    await netProv.resetPassword(_email);
  }

  Future<PedidoResult> changePassword(String userId, String sesionId, String oldPwd, String newPwd) async {
    PedidoResult res;
    res = await netProv.changePassword(userId, sesionId, oldPwd, newPwd);

    return res;
  }

  Future<UserModel> getSignupData(String email, String names) async {
    final UserModel session = await netProv.getSignupData(email, names);
    if (session.tokenSesion != '') {
      dbProv.addUser(session);
    }

    return session;
  }

  Future<UserModel> restoreSession() async {
    return await dbProv.getUserData();
  }

  Future<int> closeSession() async {
    return await dbProv.closeSession();
  }

  Future<List<ModifierModel>> getModifiers(
      String codItem, String idUser, String tokenSession) async {
    final List<ModifierModel> mods =
        await netProv.getModifiers(codItem, idUser, tokenSession);
    dbProv.addModifiers(mods);
    return mods;
  }

  Future<int> putCartLine(CartLineModel crline) async {
    return await dbProv.putCartLine(crline);
  }

  Future<List<CartLineModel>> getCartLines() async {
    return await dbProv.getCartLines();
  }

  Future<int> removeCartLine(int noLinea) async {
    return await dbProv.removeCartLine(noLinea);
  }

  Future<int> removeOrder() async {
    return await dbProv.removeOrder();
  }

  Future<List<StoreModel>> getStoresList() async {
    List<StoreModel> stores = await dbProv.getStoresList();

    if (stores.length == 0) {
      stores =
          await netProv.populateStores(constDefaultUser, constDefaultToken);

      if (stores.length != 0) {
        for (int i = 0; i < stores.length; i++) {
          dbProv.addStore(stores[i]);
        }
      }
    }

    return stores;
  }

  Future<PedidoDetail> pushPedido(
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
    return await netProv.pushPedido(user, cart, selStore, instruc, horaRec,
        formPag, totalOrden, totalPuntos, nameOnCard, numberCard, monthCard, 
        yearCard, cvcCard);
  }
}
