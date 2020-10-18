import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/user.dart';
import 'package:minerals_register/routes/routes.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _RegistrationInformation {
  String name = '';
  String mailAddress = '';
  String password = '';
  String passwordRepeat = '';
  bool license = false;
  bool privacy = false;
}

class _SignUpPageState extends State<SignUpPage> {
  final _RegistrationInformation _registration = _RegistrationInformation();
  final _formKey = GlobalKey<FormState>();
  static const String MailRegex =
      '[a-z0-9!#\$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?';

  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    if (!(_registration.privacy && _registration.license)) {
      await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                titlePadding: EdgeInsets.all(8.0),
                contentPadding: EdgeInsets.all(8.0),
                title: Text('Nicht möglich'),
                children: [
                  Text(
                      'Sie müssen die Lizenzbestimmungen und die Datenschutzvereinbarung akzeptieren um forzufahren'),
                  OutlineButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
      return;
    }

    if (_registration.password != _registration.passwordRepeat) {
      return;
    }

    UserCredential user;
    try {
      user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registration.mailAddress, password: _registration.password);
      context.read<LocalUser>().firebaseCredential = user;
    } on FirebaseAuthException catch (ex) {
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                titlePadding: EdgeInsets.all(8.0),
                contentPadding: EdgeInsets.all(8.0),
                title: Text('User anlegen'),
                children: [
                  Text('Fehlgeschlagen'),
                  Text(ex.message),
                ],
              ));

      return;
    }

    if (user == null)
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                titlePadding: EdgeInsets.all(8.0),
                contentPadding: EdgeInsets.all(8.0),
                title: Text('User anlegen'),
                children: [Text('Fehlgeschlagen')],
              ));
    else
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.Overview, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Willkommen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) => _registration.name = value,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                validator: (value) => RegExp(MailRegex).hasMatch(value)
                    ? null
                    : 'Keine gültige Mailadresse',
                onChanged: (value) => _registration.mailAddress = value,
                decoration: InputDecoration(labelText: 'Mailadresse'),
              ),
              TextFormField(
                onChanged: (value) => _registration.password = value,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                validator: (value) => value == _registration.password
                    ? null
                    : 'Passwörter stimmen nicht überein',
                onChanged: (value) => _registration.passwordRepeat = value,
                decoration: InputDecoration(labelText: 'Password wdh'),
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dateschutz akzeptieren'),
                  Switch(
                    value: _registration.privacy,
                    onChanged: (value) =>
                        setState(() => _registration.privacy = value),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lizenz akzeptieren'),
                  Switch(
                    value: _registration.license,
                    onChanged: (value) =>
                        setState(() => _registration.license = value),
                  )
                ],
              ),
              RaisedButton(
                child: Text('Anmelden'),
                onPressed: () async => await _register(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
