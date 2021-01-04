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

class NewStateOfPlayDetailsRoomEquipment extends StatefulWidget {
  NewStateOfPlayDetailsRoomEquipment({ Key key, this.equipment, this.roomName }) : super(key: key);

  sop.Equipment equipment;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomEquipmentState createState() => new _NewStateOfPlayDetailsRoomEquipmentState();
}

class _NewStateOfPlayDetailsRoomEquipmentState extends State<NewStateOfPlayDetailsRoomEquipment> {
  final _formKey = GlobalKey<FormState>();

  final List<String> stateValues = ['Neuf', 'Très Bon', 'Bon', 'Moyen', 'Mauvais', 'Défaillant'];
  Uuid uuid = Uuid();


  Future<String> getFilePath() async {

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/NewStateOfPlay/RoomEquipment/${uuid.v1()}.png';

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

    // debugPrint('equipment.state: ' + widget.equipment.state);

    List<ImageType> imagesType = widget.equipment.images.map((image) => ImageType(
      type: "network",
      image: image
    )).toList();

    for (var i = 0; i < widget.equipment.newImages.length; i++) {
      imagesType.add(ImageType(
        type: "file",
        image: widget.equipment.newImages[i]
      ));
    }

    return WillPopScope(
      onWillPop: () async => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.roomName + ' / ' + widget.equipment.type),
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
                      value: widget.equipment.state,
                      items: stateValues.map((stateValue) => DropdownMenuItem(
                        value: stateValue,
                        child: Text(stateValue)
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          widget.equipment.state = value;
                        });
                      },
                    )
                  ]
                ),
                MyTextFormField(
                  initialValue: widget.equipment.brandOrObject,
                  decoration: InputDecoration(labelText: 'Marque/Objet'),
                  onSaved: (value) => widget.equipment.brandOrObject = value,
                  maxLength: 24,
                ),
                SizedBox(
                  height: 16,
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
                        value: widget.equipment.quantity.toDouble(),
                        onChanged: (value) => widget.equipment.quantity = value.toInt(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  initialValue: widget.equipment.comments,
                  decoration: InputDecoration(labelText: 'Commentaires'),
                  onSaved: (value) => widget.equipment.comments = value,
                  maxLength: 256,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 16,
                ),
                MyImagePicker(
                  isMultiSelection : true,
                  onSelect: (imageFile) {
                    widget.equipment.newImages.add(imageFile);
                    setState(() { });
                  },
                  imagesCount: widget.equipment.images.length + widget.equipment.newImages.length
                ),
                ImageList(
                  imagesType: imagesType,
                  onDelete: (imageType) {
                    if (imageType["type"] == "file")
                      widget.equipment.newImages.remove(imageType["image"]);
                    else
                      widget.equipment.images.remove(imageType["image"]);
                    setState(() {});  
                  },
                  onUpdate: (image, index) async {
                    debugPrint("FILEPATH:");

                    File file = await File(await getFilePath()).create(recursive: true).then((file) => file.writeAsBytes(image));
                    debugPrint("FILEPATH:"+file.path);

                    //TODO FINISH
                    if(index < widget.equipment.images.length){   
                      debugPrint("index"+index.toString());
                      widget.equipment.images.removeAt(index);
                      widget.equipment.newImages.add(file);
                    } 
                    else {
                      debugPrint("Else index" + index.toString());
                      index -= widget.equipment.images.length;
                      widget.equipment.newImages[index] = file;
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