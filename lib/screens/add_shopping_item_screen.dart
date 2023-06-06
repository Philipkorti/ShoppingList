import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:einkaufsliste_app/models/shopping_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class AddShoppingItemScreen extends StatefulWidget {
  const AddShoppingItemScreen({Key? key}) : super(key: key);

  @override
  _AddShoppingItemScreenState createState() => _AddShoppingItemScreenState();
}

class _AddShoppingItemScreenState extends State<AddShoppingItemScreen> {
  TextEditingController _textEditingController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final editedShoppingItem =
        ModalRoute.of(context)!.settings.arguments as ShoppingItem;

    bool inEditMode = editedShoppingItem.name.isNotEmpty;

    if (inEditMode) {
      _textEditingController.text = editedShoppingItem.name;
    }

    return Scaffold(
      appBar:
          AppBar(title: Text(inEditMode ? 'update Product' : 'Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Product name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (inEditMode) {
                  ShoppingItem newShoppingItem = editedShoppingItem.copyWith(
                    name: _textEditingController.text,
                  );
                  await updateItem(newShoppingItem);
                } else {
                  final FirebaseFirestore _firestore =
                      FirebaseFirestore.instance;
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  ShoppingItem newItem = ShoppingItem(
                    name: _textEditingController.text,
                    done: false,
                    id: DateTime.now().toString(),
                  );

                  final currentUser = _auth.currentUser;

                  await _firestore
                      .collection('user')
                      .doc(currentUser!.uid)
                      .collection('products')
                      .doc(newItem.id)
                      .set(newItem.toMap());
                }
                Navigator.pop(context);
              },
              child: Text(inEditMode ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateItem(ShoppingItem item) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('user')
        .doc(currentUser!.uid)
        .collection('products')
        .doc(item.id)
        .update(item.toMap());
  }
}
