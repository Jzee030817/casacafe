import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:fl_ax_cdc/screens/error_page.dart';
import 'package:flutter/material.dart';
import '../blocs/user_bloc.dart';
import '../blocs/user_provider.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';
import '../screens/loading_page.dart';
import '../screens/login_page.dart';
import '../screens/restricted_page.dart';
import '../config/app_strings.dart';

class UserPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strLabelUser),
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
                return UserBody(
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

class UserBody extends StatefulWidget {
  final UserModel user;

  const UserBody({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserBodyState();
  }
}

class UserBodyState extends State<UserBody> {
  UserModel user;
  TextEditingController txtctrlnom;
  TextEditingController txtctrleml;
  TextEditingController txtctrlcta;
  TextEditingController txtctrlpts;

  void initState() {
    super.initState();
    user = super.widget.user;
    print(user.nombre);
    print(user.idUser);
    txtctrlnom = TextEditingController(text: user.nombre);
    txtctrleml = TextEditingController(text: user.idUser);
    txtctrlcta = TextEditingController(text: user.numTarjeta);
    txtctrlpts = TextEditingController(text: user.puntos.toString());
  }

  Widget build(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(''),
                        Text(
                          user.nombre,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(user.correo,
                          style: TextStyle(  
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  height: 70.0,
                ),
              ],
            ),
            height: 70.0,
            decoration: BoxDecoration(  
              color: appTheme.primaryColor, 
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            ),
          ),
          Container( 
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0,),
            child: TextField( 
              controller: txtctrlnom,
              decoration: InputDecoration(  
                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
                labelText: 'Nombre',
              ),
              enabled: false,
            ),
          ),
          Container( 
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, ),
            child: TextField( 
              controller: txtctrleml,
              decoration: InputDecoration(  
                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
                labelText: 'Correo eletronico', 
              ),
              enabled: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0), 
            child: TextField( 
              controller: txtctrlcta,
              decoration: InputDecoration(  
                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
                labelText: 'Numero de cuenta', 
              ),
              enabled: false,
            ),
          ),
          Container( 
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextField( 
              controller: txtctrlpts,
              decoration: InputDecoration(  
                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: appTheme.primaryColor)),
                labelText: 'Puntos acumulados'
              ),
              enabled: false,
            ),
          ),
          Container( 
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: RaisedButton( 
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              child: Text('Cambiar Contraseña'),
              onPressed: () {
                Navigator.of(context).pushNamed('/PwdChange');
              },
            ),
          ),
        ],
      ),
    );
  }
}
