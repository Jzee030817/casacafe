import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/login_page.dart';
import '../screens/restricted_page.dart';
import '../blocs/item_provider.dart';
import '../blocs/user_provider.dart';
import '../config/app_strings.dart';
import '../config/app_style.dart';
import '../models/cartline_model.dart';
import '../models/modifiers_model.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';
import '../models/item_models.dart';
import '../widgets/mc_dropdown.dart';
import 'loading_page.dart';
import 'error_page.dart';

class ItemPage extends StatelessWidget {
  final String title;
  final ItemModel item;

  ItemPage({this.title, this.item});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ApiItemWrapper(item: item),
    );
  }
}

class ApiItemWrapper extends StatelessWidget {
  final ItemModel item;

  ApiItemWrapper({Key key, this.item}) : super(key: key);

  Widget build(BuildContext context) {
    final userBloc = UserProvider.of(context);
    userBloc.restoreSession();

    return StreamBuilder<ApiResponse<UserModel>>(
      stream: userBloc.sessionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
            case Status.completed:
              if (snapshot.data.data.idUser == "") {
                return RestrictedPage(
                  errorMessage:
                      "Debe iniciar sesion para acceder a esta página.",
                  onRetryPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  },
                );
              } else {
                return ItemPageBody(
                  item: item,
                  user: snapshot.data.data,
                );
              }
              break;
            case Status.error:
              return ErrorPage(
                errorMessage: snapshot.data.message,
              );
          }
        }

        return Container();
      },
    );
  }
}

class ItemPageBody extends StatefulWidget {
  final ItemModel item;
  final UserModel user;

  const ItemPageBody({Key key, this.item, this.user}) : super(key: key);

  createState() {
    return ItemPageBodyState();
  }
}

class ItemPageBodyState extends State<ItemPageBody> {
  ItemModel item;
  UserModel user;
  Map<String, String> valor = Map();

  void initState() {
    super.initState();
    item = super.widget.item;
    user = super.widget.user;
  }

  final numberFormat = NumberFormat("###,##0.00", "en_US");

  Widget build(context) {
    int qty = 0;
    final ItemBloc itemBloc = ItemProvider.of(context);
    itemBloc.incQty(qty);
    itemBloc.getItemModifiers(item.codigo, user.idUser, user.tokenSesion);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Divider(),
          Center(
            //child: FadeInImage.assetNetwork(placeholder: constPlaceholderImage, image: item.imagen, height: 200,),
            child: CachedNetworkImage(
              imageUrl: item.imagen,
              placeholder: (context, url) => Image.asset(constPlaceholderImage),
              width: 300.0,
            ),
          ),
          Divider(),
          Center(
            child: Text(
              item.nombre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          Divider(),
          Center(
            child: Text(
              item.descripcion,
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          Center(
            child: Text(
              '$strMoneda ${numberFormat.format(item.precio)} $strDescUnidad',
            ),
          ),
          buidlModList(item, itemBloc),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: appTheme.accentColor)),
                  child: Icon(Icons.add),
                  onPressed: () {
                    itemBloc.incQty(qty);
                  },
                ),
                StreamBuilder(
                    stream: itemBloc.qtyStream,
                    builder: (context, snapshot) {
                      qty = snapshot.data;
                      return Text(
                        '     $qty     ',
                        style: TextStyle(
                          fontSize: 23.0,
                        ),
                      );
                    }),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: appTheme.accentColor)),
                  child: Icon(Icons.remove),
                  onPressed: () {
                    itemBloc.decQty(qty);
                  },
                ),
              ],
            ),
          ),
          Divider(),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: appTheme.accentColor)),
            child: Text(strCmdAddToCart),
            onPressed: () {
              List<String> modcods = [];
              List<String> modvals = [];

              valor.forEach((k, v) {
                modcods.add(k);
                modvals.add(v);
              });

              final CartLineModel line = CartLineModel(
                noLinea: DateTime.now().millisecondsSinceEpoch,
                noItem: item.codigo,
                itemDesc: item.nombre,
                qty: qty,
                precioPuntos: 0.0,
                precioUnitario: item.precio,
                totalPuntos: 0.0,
                totalLinea: qty * item.precio,
                codMod1: modcods.length >= 1 ? modcods[0] : '',
                descMod1: '',
                valMod1: modvals.length >= 1 ? modvals[0] : '',
                tipMod1: 0,
                preMod1: 0.0,
                ptsMod1: 0.0,
                codMod2: modcods.length >= 2 ? modcods[1] : '',
                descMod2: '',
                valMod2: modvals.length >= 2 ? modvals[1] : '',
                tipMod2: 0,
                preMod2: 0.0,
                ptsMod2: 0.0,
                codMod3: modcods.length >= 3 ? modcods[2] : '',
                descMod3: '',
                valMod3: modvals.length >= 3 ? modvals[2] : '',
                tipMod3: 0,
                preMod3: 0.0,
                ptsMod3: 0.0,
                codMod4: modcods.length >= 4 ? modcods[3] : '',
                descMod4: '',
                valMod4: modvals.length >= 4 ? modvals[3] : '',
                tipMod4: 0,
                preMod4: 0.0,
                ptsMod4: 0.0,
              );

              itemBloc.putCartLine(line);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget buidlModList(ItemModel item, ItemBloc itemBloc) {
    if (item.tieneModificadores == 1) {
      return StreamBuilder(
        stream: itemBloc.itemModStream,
        builder: (context,
            AsyncSnapshot<ApiResponse<List<ModifierModel>>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.loading:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case Status.completed:
                return buildDropDownButtons(snapshot.data.data);
              case Status.error:
                return Center(
                  child: Text(snapshot.data.message),
                );
            }
          }

          return Container();
        },
      );
    } else {
      return Container();
    }
  }

  Widget buildDropDownButtons(List<ModifierModel> modifiers) {
    List<Widget> wdgts = [];

    for (ModifierModel modi in modifiers) {
      valor.putIfAbsent(modi.code, () => modi.elementos[0].subCode);
      wdgts.add(McDropDown(
        label: modi.prompt,
        items: buildModifiersList(modi.elementos),
        onChanged: (value) {
          setState(() {
            valor.update(modi.code, (oldvalue) => value);
          });
        },
        value: valor[modi.code],
      ));
    }

    return Column(
      children: wdgts,
    );
  }
}

List<DropdownMenuItem<String>> buildModifiersList(
    List<ElementModel> elementos) {
  List<DropdownMenuItem<String>> items = [];
  for (ElementModel elemento in elementos) {
    items.add(DropdownMenuItem<String>(
      value: elemento.subCode,
      child: Text(elemento.description + (elemento.precioAdic != 0? ' ( + ' + elemento.precioAdic.toString() + ')': '')),
    ));
  }

  return items;
}
