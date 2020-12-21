import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef SelectCallback = void Function(File);

class MyImagePicker extends StatefulWidget {
  MyImagePicker({ Key key, this.onSelect, this.imagesCount }) : super(key: key);

  SelectCallback onSelect;
  int imagesCount;

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera, imageQuality: 50
    );

    // Uint8List bytes = await image.readAsBytes();

    widget.onSelect(image);
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );

    widget.onSelect(image);
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallerie'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Caméra'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {


    return Row(
      children: [
        Spacer(),
        Text(widget.imagesCount.toString() + '/5'),
        SizedBox(
          width: 16
        ),
        RaisedButton(
          color: Colors.grey[200],
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              Text('Ajouter une photo')
            ]
          ),
          onPressed: widget.imagesCount < 5 ? () => _showPicker(context) : null,
        ),
      ],
    );
  }
}