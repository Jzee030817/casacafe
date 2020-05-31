import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/creditcard_model.dart';
import '../models/pedido_model.dart';
import '../blocs/item_bloc.dart';
import '../blocs/item_provider.dart';
import '../blocs/user_bloc.dart';
import '../blocs/user_provider.dart';
import '../config/app_strings.dart';
import '../config/app_style.dart';
import '../models/store_model.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';
import '../screens/error_page.dart';
import '../screens/loading_page.dart';
import '../screens/login_page.dart';
import '../screens/restricted_page.dart';
import '../models/cartline_model.dart';

class CheckoutPage extends StatelessWidget {
  final String title;
  final List<CartLineModel> cart;

  CheckoutPage({this.title, this.cart});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: userWrapper(context),
    );
  }

  Widget userWrapper(BuildContext context) {
    final UserBloc userBloc = UserProvider.of(context);
    userBloc.restoreSession();

    return StreamBuilder<ApiResponse<UserModel>>(
      stream: userBloc.sessionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return Loading(loadingMessage: snapshot.data.message);
            case Status.completed:
              if (snapshot.data.data.idUser == "") {
                return RestrictedPage(
                  errorMessage:
                      "Debe iniciar sesion para acceder a esta pagina",
                  onRetryPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  },
                );
              } else {
                return storesWrapper(context, snapshot.data.data);
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

  Widget storesWrapper(BuildContext context, UserModel user) {
    final ItemBloc itemBloc = ItemProvider.of(context);
    itemBloc.getStoresList();

    return StreamBuilder<ApiResponse<List<StoreModel>>>(
      stream: itemBloc.storeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
            case Status.completed:
              if (snapshot.data.data.length != 0) {
                return buildBody(context, user, snapshot.data.data);
              }
              return noStores();
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

  Widget buildBody(
      BuildContext context, UserModel user, List<StoreModel> stores) {
    final ItemBloc itemBloc = ItemProvider.of(context);

    return StreamBuilder<ApiResponse<List<CartLineModel>>>(
      stream: itemBloc.cartStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
            case Status.completed:
              if (snapshot.data.data.length != 0) {
                return CheckOut(
                  cart: snapshot.data.data,
                  stores: stores,
                  user: user,
                );
              }
              return emptyCart();
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

  Widget emptyCart() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            'No hay productos en la canasta...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget noStores() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            'No hay tiendas disponibles...',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class CheckOut extends StatefulWidget {
  final List<CartLineModel> cart;
  final List<StoreModel> stores;
  final UserModel user;

  const CheckOut({Key key, this.cart, this.stores, this.user})
      : super(key: key);

  createState() {
    return CheckOutState();
  }
}

class CheckOutState extends State<CheckOut> {
  List<CartLineModel> cart;
  List<StoreModel> stores;
  List<RadioModel> formasPago = [];
  UserModel user;
  var numberFormat = NumberFormat('###,##0.00', 'en_US');

  String selectedStore;
  String instrucciones;
  TimeOfDay horaRecoger = TimeOfDay.now();
  int formaPago;
  String ultDigitos;
  String numAutorizacion;

  double subtotal = 0;
  double subpuntos = 0;

  String nomCard ;
  String numCard ;
  String mmmCard ;
  String yyyCard ;
  String cvcCard ;
  CreditCardModel ccData;

  void initState() {
    super.initState();
    cart = super.widget.cart;
    user = super.widget.user;
    stores = super.widget.stores;
    formasPago = [];
    // Para la API, las formas de pago validas son:
    // 1 - Tarjeta de Credito
    // 2 - Puntos
    // 3 - Monedero
    // 4 - efectivo
    formasPago.add(RadioModel(false, true, 'Efectivo', 4));
    formasPago.add(RadioModel(false, true, 'Puntos', 2));
    formasPago.add(RadioModel(false, true, 'Tarjeta', 1));

    if (stores.length != 0) selectedStore = stores[0].codTienda;
    formaPago = 0;
    numCard = '';
    nomCard = '';
    mmmCard = '';
    yyyCard = '';
    cvcCard = '';
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: horaRecoger,
    );

    if (picked != null && picked != horaRecoger) {
      setState(() {
        horaRecoger = picked;
      });
    }
  }

  bool datosCompletos(String selectedStore, double subTotal, int formaPago,
      String numAutorizacion, String ultDigitos) {
    if (selectedStore == '') return false;
    if (subtotal <= 0) return false;
    if (formaPago <= 0) return false;

    return true;
  }

  String verificarPedido(
      List<CartLineModel> cart,
      String selectedStore,
      String instrucciones,
      TimeOfDay horaRecoger,
      int formaPago,
      String numAutorizacion,
      String ultDigitos, 
      String nombreTarj, 
      String mesTarjeta,
      String yyyTarjeta,
      String cvcTarjeta) {
    bool mixedItems;
    String mensaje = '';

    if (formaPago == 2) {
      mixedItems = cart.any((ele) => ele.precioPuntos == 0.0);
      if (mixedItems)
        mensaje =
            "Metodo de pago seleccionado es puntos, pero hay items en la canasta que no aplican para este medio de pago...";
    }

    if (formaPago == 1 && ultDigitos == '' && nombreTarj == '' && mesTarjeta == '' && yyyTarjeta == '' && cvcTarjeta == '') {
      mensaje = 'Metodo de pago es tarjeta pero no se proporciono los datos...';
    }

    mensaje =
        (selectedStore == '') ? 'Por favor seleccione tienda...' : mensaje;

    return mensaje;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  void showOrderSendingPanel(
      List<CartLineModel> cart,
      String selectedStore,
      String instrucciones,
      TimeOfDay horaRecoger,
      int formaPago,
      String numAutorizacion,
      String ultDigitos,
      double totalOrden,
      double totalPuntos, 
      String nameOnCard, 
      String numberCard, 
      String monthCard, 
      String yearCard,
      String _cvcCard) {
    final ItemBloc itemBloc = ItemProvider.of(context);
    itemBloc.sendOrder(user, cart, selectedStore, instrucciones, horaRecoger,
        formaPago, totalOrden, totalPuntos, nameOnCard, numberCard, monthCard, 
        yearCard, _cvcCard);

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (builder) {
          return StreamBuilder(
            stream: itemBloc.poStream,
            builder:
                (context, AsyncSnapshot<ApiResponse<PedidoDetail>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.loading:
                    return Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text('Enviando Orden...'),
                      ],
                    );
                  case Status.completed:
                    if (snapshot.data.data.noPedido != 0) {
                      itemBloc.removeOrder();
                      return Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                        children: <Widget>[
                            Text('Orden enviada exitosamente.', 
                              style: TextStyle(  
                                color: appTheme.primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(''),
                            Text(
                                'Su Numero de Orden es ${snapshot.data.data.noPedido}',
                              style: TextStyle(  
                                color: appTheme.primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(''),
                            Text(
                                'Se envio un correo de confirmacion a su direccion de email.',
                              style: TextStyle(  
                                color: appTheme.primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(''),
                            RaisedButton(
                              child: Text('Cerrar'),
                              onPressed: () {
                                //itemBloc.removeOrder();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        Text(snapshot.data.message),
                        RaisedButton(
                          child: Text('Reintentar'),
                          onPressed: () {
                            // Eliminar productos de orden (Y pasar a historial en proxima version)
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  case Status.error:
                    return ErrorPage(
                      //errorMessage: 'Error enviando orden o procesando pago. Intente nuevamente o cambie metodo de pago',
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => Navigator.of(context).pop(),
                    );
                }
              }

              return Container();
            },
          );
        });
  }

  Widget build(context) {
    subtotal = 0;
    subpuntos = 0;
    cart.forEach((linea) => subtotal += linea.totalLinea);
    cart.forEach((linea) => subpuntos += linea.totalPuntos);
    UserBloc bloc = UserProvider.of(context);
    double devwdt = MediaQuery.of(context).size.width;
    double txtwdt = (devwdt - 20 - 40) / 3;

    print('Tienda: $selectedStore');
    print('Total : $subtotal');
    print('F Pago: $formaPago');
    print('Autori: $numAutorizacion');
    print('Tarjet: $ultDigitos');

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Divider(
            height: 5.0,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: appTheme.primaryColor, width: 2.0)),
              child: Text(
                strLabelTotalOrder +
                    strMoneda +
                    ' ' +
                    numberFormat.format(subtotal),
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Divider(
            height: 5.0,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(strLabelSelectStore),
                  DropdownButton(
                    hint: Text(''),
                    items: buildStoresList(stores),
                    onChanged: (value) {
                      setState(() {
                        selectedStore = value;
                      });
                    },
                    value: selectedStore,
                  ),
                ],
              ),
              height: 80.0,
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: appTheme.primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          Divider(
            height: 5.0,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    instrucciones = value;
                  });
                },
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: strLabelInstructions,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Divider(
            height: 5.0,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('CAMBIAR HORA A RECOGER'),
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                  Text(
                    '    ${formatTimeOfDay(horaRecoger)}',
                    style: TextStyle(
                      color: appTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: 357.0,
              alignment: Alignment.center,
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: appTheme.primaryColor, width: 2.0)),
              child: Column(
                children: <Widget>[
                  Text('Seleccione su forma de pago'),
                  Divider(),
                  Container(
                    height: 80.0,
                    child: metodosPago(formasPago),
                  ),
                  Column(  
                    children: <Widget>[
                      namFieldCC(bloc),
                      Text(''),
                      nnnFieldCC(bloc),
                      Text(''),
                      Row(children: <Widget>[
                        Container(
                          width: txtwdt, 
                          child: mmmFieldCC(bloc)
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: txtwdt, 
                          child: yyyFieldCC(bloc)
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: txtwdt, 
                          child: cvcFieldCC(bloc)
                        ),
                      ],),
                      //Text(''),
                      //btnSubmitCC(bloc),
                    ],
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
            child: Text('ENVIAR ORDEN'),
            onPressed: datosCompletos(selectedStore, subtotal, formaPago,
                    numAutorizacion, ultDigitos)
                ? () {
                    final mensaje = verificarPedido(
                        cart,
                        selectedStore,
                        instrucciones,
                        horaRecoger,
                        formaPago,
                        numAutorizacion,
                        numCard, nomCard, mmmCard, yyyCard, cvcCard);
                    if (mensaje == '') {
                      showOrderSendingPanel(
                          cart,
                          selectedStore,
                          instrucciones,
                          horaRecoger,
                          formaPago,
                          numAutorizacion,
                          ultDigitos,
                          subtotal,
                          subpuntos, 
                          nomCard, 
                          numCard, 
                          mmmCard, 
                          yyyCard, 
                          cvcCard);
                    } else {
                      // Hay un error en el pedido, el error esta en mensaje
                      _showDialog('Error', mensaje, () {
                        Navigator.of(context).pop();
                      });
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget namFieldCC(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.nameoncardstr,
      builder: (context, snapshot) {
        return TextField( 
          onChanged: (value) {
            bloc.changeCardName(value);
            setState(() {
              nomCard = value;
            });
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          decoration: InputDecoration(  
            hintText: 'Nombre en la tarjeta',
            labelText: 'Nombre en la tarjeta', 
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget nnnFieldCC(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.cardnumberstr,
      builder: (context, snapshot) {
        return TextField( 
          onChanged: (value) {
            bloc.changeCardNumb(value);
            setState(() {
              numCard = value;
            });
          },
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(  
            hintText: 'Numero de la tarjeta',
            labelText: 'Numero de la tarjeta', 
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget mmmFieldCC(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.cardmonthdstr,
      builder: (context, snapshot) {
        return TextField( 
          onChanged: (value) {
            bloc.changeCardMont(value);
            setState(() {
              mmmCard = value;
            });
          },
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(  
            hintText: 'Mes',
            labelText: 'Mes Exp', 
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget yyyFieldCC(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.cardyeardustr,
      builder: (context, snapshot) {
        return TextField( 
          onChanged: (value) {
            bloc.changeCardYear(value);
            setState(() {
              yyyCard = value;
            });
          },
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(  
            hintText: 'Año',
            labelText: 'Año Exp', 
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget cvcFieldCC(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.cvconcardstrm,
      builder: (context, snapshot) {
        return TextField( 
          onChanged: (value) {
            bloc.changeCardCvc(value);
            setState(() {
              cvcCard = value;
            });
          },
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(  
            hintText: 'Codigo CVC',
            labelText: 'Codigo CVC', 
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget btnSubmitCC(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitCardData,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text(strLabelSubmit),
          onPressed: snapshot.data ?? false
              ? () {
                  bloc.submitCCData(nomCard, numCard, mmmCard, yyyCard, cvcCard);
                }
              : null,
        );
      },
    );
  }

  void _showDialog(String title, String content, Function ok) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: ok,
            ),
          ],
        );
      },
    );
  }

  Widget metodosPago(List<RadioModel> formasPago) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: formasPago.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          splashColor: Colors.blueAccent,
          onTap: () async {
            setState(() {
              formasPago.forEach((f) => f.isSelected = false);
              formasPago[index].isSelected = true;

              //if (formaPago == 0) 
                formaPago = formasPago[index].codigoForma;
            });

            if (formaPago == 1) {
              // Solicitar datos de tarjeta de credito
            }
          },
          child: RadioItem(formasPago[index]),
        );
      },
    );
  }
}

List<DropdownMenuItem<String>> buildStoresList(List<StoreModel> lista) {
  List<DropdownMenuItem<String>> items = [];
  for (StoreModel ele in lista) {
    items.add(DropdownMenuItem<String>(
      value: ele.codTienda,
      child: Text(ele.nomTienda),
    ));
  }

  return items;
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);

  Widget build(BuildContext context) {
    final double wide = MediaQuery.of(context).size.width;
    return Container(
      height: 50.0,
      width: (wide - 26) / 3, // 26 para descontar margenes, 2 total de opciones
      child: Center(
        child: Text(
          _item.radioText,
          style: TextStyle(
            color: _item.isSelected ? Colors.white : Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
        border: Border.all(
            width: 1.0,
            color: _item.isSelected ? Colors.blueAccent : Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  bool isEnabled;
  final String radioText;
  int codigoForma;

  RadioModel(this.isSelected, this.isEnabled, this.radioText, this.codigoForma);
}
