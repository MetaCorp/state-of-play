import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';

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
  final _formKey = GlobalKey<FormState>();

  _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context);
    }
    return false;
  }

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

    return WillPopScope(
      onWillPop: () => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Compteurs / ' + widget.meter.type),
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
                MyTextFormField(
                  initialValue: widget.meter.location,
                  decoration: InputDecoration(labelText: 'Emplacement'),
                  onSaved: (value) => widget.meter.location = value,
                  maxLength: 24,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  initialValue: widget.meter.index.toString(),
                  decoration: InputDecoration(labelText: 'Index'),
                  onSaved: (value) => widget.meter.index = int.parse(value),
                  keyboardType: TextInputType.number,
                  maxLength: 12,
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
                  imagesCount: widget.meter.images.length + widget.meter.newImages.length
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
        ),
      ),
    );
  }
}