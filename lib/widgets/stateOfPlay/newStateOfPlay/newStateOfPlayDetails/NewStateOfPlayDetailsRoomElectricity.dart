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

class NewStateOfPlayDetailsRoomElectricity extends StatefulWidget {
  NewStateOfPlayDetailsRoomElectricity({ Key key, this.electricity, this.roomName }) : super(key: key);

  sop.Electricity electricity;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomElectricityState createState() => new _NewStateOfPlayDetailsRoomElectricityState();
}

class _NewStateOfPlayDetailsRoomElectricityState extends State<NewStateOfPlayDetailsRoomElectricity> {
  
  final _formKey = GlobalKey<FormState>();

  final List<String> stateValues = ['Neuf', 'Très Bon', 'Bon', 'Moyen', 'Mauvais', 'Défaillant'];
  Uuid uuid = Uuid();


  Future<String> getFilePath() async {

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/NewStateOfPlay/RoomElectricity/${uuid.v1()}.png';

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

    // print('electricity.state: ' + widget.electricity.state);

    List<ImageType> imagesType = widget.electricity.images.map((image) => ImageType(
      type: "network",
      image: image
    )).toList();

    for (var i = 0; i < widget.electricity.newImages.length; i++) {
      imagesType.add(ImageType(
        type: "file",
        image: widget.electricity.newImages[i]
      ));
    }


    return WillPopScope(
      onWillPop: () => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.roomName + ' / ' + widget.electricity.type),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _onSave
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
                      child: Text("État :")
                    ),
                    DropdownButton(
                      value: widget.electricity.state,
                      items: stateValues.map((stateValue) => DropdownMenuItem(
                        value: stateValue,
                        child: Text(stateValue)
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          widget.electricity.state = value;
                        });
                      },
                    ),
                  ]
                ),
                SizedBox(
                  height: 8,
                ),
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
                        value: widget.electricity.quantity.toDouble(),
                        onChanged: (value) => widget.electricity.quantity = value.toInt(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  initialValue: widget.electricity.comments,
                  decoration: InputDecoration(labelText: 'Commentaires'),
                  onSaved: (value) => widget.electricity.comments = value,
                  maxLength: 256,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 16,
                ),
                MyImagePicker(
                  isMultiSelection : true,
                  onSelect: (imageFile) {
                    widget.electricity.newImages.add(imageFile);
                    setState(() { });
                  },
                  imagesCount: widget.electricity.images.length + widget.electricity.newImages.length
                ),
                ImageList(
                  imagesType: imagesType,
                  onDelete: (imageType) {
                    if (imageType["type"] == "file")
                      widget.electricity.newImages.remove(imageType["image"]);
                    else
                      widget.electricity.images.remove(imageType["image"]);
                    setState(() {});  
                  },
                  onUpdate: (image, index) async {
                    print("FILEPATH:");

                    File file = await File(await getFilePath()).create(recursive: true).then((file) => file.writeAsBytes(image));
                    print("FILEPATH:"+file.path);

                    //TODO FINISH
                    if(index < widget.electricity.images.length){   
                      print("index"+index.toString());
                      widget.electricity.images.removeAt(index);
                      widget.electricity.newImages.add(file);
                    } 
                    else {
                      print("Else index" + index.toString());
                      index -= widget.electricity.images.length;
                      widget.electricity.newImages[index] = file;
                    }  
                    setState(() {});  
                  },
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}