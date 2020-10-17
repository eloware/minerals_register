import 'package:flutter/material.dart';
import 'package:minerals_register/routes/routes.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                onPressed: () {
                  print('Login with ${_usernameController.text}:${_passwordController.text}');
                  Navigator.of(context).pushReplacementNamed(Routes.Overview);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
