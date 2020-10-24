import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/sample.dart';
import 'package:minerals_register/models/user.dart';
import 'package:minerals_register/routes/routes.dart';
import 'package:minerals_register/services/formats.dart';
import 'package:provider/provider.dart';

class SampleDetailsPage extends StatelessWidget {
  final Sample sample;

  const SampleDetailsPage({Key key, this.sample}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userId = context.watch<LocalUser>().userId;
    return Scaffold(
      appBar: AppBar(
        title: Text(sample.serial),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(Routes.EditSample, arguments: sample),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sample.imageName != null)
                Container(
                  height: MediaQuery.of(context).size.width * .75,
                  child: Center(
                    child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child(userId)
                          .child(sample.imageName)
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Image.network(
                            snapshot.data,
                             loadingBuilder: (context, child, loadingProgress) =>
                             loadingProgress == null ?    child : CircularProgressIndicator(),

                          );
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              HeadLinedText(text: sample.serial, headline: 'Probennummer'),
              HeadLinedText(text: sample.mineral, headline: 'Mineral'),
              HeadLinedText(
                  text: sample.sideMineral, headline: 'Begleitmineral'),
              HeadLinedText(text: sample.location, headline: 'Fundort'),
              HeadLinedText(
                  text: sample.timeStamp != null
                      ? Formats.dateFormat.format(sample.timeStamp)
                      : '',
                  headline: 'Datum'),
              HeadLinedText(
                  text: sample.value != null
                      ? Formats.currencyFormat.format(sample.value)
                      : '',
                  headline: 'Wert'),
              HeadLinedText(text: sample.size, headline: 'Größe'),
              HeadLinedText(text: sample.origin, headline: 'Herkunft'),
              HeadLinedText(text: sample.annotation, headline: 'Bemerkung'),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadLinedText extends StatelessWidget {
  final String headline;
  final String text;

  const HeadLinedText({Key key, this.headline, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline ?? '',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            text ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      );
}
