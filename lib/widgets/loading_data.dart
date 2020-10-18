import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {

  final String text;

  const LoadingData({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [CircularProgressIndicator(),
      SizedBox(height: 20,),
        Text(text ?? 'Lade Daten...')
      ],
    ),
  );
}
