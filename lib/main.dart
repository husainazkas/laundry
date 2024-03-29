import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry/storage/storage.dart';
import 'package:laundry/ui/main_page/bottom_navbar.dart';
import 'package:laundry/ui/login.dart';
import 'package:laundry/ui/register.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    await setupLocator();

    runApp(MyApp());
  } catch (error, stacktrace) {
    print('$error, $stacktrace');
  }
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Laundry",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _auth.currentUser != null ? BottomNavBar() : Login(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/bottom_navbar': (context) => BottomNavBar(),
      },
    );
  }
}
