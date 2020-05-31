import 'package:flutter/material.dart';

class Page404 extends StatelessWidget {
  final String title;

  Page404({this.title});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
