import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:einkaufsliste_app/models/shopping_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'login_screen.dart';
import 'shopping_item_list_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginWidget();
          }
          return const ShoppingItemListScreen();
        });
  }

  Future<List<ShoppingItem>> getAllProducts() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final currentUser = _auth.currentUser;
    final productsItem = await _firestore
        .collection('user')
        .doc(currentUser!.uid)
        .collection('products')
        .orderBy('done')
        .get();
    return productsItem.docs
        .map((docs) => ShoppingItem.fromMap(docs.data()))
        .toList();
  }
}
