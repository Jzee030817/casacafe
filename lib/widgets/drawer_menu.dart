import 'package:flutter/material.dart';
import '../blocs/user_provider.dart';
import '../config/app_strings.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';

class DrawerMenu extends StatelessWidget {
  Widget build(context) {
    final bloc = UserProvider.of(context);

    return StreamBuilder<ApiResponse<UserModel>>(
        stream: bloc.sessionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data.data;

            if (user != null) {
              if (user.idUser == '') {
                return ListView(
                  children: <Widget>[
                    Image.asset(
                      constCoffeBeansImage,
                      color: Colors.green[900],
                      colorBlendMode: BlendMode.xor,
                    ),
                    ListTile(
                      title: Text(strLabelStores),
                      leading: Icon(Icons.store),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/store');
                      },
                    ),
                    ListTile(
                      title: Text(strLabelLogin),
                      leading: Icon(Icons.lock_open),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                    ListTile(
                      title: Text(strLabelSignup),
                      leading: Icon(Icons.group_add),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ],
                );
              } else {
                return ListView(
                  children: <Widget>[
                    Image.asset(
                      constCoffeBeansImage,
                      color: Colors.green[900],
                      colorBlendMode: BlendMode.xor,
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(user.nombre),
                      subtitle: Text(user.idUser),
                    ),
                    ListTile(
                      title: Text(strLabelStores),
                      leading: Icon(Icons.store),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/store');
                      },
                    ),
                    ListTile(
                      title: Text(strLabelProfile),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/user');
                      },
                    ),
                    ListTile(
                      title: Text(strLabelCart),
                      leading: Icon(Icons.shopping_basket),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    ListTile(
                      title: Text('Cerrar sesion'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {
                        bloc.closeSession();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            }
          }

          return Container();
        });
  }
}
