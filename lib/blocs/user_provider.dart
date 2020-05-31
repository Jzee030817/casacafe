import 'package:flutter/material.dart';
import 'user_bloc.dart';
export 'user_bloc.dart';

class UserProvider extends InheritedWidget {
  final UserBloc bloc;

  UserProvider({Key key, Widget child})
      : bloc = UserBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static UserBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<UserProvider>()).bloc;
  }
}
