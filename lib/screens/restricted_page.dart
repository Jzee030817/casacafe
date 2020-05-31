import 'package:flutter/material.dart';

class RestrictedPage extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const RestrictedPage({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.brown[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          RaisedButton(
            color: Colors.lightGreen,
            child: Text(
              'Ingresar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: onRetryPressed,
          ),
        ],
      ),
    );
  }
}
