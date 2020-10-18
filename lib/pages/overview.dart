import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minerals_register/models/sample.dart';
import 'package:minerals_register/models/user.dart';
import 'package:minerals_register/routes/routes.dart';
import 'package:minerals_register/widgets/loading_data.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatelessWidget {
  Future<void> _addSample(BuildContext context) async {
    var sample =
        (await Navigator.of(context).pushNamed(Routes.EditSample)) as Sample;
    if (sample == null) return;

    await FirebaseDatabase.instance
        .reference()
        .child(context.read<LocalUser>().samplePath)
        .push().set(sample.toJson());
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd.MM.yyyy');
    var currencyFormat = NumberFormat.currency(locale: 'de_DE');
    var samplePath = context.watch<LocalUser>().samplePath;
    return Scaffold(
        appBar: AppBar(
          title: Text("Sammlung"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async => await _addSample(context),
            )
          ],
        ),
        drawer: Drawer(
          child: Text('Menü...'),
        ),
        body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child('users/$samplePath/samples')
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container();
            }

            return LoadingData(
              text: 'Lade Sammlung...',
            );
          },
        ));
  }
}

class _SampleListTile extends StatelessWidget {
  final Sample sample;

  const _SampleListTile({Key key, this.sample}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sample.serial),
      onTap: () =>
          Navigator.of(context).pushNamed(Routes.Details, arguments: sample),
    );
  }
}
