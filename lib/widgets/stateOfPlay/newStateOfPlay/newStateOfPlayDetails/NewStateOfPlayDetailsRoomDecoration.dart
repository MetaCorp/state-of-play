import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';

class ImageType {
  ImageType({ this.type, this.image });

  String type;
  dynamic image;
}


class NewStateOfPlayDetailsRoomDecoration extends StatefulWidget {
  NewStateOfPlayDetailsRoomDecoration({ Key key, this.decoration, this.roomName }) : super(key: key);

  sop.Decoration decoration;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomDecorationState createState() => new _NewStateOfPlayDetailsRoomDecorationState();
}

class _NewStateOfPlayDetailsRoomDecorationState extends State<NewStateOfPlayDetailsRoomDecoration> {

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

  @override
  Widget build(BuildContext context) {

    // print('decoration.images: ' + widget.decoration.images.toString());
    // print('decoration.newImages: ' + widget.decoration.newImages.length.toString());

    List<ImageType> imagesType = widget.decoration.images.map((image) => ImageType(
      type: "network",
      image: image
    )).toList();

    for (var i = 0; i < widget.decoration.newImages.length; i++) {
      imagesType.add(ImageType(
        type: "file",
        image: widget.decoration.newImages[i]
      ));
    }

    // print('imagesType: ' + imagesType.toString());


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName + ' / ' + widget.decoration.type),
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
                  child: Text("État :")
                ),
                DropdownButton(
                  value: widget.decoration.state,
                  items: stateValues.map((stateValue) => DropdownMenuItem(
                    value: stateValue,
                    child: Text(stateValue)
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.decoration.state = value;
                    });
                  },
                )
              ]
            ),
            TextField(
              controller: TextEditingController(text: widget.decoration.nature),
              decoration: InputDecoration(labelText: 'Nature'),
              onChanged: (value) => widget.decoration.nature = value,
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: TextEditingController(text: widget.decoration.comments),
              decoration: InputDecoration(labelText: 'Commentaires'),
              onChanged: (value) => widget.decoration.comments = value,
            ),
            SizedBox(
              height: 16,
            ),
            MyImagePicker(
              onSelect: (imageFile) {
                widget.decoration.newImages.add(imageFile);
                setState(() { });
              },
              imagesCount: widget.decoration.images.length + widget.decoration.newImages.length
            ),
            ImageList(
              imagesType: imagesType,
              onDelete: (imageType) {
                if (imageType["type"] == "file")
                  widget.decoration.newImages.remove(imageType["image"]);
                else
                  widget.decoration.images.remove(imageType["image"]);
                setState(() {});  
              },
            )
          ]
        ),
      ),
    );
  }
}