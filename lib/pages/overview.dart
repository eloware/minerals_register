import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minerals_register/models/sample.dart';
import 'package:minerals_register/routes/routes.dart';

class OverviewPage extends StatelessWidget {
  final List<Sample> samples;

  const OverviewPage({Key key, this.samples}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd.MM.yyyy');
    var currencyFormat = NumberFormat.currency(locale: 'de_DE');

    return Scaffold(
      appBar: AppBar(title: Text("Sammlung"),),
      body: ListView(
        children: this.samples.map((e) => ListTile(
          title: Text('${e.serial} - ${e.mineral}'),
          subtitle: Text('Gefunden ${e.location} am ${dateFormat.format(e.timeStamp)}'),
          trailing: Text('${currencyFormat.format(e.value)}'),
          onTap: ()=>Navigator.of(context).pushNamed(Routes.Details, arguments: e),
        )).toList(),
      ),
    );
  }
}
