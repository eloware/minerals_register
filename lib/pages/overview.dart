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
  }

  @override
  Widget build(BuildContext context) {
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
          stream:
              FirebaseDatabase.instance.reference().child(samplePath).onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var sample = Sample.listFromDb(snapshot);
              return ListView.builder(
                itemCount: sample.length,
                itemBuilder: (context, index) => _SampleListTile(
                  sample: sample[index],
                ),
              );
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
  final dateFormat = DateFormat('dd.MM.yyyy');
  final currencyFormat = NumberFormat.currency(locale: 'de_DE');

  _SampleListTile({Key key, this.sample}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${sample.serial} - ${sample.mineral}'),
      subtitle: Text(
          'Gefunden ${sample.location ?? '💁‍♂️'} am ${sample.timeStamp != null ? dateFormat.format(sample.timeStamp) : 'Keine Angabe'}'),
      trailing: Text(sample.value != null
          ? currencyFormat.format(sample?.value ?? 0)
          : '<na>'),
      onTap: () =>
          Navigator.of(context).pushNamed(Routes.Details, arguments: sample),
    );
  }
}
