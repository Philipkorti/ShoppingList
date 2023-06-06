import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:einkaufsliste_app/config.dart';
import 'package:einkaufsliste_app/models/shopping_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShoppingItemListScreen extends StatefulWidget {
  const ShoppingItemListScreen({super.key});

  @override
  State<ShoppingItemListScreen> createState() => _ShoppingItemListScreen();
}

class _ShoppingItemListScreen extends State<ShoppingItemListScreen> {
  void _showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  List shoppingList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Shopping List'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: FutureBuilder(
        future: getAllProducts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data[index];
                  return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Navigator.pushNamed(context, '/add',
                                  arguments: ShoppingItem(
                                    name: item.name,
                                    done: item.done,
                                    id: item.id,
                                  )).then((value) => setState(() {}));
                            },
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                deletItem(item);
                              });
                              _showSnackbar(context, '${item.name} deleted.');
                            },
                            icon: Icons.delete,
                            label: 'Delete',
                          )
                        ],
                      ),
                      child: CheckboxListTile(
                          title: Text(item.name),
                          value: item.done,
                          onChanged: (newValue) {
                            setState(() {
                              item.setDone(newValue);
                              updateItem(item);
                            });
                          }));
                });
          }
        },
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add',
                      arguments: ShoppingItem(
                          name: '', done: false, id: DateTime.now().toString()))
                  .then((value) => setState(() {}));
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 12,
        ),
      ]),
    );
  }

  Future getAllProducts() async {
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

  Future<void> updateItem(ShoppingItem items) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('user')
        .doc(currentUser!.uid)
        .collection('products')
        .doc(items.id)
        .update(items.toMap());
  }

  Future<void> deletItem(ShoppingItem items) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('user')
        .doc(currentUser!.uid)
        .collection('products')
        .doc(items.id)
        .delete();
  }
}
