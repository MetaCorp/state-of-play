import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widget.meter.location),
              decoration: InputDecoration(labelText: 'Emplacement'),
              onChanged: (value) => widget.meter.location = value,
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: TextEditingController(text: widget.meter.index.toString()),
              decoration: InputDecoration(labelText: 'Index'),
              onChanged: (value) => widget.meter.index = int.parse(value),
              keyboardType: TextInputType.number
            ),
            SizedBox(
              height: 8,
            ),
            DateButton(
              labelText: "Date de relevé",
              value: widget.meter.dateOfSuccession,
              onChange: (value) {
                widget.meter.dateOfSuccession = value;
                setState(() { });
              },
            ),
            SizedBox(
              height: 8,
            ),
            MyImagePicker(
              onSelect: (imageFile) {
                widget.meter.newImages.add(imageFile);
                setState(() { });
              },
            ),
            ImageList(
              imagesType: imagesType,
              onDelete: (imageType) {
                if (imageType["type"] == "file")
                  widget.meter.newImages.remove(imageType["image"]);
                else
                  widget.meter.images.remove(imageType["image"]);
                setState(() {});  
              }
            )
          ]
        ),
      ),
    );
  }
}