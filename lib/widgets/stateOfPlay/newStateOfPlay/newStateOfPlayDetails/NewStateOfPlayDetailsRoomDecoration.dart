import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/ImageList.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/MyImagePicker.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';
import 'package:path_provider/path_provider.dart';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:uuid/uuid.dart';

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
  
  final _formKey = GlobalKey<FormState>();

  final List<String> stateValues = ['Neuf', 'Très Bon', 'Bon', 'Moyen', 'Mauvais', 'Défaillant'];

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      Future.delayed(const Duration(seconds: 1), () => FeatureDiscovery.discoverFeatures(
        context,
        const <String>{ // Feature ids for every feature that you want to showcase in order.
          'validate_decoration',
        },
      ));
    });
  }

  Uuid uuid = Uuid();


  Future<String> getFilePath() async {

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/NewStateOfPlay/RoomDecoration/${uuid.v1()}.png';

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


    return WillPopScope(
      onWillPop: () => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.roomName + ' / ' + widget.decoration.type),
          actions: [
            DescribedFeatureOverlay(
              featureId: 'validate_decoration',
              tapTarget: Icon(Icons.check),
              title: Text('Valider un élément'),
              description: Text("Pour valider un élément, cliquez sur le bouton valider en haut à droite de l'app."),
              // onComplete: () async {
              //   _onSave();
              //   return true;
              // },
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: _onSave,
              ),
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
                MyTextFormField(
                  initialValue: widget.decoration.nature,
                  decoration: InputDecoration(labelText: 'Nature'),
                  onSaved: (value) => widget.decoration.nature = value,
                  maxLength: 24,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  initialValue: widget.decoration.comments,
                  decoration: InputDecoration(labelText: 'Commentaires'),
                  onSaved: (value) => widget.decoration.comments = value,
                  maxLength: 256,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 16,
                ),
                MyImagePicker(
                  isMultiSelection : true,
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
                  onUpdate: (image, index) async {
                    print("FILEPATH:");

                    File file = await File(await getFilePath()).create(recursive: true).then((file) => file.writeAsBytes(image));
                    print("FILEPATH:"+file.path);

                    //TODO FINISH
                    if(index < widget.decoration.images.length){   
                      print("index"+index.toString());
                      widget.decoration.images.removeAt(index);
                      widget.decoration.newImages.add(file);
                    } 
                    else {
                      print("Else index" + index.toString());
                      index -= widget.decoration.images.length;
                      widget.decoration.newImages[index] = file;
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