import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/user.dart';
import 'package:minerals_register/routes/routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    try {
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);

      if (user != null) {
        context.read<LocalUser>().firebaseCredential = user;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.Overview, (route) => false);
      }
    } on FirebaseAuthException catch (ex) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Fehler'),
                content: Text('Fehler bei der Anmeldung ${ex.message}'),
                actions: [
                  OutlineButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterLogo(size: 100.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Mail-Adresse'),
                autocorrect: false,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Passwort'),
                obscureText: true,
              ),
              RaisedButton(
                onPressed: () => _login(context),
                child: Text('Login'),
              ),
              FlatButton(
                child: Text(
                  'Neu hier...',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => Navigator.of(context).pushNamed(Routes.SignUp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
