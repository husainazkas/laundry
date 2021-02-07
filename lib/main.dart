import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry/injector/injector.dart';
import 'package:laundry/ui/main_page/account.dart';
import 'package:laundry/ui/main_page/history.dart';
import 'package:laundry/ui/main_page/home.dart';
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
      home: _auth.currentUser != null ? Home() : Login(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/home': (context) => Home(),
        '/history': (context) => History(),
        '/account': (context) => Account(),
      },
    );
  }
}
