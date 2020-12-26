import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef SelectCallback = void Function(File);

class LogoPicker extends StatefulWidget {
  LogoPicker({ Key key, this.onSelect, this.logo, this.newLogo }) : super(key: key);

  SelectCallback onSelect;
  String logo;
  File newLogo;

  @override
  _LogoPickerState createState() => _LogoPickerState();
}

class _LogoPickerState extends State<LogoPicker> {

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera, imageQuality: 50
    );

    if(image == null)
      return;

    widget.onSelect(image);
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );
    if(image == null)
      return;
      
    widget.onSelect(image);
  }

  @override
  Widget build(BuildContext context) {

    print('LogoPicker logo: ' + widget.logo.toString());
    print('LogoPicker newLogo: ' + widget.newLogo.toString());
    print('');

    return Row(
      children: [
        widget.newLogo != null ? Image.file(
          widget.newLogo,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ) : widget.logo != null ? Image.network(
          widget.logo,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ) : Container(),
        SizedBox(
          width: 16
        ),
        RaisedButton(
          color: Colors.grey[200],
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 8),
              Text('Choisir un logo')
            ]
          ),
          onPressed: () => _imgFromCamera(),
        ),
      ],
    );
  }
}