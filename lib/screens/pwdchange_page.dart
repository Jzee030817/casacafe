import 'package:fl_ax_cdc/blocs/user_provider.dart';
import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:fl_ax_cdc/models/pedido_model.dart';
import 'package:fl_ax_cdc/models/user_model.dart';
import 'package:fl_ax_cdc/resources/api_response.dart';
import 'package:flutter/material.dart';

import 'error_page.dart';
import 'loading_page.dart';
import 'login_page.dart';
import 'restricted_page.dart';

class PwdchangePage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(  
      appBar: AppBar( 
        title: Text('Cambiar contraseña'),
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
              return Loading(
                loadingMessage: 'Cargando datos de usuario...',
              );
            case Status.completed:
              if (snapshot.data.data.idUser == '') {
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
                return PwdchangeBody(
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

class PwdchangeBody extends StatefulWidget {
  final UserModel user;

  const PwdchangeBody({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PwdchangeBodyState();
  }
}

class PwdchangeBodyState extends State<PwdchangeBody> {
  UserModel user;
  String oldpwd;
  String newpwd;
  String cnfpwd;

  void initState() {
    super.initState();
    user = super.widget.user;
  }

  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return SingleChildScrollView(  
      child: Container( 
        margin: EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          currpwdField(bloc),
          newpwdField(bloc),
          confpwdField(bloc),
          submitButton(bloc, user),
        ],),
      ),
    );
  }

  Widget currpwdField(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.pwdchangeOld,
      builder: (context, snapshot) {
        return TextField(  
          onChanged: (value) {
            bloc.changeOldpwd(value);
            setState(() {
              oldpwd = value;
            });
          },
          obscureText: true,
          decoration: InputDecoration(  
            labelText: 'Clave actual',
            border: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        );
      }, 
    );
  }

  Widget newpwdField(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.pwdchangeNew, 
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.only(top: 20.0),
          child: TextField( 
          onChanged: (value) {
            bloc.changeNewpwd(value);
            setState(() {
              newpwd = value;
            });
          },
          obscureText: true,
          decoration: InputDecoration(  
            labelText: 'Clave nueva',
            border: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
          ),
        );
      }, 
    );
  }

  Widget confpwdField(UserBloc bloc) {
    return StreamBuilder( 
      stream: bloc.pwdchangeConf,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.only(top: 20.0),
          child: TextField( 
          onChanged: (value) {
            bloc.changeConfpwd(value);
            setState(() {
              cnfpwd = value;
            });
          },
          obscureText: true,
          decoration: InputDecoration(  
            labelText: 'Confimer clave',
            border: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
        );
      },
    );
  }

  Widget submitButton(UserBloc bloc, UserModel user) {
    return StreamBuilder( 
      stream: bloc.submitChangeValid,
      builder: (context, snapshot) {
        return RaisedButton( 
          child: Text('Enviar'),
          onPressed: snapshot.data ?? false
              ? () {
                  bloc.submitChangePwd(user.idUser, user.tokenSesion, oldpwd, newpwd);
                  _showChangeDialog(bloc);
                }
              : null,
        );
      },
    );
  }

  void _showChangeDialog(UserBloc bloc) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(  
          title: Text('Cambio contraseña'),
          content: changepwdResult(bloc),
          actions: <Widget>[
            FlatButton( 
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget changepwdResult(UserBloc bloc) {
    return StreamBuilder<ApiResponse<PedidoResult>>( 
      stream: bloc.changepwdStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return LinearProgressIndicator();
            case Status.completed:
              return Text('Exito');
            case Status.error:
              return Text('Error. Reintente.');
          }
        }

        return Text('Error. Reintente.');
      }, 
    );
  }
}