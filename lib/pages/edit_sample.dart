import 'package:flutter/material.dart';
import 'package:minerals_register/models/sample.dart';

class EditSamplePage extends StatelessWidget {

  final Sample sample;

  const EditSamplePage({Key key, this.sample}) : super(key: key);

  void _store(BuildContext context){
    Navigator.of(context).pop(Sample());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sample?.serial ?? 'Neue Probe'),),
      body: Container(),
    );
  }
}
