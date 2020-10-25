import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minerals_register/models/user.dart';
import 'package:provider/provider.dart';

class SampleImage extends StatefulWidget {
  final String imageName;
  final bool canChange;
  final Function(Uint8List) changedImage;

  SampleImage({Key key, this.imageName, this.canChange = false, this.changedImage})
      : super(key: key);

  @override
  _SampleImageState createState() => _SampleImageState();
}

class _SampleImageState extends State<SampleImage> {
  Uint8List _image;

  bool get _hasChanged => _image != null;

  Future<void> _changeImage(BuildContext context) async {
    ImageSource result = await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Quelle wählen'),
              actions: [
                FlatButton(
                  child: Text('Kamera'),
                  onPressed: () =>
                      Navigator.of(context).pop(ImageSource.camera),
                ),
                FlatButton(
                  child: Text('Galerie'),
                  onPressed: () =>
                      Navigator.of(context).pop(ImageSource.gallery),
                ),
                FlatButton(
                  child: Text('Abbrechen'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
    if (result == null) return;

    var image = await ImagePicker().getImage(source: result);
    var imageData = await image.readAsBytes();
    setState(() => _image = imageData);
    if (widget.changedImage != null)
      widget.changedImage(imageData);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.width * .75,
            width: MediaQuery.of(context).size.width * .75,
            child: Center(
              child: _hasChanged
                  ? Image.memory(_image)
                  : _FirestoreImage(imageName: widget.imageName),
            ),
          ),
        ),
        if (widget.canChange)
          Positioned(
            right: 10,
            bottom: 10,
            child: IconButton(
              icon: Icon(CupertinoIcons.camera),
              onPressed: () => _changeImage(context),
            ),
          ),
      ],
    );
  }
}

class _FirestoreImage extends StatelessWidget {
  final String imageName;

  const _FirestoreImage({Key key, this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseStorage.instance
          .ref()
          .child(context.watch<LocalUser>().userId)
          .child(imageName)
          .getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Image.network(
            snapshot.data,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null ? child : CircularProgressIndicator(),
          );
        return CircularProgressIndicator();
      },
    );
  }
}
