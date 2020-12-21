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

class NewStateOfPlayMiscKey extends StatefulWidget {
  NewStateOfPlayMiscKey({ Key key, this.sKey }) : super(key: key);

  sop.Key sKey;

  @override
  _NewStateOfPlayMiscKeyState createState() => new _NewStateOfPlayMiscKeyState();
}

class _NewStateOfPlayMiscKeyState extends State<NewStateOfPlayMiscKey> {

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
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Clés / ' + widget.sKey.type),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
            TextField(
              controller: TextEditingController(text: widget.sKey.comments),
              decoration: InputDecoration(labelText: 'Commentaires'),
              onChanged: (value) => widget.sKey.comments = value,
            ),
            SizedBox(
              height: 16,
            ),
            MyImagePicker(
              onSelect: (imageFile) {
                widget.sKey.newImages.add(imageFile);
                setState(() { });
              },
            ),
            ImageList(
              imagesType: imagesType,
              onDelete: (imageType) {
                if (imageType["type"] == "file")
                  widget.sKey.newImages.remove(imageType["image"]);
                else
                  widget.sKey.images.remove(imageType["image"]);
                setState(() {});  
              }
            )
          ]
        ),
      )
    );
  }
}