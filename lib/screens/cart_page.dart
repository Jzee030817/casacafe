import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_ax_cdc/blocs/item_bloc.dart';
import 'package:fl_ax_cdc/blocs/item_provider.dart';
import 'package:fl_ax_cdc/blocs/user_provider.dart';
import 'package:fl_ax_cdc/config/app_strings.dart';
import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:fl_ax_cdc/models/cartline_model.dart';
import 'package:fl_ax_cdc/models/user_model.dart';
import 'package:fl_ax_cdc/resources/api_response.dart';
import 'package:fl_ax_cdc/screens/checkout_page.dart';
import 'package:fl_ax_cdc/screens/error_page.dart';
import 'package:fl_ax_cdc/screens/loading_page.dart';
import 'package:fl_ax_cdc/screens/login_page.dart';
import 'package:fl_ax_cdc/screens/restricted_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  final String title;

  CartPage({this.title});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ApiUserWrapper(),
    );
  }
}

class ApiUserWrapper extends StatelessWidget {
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
                loadingMessage: "Recuperando orden...",
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
                return ApiCartWrapper();
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

class ApiCartWrapper extends StatelessWidget {
  Widget build(BuildContext context) {
    final ItemBloc itemBloc = ItemProvider.of(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;
    itemBloc.getCartLines();
    double temptot = 0;

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
                double subtotal = 0;
                List<CartLineModel> cart = snapshot.data.data;
                cart.forEach((linea) => subtotal += linea.totalLinea);
                temptot = subtotal * 100;
                subtotal = temptot.round() / 100;

                return Column(
                  children: <Widget>[
                    Container(
                      height: deviceHeight - 165,
                      child: cartList(context, itemBloc, snapshot.data.data),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(children: <Widget>[
                        RaisedButton(
                          color: appTheme.primaryColor,
                          textColor: appTheme.backgroundColor,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'PAGAR US\$ $subtotal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CheckoutPage(
                                title: strCheckoutPage,
                              );
                            }));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                        ),
                        Text('Elimine productos de la canasta deslizando hacia los lados...', 
                          style: TextStyle(fontSize: 10),
                        ),
                      ],),
                    ),
                  ],
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

  Widget cartList(
      BuildContext context, ItemBloc itemBloc, List<CartLineModel> cart) {
    double deviceWidth = MediaQuery.of(context).size.width;
    print(deviceWidth);
    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (context, int index) {
        final CartLineModel crline = cart[index];
        final numberFormat = NumberFormat('###,##0.00', 'en_US');

        return Dismissible(
          key: Key(crline.noLinea.toString()),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            itemBloc.removeCartLine(crline.noLinea);
          },
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      margin: EdgeInsets.only(right: 10.0),
                      //child: FadeInImage.assetNetwork(placeholder: constPlaceholderImage, image: crline.imageUrl),
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                        imageUrl: crline.imageUrl,
                        placeholder: (context, url) =>
                            Image.asset(constPlaceholderImage),
                      ),
                    ),
                    //),
                    Container(
                      width: deviceWidth -
                          100 -
                          120 -
                          20, // Ultimo 20 es margenes y padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${crline.itemDesc}   (${crline.qty})',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          crline.descMod1 == ''
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Text(
                                  '- ${crline.descMod1}',
                                  style: TextStyle(
                                    color: appTheme.primaryColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                          crline.descMod2 == ''
                              ? Container(
                                  height: 0,
                                  width: 0,
                                )
                              : Text(
                                  '- ${crline.descMod2}',
                                  style: TextStyle(
                                    color: appTheme.primaryColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                          crline.descMod3 == ''
                              ? Container(
                                  height: 0,
                                  width: 0,
                                )
                              : Text(
                                  '- ${crline.descMod3}',
                                  style: TextStyle(
                                    color: appTheme.primaryColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                          crline.descMod4 == ''
                              ? Container(
                                  height: 0,
                                  width: 0,
                                )
                              : Text(
                                  '- ${crline.descMod4}',
                                  style: TextStyle(
                                    color: appTheme.primaryColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      width: 110.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '$strMoneda ${numberFormat.format(crline.totalLinea)}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: appTheme.primaryColor,
                              fontSize: 18.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
