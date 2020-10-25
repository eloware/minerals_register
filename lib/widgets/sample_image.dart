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
  final Function() cancelChanges;

  SampleImage(
      {Key key, this.imageName, this.canChange = false, this.changedImage, this.cancelChanges})
      : super(key: key) {
    if (canChange && (changedImage == null || cancelChanges == null))
      throw 'canChange requires changeImage and cancelChanges function';
  }

  @override
  _SampleImageState createState() => _SampleImageState();
}

class _SampleImageState extends State<SampleImage> {
  Uint8List _image;
  bool _hasChanged = false;

  Future<void> _removeImage(BuildContext context) async{
    await Future.delayed(Duration(seconds: 1));

    widget.changedImage(null);
    setState((){
      _image = null;
      _hasChanged = true;
    });
  }

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
    setState(() {
      _image = imageData;
      _hasChanged = true;
    });
    if (widget.changedImage != null) widget.changedImage(imageData);
  }

  Widget _getImageWidget(){
    if (_hasChanged && _image == null || (!_hasChanged && widget.imageName == null))
      return  Icon(Icons.image_not_supported_outlined, size: 80,);

    if (_hasChanged || widget.imageName == null)
      return Image.memory(_image);

    return _FirestoreImage(imageName: widget.imageName);
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
              child: _getImageWidget(),
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
        if (widget.canChange)
          Positioned(
            right: 10,
            bottom: 40,
            child: IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () => _removeImage(context),
            ),
          ),
        if (widget.canChange)
          Positioned(
            right: 10,
            bottom: 70,
            child: IconButton(
              icon: Icon(Icons.undo),
              onPressed: ()=>setState(()=>_hasChanged = false),
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
                      loadingProgress == null
                          ? child
                          : CircularProgressIndicator(),
                );
              return CircularProgressIndicator();
            },
          );
  }
}
