import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Sample _sample;
  Uint8List _image;
  bool _imageChanged = false;

  void _store(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    var imageName = widget.sample?.id;
    if (widget.sample?.id == null) {
      var reference = await FirebaseDatabase.instance
          .reference()
          .child(context.read<LocalUser>().samplePath)
          .push();
      if (_image != null) {
        _sample.imageName = reference.key;
        imageName = reference.key;
      }
      reference.set(_sample.toJson());
    } else {
      _sample.imageName = _image != null ? _sample.id : null;
      await FirebaseDatabase.instance
          .reference()
          .child(context.read<LocalUser>().samplePath)
          .child(widget.sample.id)
          .set(widget.sample.toJson());
    }

    await _saveImage(_image, imageName);

    Navigator.of(context).pop(Sample());
  }

  Future<bool> _saveImage(Uint8List imageData, String imageName) async {
    if (imageData == null)
      return true;

    var uploadTask = FirebaseStorage.instance
        .ref()
        .child(context.read<LocalUser>().userId)
        .child(imageName)
        .putData(imageData);

    await uploadTask.onComplete;
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.sample != null)
      _sample = widget.sample;
    else
      _sample = Sample();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sample?.serial ?? 'Neue Probe'),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _store(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                SampleImage(
                  imageName: widget.sample?.imageName,
                  canChange: true,
                  autoSave: true,
                  cancelChanges: () => _imageChanged = false,
                  changedImage: (image) {
                    _imageChanged = true;
                    _image = image;
                  },
                ),
                TextFormField(
                  onChanged: (v) => _sample.serial = v,
                  decoration: InputDecoration(labelText: 'Probennummer'),
                  initialValue: widget.sample?.serial ?? '',
                ),
                TextFormField(
                  onChanged: (v) => _sample.sampleNumber = v,
                  decoration: InputDecoration(labelText: 'Probennummer'),
                  initialValue: widget.sample?.sampleNumber ?? '',
                ),
                TextFormField(
                  onChanged: (v) => _sample.mineral = v,
                  decoration: InputDecoration(labelText: 'Mineral'),
                  initialValue: widget.sample?.mineral ?? '',
                ),
                TextFormField(
                  onChanged: (v) => _sample.sideMineral = v,
                  decoration: InputDecoration(labelText: 'Begeleitmineral'),
                  initialValue: widget.sample?.sideMineral ?? '',
                ),
                TextFormField(
                  onChanged: (v) => _sample.location = v,
                  decoration: InputDecoration(labelText: 'Fundort'),
                  initialValue: widget.sample?.location ?? '',
                ),
                TextFormField(
                  onChanged: (v) =>
                      _sample.timeStamp = Formats.dateFormat.parse(v),
                  validator: (value) {
                    if (!RegExp('^[0-9]{2}.[0-9]{2}.[0-9]{2,4}\$')
                        .hasMatch(value)) return 'Falsches Format';
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Datum'),
                  initialValue: Formats.dateFormat
                      .format(widget.sample?.timeStamp ?? DateTime.now()),
                ),
                TextFormField(
                  validator: (value) {
                    if (!RegExp('^[0-9]{0,}[,]{0,1}[0-9]{0,}\$')
                        .hasMatch(value)) return 'Falsches Format';
                    return null;
                  },
                  onChanged: (v) =>
                      _sample.value = Formats.doubleFormat.parse(v),
                  decoration: InputDecoration(labelText: 'Wert'),
                  initialValue:
                      Formats.doubleFormat.format(widget.sample?.value ?? 0.0),
                ),
                TextFormField(
                  onChanged: (v) => _sample.size = v,
                  decoration: InputDecoration(labelText: 'Größe'),
                  initialValue: widget.sample?.size ?? '',
                ),
                TextFormField(
                  onChanged: (v) => _sample.origin = v,
                  decoration: InputDecoration(labelText: 'Herkunft'),
                  initialValue: widget.sample?.origin ?? '',
                ),
                TextFormField(
                  onChanged: (v) => _sample.analytics = v,
                  decoration: InputDecoration(labelText: 'Analysemethode'),
                  initialValue: widget.sample?.analytics ?? '',
                ),
                TextFormField(
                  minLines: 10,
                  maxLines: 15,
                  onChanged: (v) => _sample.annotation = v,
                  decoration: InputDecoration(labelText: 'Bemerkung'),
                  initialValue: widget.sample?.annotation ?? '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
