import 'package:flutter/material.dart';
import '../blocs/user_provider.dart';
import '../config/app_strings.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';

class SignupPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strLabelSignup),
      ),
      body: SignupBody(),
    );
  }
}

class SignupBody extends StatefulWidget {
  createState() {
    return SignupBodyState();
  }
}

class SignupBodyState extends State<SignupBody> {
  String eml = '';
  String nam = '';

  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              constCdcLogoTransparent,
            ),
            emailField(bloc),
            namesField(bloc),
            submitButton(bloc),
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

  Widget namesField(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailstream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (value) {
            bloc.changeNames(value);
            setState(() {
              nam = value;
            });
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Nombre",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget submitButton(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitSignupValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text(strLabelSubmit),
          onPressed: snapshot.data ?? false
              ? () {
                  bloc.submitSignup(eml, nam);
                  _showSignupDialog(bloc);
                }
              : null,
        );
      },
    );
  }

  void _showSignupDialog(UserBloc bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login'),
          content: signupResult(bloc),
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

  Widget signupResult(UserBloc bloc) {
    return StreamBuilder<ApiResponse<UserModel>>(
      stream: bloc.sessionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return LinearProgressIndicator();
            case Status.completed:
              return Text('Bienvenido ${snapshot.data.data.nombre}');
            case Status.error:
              return Text(snapshot.data.message);
          }
        }

        return Text('');
      },
    );
  }
}
