import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';
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


class NewStateOfPlayMiscMeter extends StatefulWidget {
  NewStateOfPlayMiscMeter({ Key key, this.meter }) : super(key: key);

  sop.Meter meter;

  @override
  _NewStateOfPlayMiscMeterState createState() => new _NewStateOfPlayMiscMeterState();
}

class _NewStateOfPlayMiscMeterState extends State<NewStateOfPlayMiscMeter> {
  final _formKey = GlobalKey<FormState>();
  Uuid uuid = Uuid();


  Future<String> getFilePath() async {

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/NewStateOfPlay/MiscMeter/${uuid.v1()}.png';

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

    // debugPrint('meter.state: ' + widget.meter.state);

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
      onWillPop: () async => _onSave(),
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
                  textCapitalization: TextCapitalization.sentences,
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
                  isMultiSelection : true,
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
                  },
                  onUpdate: (image, index) async {
                    debugPrint("FILEPATH:");

                    File file = await File(await getFilePath()).create(recursive: true).then((file) => file.writeAsBytes(image));
                    debugPrint("FILEPATH:"+file.path);

                    //TODO FINISH
                    if(index < widget.meter.images.length){   
                      debugPrint("index"+index.toString());
                      widget.meter.images.removeAt(index);
                      widget.meter.newImages.add(file);
                    } 
                    else {
                      debugPrint("Else index" + index.toString());
                      index -= widget.meter.images.length;
                      widget.meter.newImages[index] = file;
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