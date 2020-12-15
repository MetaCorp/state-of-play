import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';

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

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

  @override
  Widget build(BuildContext context) {

    // print('equipment.state: ' + widget.equipment.state);

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName + ' / ' + widget.equipment.type),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Text("Décoration: " + widget.equipment.type),
          Text("État"),
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
          ),
          TextField(
            controller: TextEditingController(text: widget.equipment.brandOrObject),
            decoration: InputDecoration(labelText: 'Marque/Objet'),
            onChanged: (value) => widget.equipment.brandOrObject = value,
          ),
          SpinBox(
            min: 1,
            max: 100,
            value: widget.equipment.quantity.toDouble(),
            onChanged: (value) => widget.equipment.quantity = value.toInt(),
          ),
          TextField(
            controller: TextEditingController(text: widget.equipment.comments),
            decoration: InputDecoration(labelText: 'Commentaires'),
            onChanged: (value) => widget.equipment.comments = value,
          ),
          MyImagePicker(
            onSelect: (imageFile) {
              widget.equipment.newImages.add(imageFile);
              setState(() { });
            },
          ),
          ImageList(
            imagesType: imagesType,
          )
        ]
      ),
    );
  }
}