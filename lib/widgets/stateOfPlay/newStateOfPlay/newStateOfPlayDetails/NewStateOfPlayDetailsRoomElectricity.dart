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

class NewStateOfPlayDetailsRoomElectricity extends StatefulWidget {
  NewStateOfPlayDetailsRoomElectricity({ Key key, this.electricity, this.roomName }) : super(key: key);

  sop.Electricity electricity;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomElectricityState createState() => new _NewStateOfPlayDetailsRoomElectricityState();
}

class _NewStateOfPlayDetailsRoomElectricityState extends State<NewStateOfPlayDetailsRoomElectricity> {

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

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


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName + ' / ' + widget.electricity.type),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
            TextField(
              controller: TextEditingController(text: widget.electricity.comments),
              decoration: InputDecoration(labelText: 'Commentaires'),
              onChanged: (value) => widget.electricity.comments = value,
            ),
            SizedBox(
              height: 16,
            ),
            MyImagePicker(
              onSelect: (imageFile) {
                widget.electricity.newImages.add(imageFile);
                setState(() { });
              },
            ),
            ImageList(
              imagesType: imagesType,
            )
          ]
        ),
      ),
    );
  }
}