import 'package:flutter/material.dart';

Widget TextDefault(String value, {bool bold}) {
  return Text(
    value ?? "",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}
