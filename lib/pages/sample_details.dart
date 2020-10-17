import 'package:flutter/material.dart';
import 'package:minerals_register/models/sample.dart';

class SampleDetailsPage extends StatelessWidget {

  final Sample sample;

  const SampleDetailsPage({Key key, this.sample}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sample.serial),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(sample.mineral),
          ],
        ),
      ),
    );
  }
}
