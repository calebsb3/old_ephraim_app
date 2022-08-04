// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ItemModel {
  String title;
  String databaseName;
  int changeAmount;
  IconData iconToDisplay;

  ItemModel(
      {required this.title,
      required this.databaseName,
      required this.changeAmount,
      required this.iconToDisplay});
}
