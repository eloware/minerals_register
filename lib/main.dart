import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/user.dart';
import 'package:minerals_register/routes/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyApp.app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => LocalUser(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: Routes.Login,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}
