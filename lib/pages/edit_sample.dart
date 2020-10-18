import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/sample.dart';
import 'package:minerals_register/models/user.dart';
import 'package:provider/provider.dart';

class EditSamplePage extends StatelessWidget {
  final Sample sample;

  const EditSamplePage({Key key, this.sample}) : super(key: key);

  void _store(BuildContext context) async {
    if (sample.id == null)
      await FirebaseDatabase.instance
          .reference()
          .child(context.read<LocalUser>().samplePath)
          .push()
          .set(sample.toJson());
    else await FirebaseDatabase.instance
        .reference()
        .child(context.read<LocalUser>().samplePath)
        .child(sample.id)
        .set(sample.toJson());

    Navigator.of(context).pop(Sample());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sample?.serial ?? 'Neue Probe'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
