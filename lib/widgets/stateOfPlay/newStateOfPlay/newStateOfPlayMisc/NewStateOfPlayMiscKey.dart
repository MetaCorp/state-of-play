import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageType {
  ImageType({ this.type, this.image });

  String type;
  dynamic image;
}

class NewStateOfPlayMiscKey extends StatefulWidget {
  NewStateOfPlayMiscKey({ Key key, this.sKey }) : super(key: key);

  sop.Key sKey;

  @override
  _NewStateOfPlayMiscKeyState createState() => new _NewStateOfPlayMiscKeyState();
}

class _NewStateOfPlayMiscKeyState extends State<NewStateOfPlayMiscKey> {
  final _formKey = GlobalKey<FormState>();
  Uuid uuid = Uuid();


  Future<String> getFilePath() async {

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/NewStateOfPlay/MiscKey/${uuid.v1()}.png';

    return filePath;
  }

  _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    // print('sKey.state: ' + widget.sKey.state);

    List<ImageType> imagesType = widget.sKey.images.map((image) => ImageType(
      type: "network",
      image: image
    )).toList();

    for (var i = 0; i < widget.sKey.newImages.length; i++) {
      imagesType.add(ImageType(
        type: "file",
        image: widget.sKey.newImages[i]
      ));
    }
    
    return WillPopScope(
      onWillPop: () async => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Clés / ' + widget.sKey.type),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _onSave,
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 16),
                      child: Text("Quantité :")
                    ),
                    Flexible(
                      child: SpinBox(
                        min: 1,
                        max: 100,
                        value: widget.sKey.quantity.toDouble(),
                        onChanged: (value) => widget.sKey.quantity = value.toInt(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  initialValue: widget.sKey.comments,
                  decoration: InputDecoration(labelText: 'Commentaires'),
                  onSaved: (value) => widget.sKey.comments = value,
                  maxLength: 256,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 16,
                ),
                MyImagePicker(
                  isMultiSelection : true,
                  onSelect: (imageFile) {
                    widget.sKey.newImages.add(imageFile);
                    setState(() { });
                  },
                  imagesCount: widget.sKey.images.length + widget.sKey.newImages.length
                ),
                ImageList(
                  imagesType: imagesType,
                  onDelete: (imageType) {
                    if (imageType["type"] == "file")
                      widget.sKey.newImages.remove(imageType["image"]);
                    else
                      widget.sKey.images.remove(imageType["image"]);
                    setState(() {});  
                  },
                  onUpdate: (image, index) async {
                    print("FILEPATH:");

                    File file = await File(await getFilePath()).create(recursive: true).then((file) => file.writeAsBytes(image));
                    print("FILEPATH:"+file.path);

                    //TODO FINISH
                    if(index < widget.sKey.images.length){   
                      print("index"+index.toString());
                      widget.sKey.images.removeAt(index);
                      widget.sKey.newImages.add(file);
                    } 
                    else {
                      print("Else index" + index.toString());
                      index -= widget.sKey.images.length;
                      widget.sKey.newImages[index] = file;
                    }  
                    setState(() {});  
                  },
                )
              ]
            ),
          ),
        )
      ),
    );
  }
}