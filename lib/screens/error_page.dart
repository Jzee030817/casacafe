import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const ErrorPage({Key key, this.errorMessage, this.onRetryPressed})
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
              //color: Colors.grey,
              fontSize: 12,
              //fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          RaisedButton(
            color: Colors.lightGreen,
            child: Text(
              'Reintentar',
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
