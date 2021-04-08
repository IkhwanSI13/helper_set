import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDropdownDivider<T> extends PopupMenuEntry<T> {
  @override
  _DropdownDividerState<T> createState() => _DropdownDividerState<T>();

  @override
  double get height => 1.0;

  @override
  bool represents(T? value) => false;
}

class _DropdownDividerState<T> extends State<MyDropdownDivider<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(height: 1.0, color: Colors.grey.shade400),
    );
  }
}
