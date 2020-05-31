import 'package:flutter/material.dart';
import '../blocs/user_provider.dart';
import '../config/app_strings.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';

class LoginPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strLabelLogin),
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  createState() {
    return LoginBodyState();
  }
}

class LoginBodyState extends State<LoginBody> {
  String eml = '';
  String pwd = '';
  bool retry = false;
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20.0),
        color: Color(0xDBD1C2) ,
        child: Column(
          children: <Widget>[
            Image.asset(
              constCdcLogoTransparent,
            ),
            emailField(bloc),
            passwordField(bloc),
            Divider(),
            submitButton(bloc),
            resetPassword(bloc),
          ],
        ),
      ),
    );
  }

  Widget emailField(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailstream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (value) {
            bloc.changeEmail(value);
            setState(() {
              eml = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: "nombre@servidor.com",
            labelText: "Direccion Email",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwstream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (value) {
            bloc.changePassw(value);
            setState(() {
              pwd = value;
            });
          },
          obscureText: true,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: "Clave",
            labelText: "Clave",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget submitButton(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitLoginValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text(strLabelLogin),
          onPressed: snapshot.data ?? false
              ? () {
                  bloc.submitLogin(eml, pwd);
                  _showLoginDialog(bloc);
                }
              : null,
        );
      },
    );
  }

  Widget resetPassword(UserBloc bloc) {
    return FlatButton(
      child: Text(strLabelForget),
      onPressed: eml == ''
          ? null
          : () {
              _showResetDialog(bloc);
            },
    );
  }

  void _showResetDialog(UserBloc bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strLabelForget),
          content: Text(
              'Se enviará un correo a la direccion $eml con las instrucciones para restablecer la contraseña.'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                bloc.submitPwdReset(eml);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(UserBloc bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login'),
          content: loginResult(bloc),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
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

  Widget loginResult(UserBloc bloc) {
    return StreamBuilder<ApiResponse<UserModel>>(
      stream: bloc.sessionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              retry = false;
              return LinearProgressIndicator();
            case Status.completed:
              retry = false;
              return Text('Bienvenido ${snapshot.data.data.nombre}');
            case Status.error:
              retry = true;
              return Text(snapshot.data.message);
          }
        }

        return Text('');
      },
    );
  }
}
