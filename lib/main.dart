import 'package:einkaufsliste_app/screens/add_shopping_item_screen.dart';
import 'package:einkaufsliste_app/screens/auth_gate.dart';
import 'package:einkaufsliste_app/screens/shopping_item_list_screen.dart';
import 'package:einkaufsliste_app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/shopping_item.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

List<ShoppingItem>? products;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/add': (context) => const AddShoppingItemScreen(),
        '/list': (context) => const ShoppingItemListScreen(),
        '/signup': (context) => const SignUp(),
      },
    );
  }
}
