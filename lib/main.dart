import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rydusuarios/authentication/login_screen.dart';
import 'package:rydusuarios/pages/home_page.dart';
// ignore_for_file: null_safety_features

import 'appInfo/app_info.dart';
import 'authentication/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBwfnkbQFV12uo7NqoGVxEzVdsDITWSJhM",
        appId: "1:1063046445442:android:ac47ddc6570f450fc6f79b",
        messagingSenderId: "1063046445442",
        projectId: "rydusuarios",
      ),
    );
    await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
      if(valueOfPermission){
        Permission.locationWhenInUse.request();
      }
    });
    runApp(MyApp());
  } catch (e) {
    // Manejar el error de inicialización de Firebase aquí
    print("Error al inicializar Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Flutter User App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : HomePage(),
      ),
    );
  }
}
