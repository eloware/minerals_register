import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/sample.dart';
import 'package:minerals_register/models/user.dart';
import 'package:minerals_register/services/formats.dart';
import 'package:minerals_register/widgets/sample_image.dart';
import 'package:provider/provider.dart';

class EditSamplePage extends StatefulWidget {
  final Sample sample;

  EditSamplePage({Key key, this.sample}) : super(key: key);

  @override
  _EditSamplePageState createState() => _EditSamplePageState();
}

class _EditSamplePageState extends State<EditSamplePage> {
  final _formKey = GlobalKey<FormState>();

  String _id;
  String _serial;
  String _mineral;
  String _location;
  String _timeStamp;
  String _value;
  String _origin;
  String _size;
  String _annotation;
  String _sideMineral;
  String _imageName;
  String _geoLocation;
  String _analytics;
  String _sampleNumber;


  void _store(BuildContext context) async {
    return;

    if (widget.sample.id == null)
      await FirebaseDatabase.instance
          .reference()
          .child(context.read<LocalUser>().samplePath)
          .push()
          .set(widget.sample.toJson());
    else
      await FirebaseDatabase.instance
          .reference()
          .child(context.read<LocalUser>().samplePath)
          .child(widget.sample.id)
          .set(widget.sample.toJson());

    Navigator.of(context).pop(Sample());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sample?.serial ?? 'Neue Probe'),
        actions: [
          IconButton(icon: Icon(Icons.cancel),onPressed: ()=>Navigator.of(context).pop(),),
          IconButton(icon: Icon(Icons.save),onPressed: ()=>_store(context),),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                    SizedBox(height: 8,),
                    SampleImage(imageName: widget.sample?.imageName, canChange: true, changedImage: (_){},),
                TextFormField(onChanged: (v)=>_serial = v, decoration: InputDecoration(labelText: 'Probennummer'),initialValue: widget.sample?.serial ?? '',),
                TextFormField(onChanged: (v)=>_sampleNumber = v, decoration: InputDecoration(labelText: 'Probennummer'),initialValue: widget.sample?.sampleNumber ?? '',),
                TextFormField(onChanged: (v)=>_mineral = v, decoration: InputDecoration(labelText: 'Mineral'),initialValue: widget.sample?.mineral ?? '',),
                TextFormField(onChanged: (v)=>_sideMineral = v, decoration: InputDecoration(labelText: 'Begeleitmineral'),initialValue: widget.sample?.sideMineral ?? '',),
                TextFormField(onChanged: (v)=>_location = v, decoration: InputDecoration(labelText: 'Fundort'),initialValue: widget.sample?.location ?? '',),
                TextFormField(onChanged: (v)=>_timeStamp = v, decoration: InputDecoration(labelText: 'Datum'),initialValue: Formats.dateFormat.format(widget.sample?.timeStamp ?? DateTime.now()),),
                TextFormField(onChanged: (v)=>_value = v, decoration: InputDecoration(labelText: 'Wert'),initialValue: Formats.doubleFormat.format(widget.sample?.value ?? 0.0),),
                TextFormField(onChanged: (v)=>_size = v, decoration: InputDecoration(labelText: 'Größe'),initialValue: widget.sample?.size ?? '',),
                TextFormField(onChanged: (v)=>_origin = v, decoration: InputDecoration(labelText: 'Herkunft'),initialValue: widget.sample?.origin ?? '',),
                TextFormField(onChanged: (v)=>_analytics = v, decoration: InputDecoration(labelText: 'Analysemethode'),initialValue: widget.sample?.analytics ?? '',),
                TextFormField(
                  minLines: 10,
                  maxLines: 15,
                  onChanged: (v)=>_annotation = v, decoration: InputDecoration(labelText: 'Bemerkung'),initialValue: widget.sample?.annotation ?? '',),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
