import 'package:flutter/material.dart';
import 'item_bloc.dart';
export 'item_bloc.dart';

class ItemProvider extends InheritedWidget {
  final ItemBloc bloc;

  ItemProvider({Key key, Widget child})
      : bloc = ItemBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static ItemBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ItemProvider>()).bloc;
  }
}
