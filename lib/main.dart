import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agenda/ui/login_page.dart';
import 'package:agenda/ui/home_page.dart';
import 'package:agenda/ui/register_page.dart';
import 'package:agenda/ui/plantao_page.dart';
import 'package:agenda/ui/calendario_page.dart'; // Importação da página de calendário

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBRPdhzU4byfDYIQUHWVOcW2WvQpTWdhR0",
      authDomain: "agendanurse.firebaseapp.com",
      projectId: "agendanurse",
      storageBucket: "agendanurse.appspot.com",
      messagingSenderId: "1066684602187",
      appId: "1:1066684602187:web:74e1a80678ab8a052b7ace",
    ),
  );

  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;

  MyApp({this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Agenda Nurse",
      initialRoute: user != null ? "/home" : "/login",
      routes: {
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/calendar": (context) => CalendarioPage(), // ✅ Adicionado corretamente
        "/plantao": (context) => PlantaoPage(),
        "/login": (context) => LoginPage(),
      },
    );
  }
}
