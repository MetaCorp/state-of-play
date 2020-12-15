import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';

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

    print('decoration.images: ' + widget.decoration.images.toString());
    print('decoration.imageFiles: ' + widget.decoration.imageFiles.toString());

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
      body: Column(
        children: [
          Text("Décoration: " + widget.decoration.type),
          Text("État"),
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
          ),
          TextField(
            controller: TextEditingController(text: widget.decoration.nature),
            decoration: InputDecoration(labelText: 'Nature'),
            onChanged: (value) => widget.decoration.nature = value,
          ),
          TextField(
            controller: TextEditingController(text: widget.decoration.comments),
            decoration: InputDecoration(labelText: 'Commentaires'),
            onChanged: (value) => widget.decoration.comments = value,
          ),
          MyImagePicker(
            onSelect: (imageFile) {
              widget.decoration.imageFiles.add(imageFile);
              setState(() { });
            },
          ),
          ImageList(
            images: widget.decoration.images != null ? widget.decoration.images : widget.decoration.imageFiles,
            type: widget.decoration.images != null ? "network" : "file",
          )
        ]
      ),
    );
  }
}