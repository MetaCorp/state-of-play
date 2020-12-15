import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';

class ImageType {
  ImageType({ this.type, this.image });

  String type;
  dynamic image;
}


class NewStateOfPlayMiscMeter extends StatefulWidget {
  NewStateOfPlayMiscMeter({ Key key, this.meter }) : super(key: key);

  sop.Meter meter;

  @override
  _NewStateOfPlayMiscMeterState createState() => new _NewStateOfPlayMiscMeterState();
}

class _NewStateOfPlayMiscMeterState extends State<NewStateOfPlayMiscMeter> {

  @override
  Widget build(BuildContext context) {

    // print('meter.state: ' + widget.meter.state);

    List<ImageType> imagesType = widget.meter.images.map((image) => ImageType(
      type: "network",
      image: image
    )).toList();

    for (var i = 0; i < widget.meter.newImages.length; i++) {
      imagesType.add(ImageType(
        type: "file",
        image: widget.meter.newImages[i]
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Compteurs / ' + widget.meter.type),
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
          Text("Compteur: " + widget.meter.type),
          TextField(
            controller: TextEditingController(text: widget.meter.location),
            decoration: InputDecoration(labelText: 'Emplacement'),
            onChanged: (value) => widget.meter.location = value,
          ),
          MyImagePicker(
            onSelect: (imageFile) {
              widget.meter.newImages.add(imageFile);
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