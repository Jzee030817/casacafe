import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:flutter/material.dart';

class McDropDown extends DropdownButton {
  final Function(dynamic) onChanged;
  final String label;
  final List<DropdownMenuItem<String>> items;
  final String value;

  McDropDown({this.label, this.items, this.onChanged, this.value});

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(label),
          DropdownButton(
            hint: Text(''),
            items: items,
            onChanged: onChanged,
            value: value,
          ),
        ],
      ),
      height: 80.0,
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: appTheme.primaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}
