// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:einkaufsliste_app/models/shopping_item.dart';

class Configuration extends InheritedWidget {
  final List<ShoppingItem> shoppingList;
  Configuration({
    required this.shoppingList,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(Configuration oldWidget) {
    return shoppingList != oldWidget.shoppingList;
  }
}
