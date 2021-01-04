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

    debugPrint('LogoPicker logo: ' + widget.logo.toString());
    debugPrint('LogoPicker newLogo: ' + widget.newLogo.toString());
    debugPrint('');

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        widget.newLogo != null ? Image.file(
          widget.newLogo,
          width: 170,
          height: 170,
          fit: BoxFit.cover,
        ) : widget.logo != null ? Image.network(
          widget.logo,
          width: 170,
          height: 170,
          fit: BoxFit.cover,
        ) : Container(), 
        Container(
          width: 170,
          child: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () =>  {
              _imgFromGallery(),        
            }
          )
          //   RaisedButton(
          //     color: Colors.grey[200],
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.camera_alt),
          //         SizedBox(width: 8),
          //         Text('Choisir un logo')
          //       ]
          //     ),
          //   onPressed: () =>  {
          //     _imgFromGallery(),        
          //   }
          // ),
        ),
      ],
    );
  }
}