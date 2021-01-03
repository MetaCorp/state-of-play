import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


typedef SelectCallback = void Function(File);

class MyImagePicker extends StatefulWidget {

  MyImagePicker({ Key key, this.onSelect, this.imagesCount, this.isMultiSelection }) : super(key: key);

  SelectCallback onSelect;
  int imagesCount;
  bool isMultiSelection;

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  String _error = 'No Error Dectected';
  Uuid uuid = Uuid();


  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      preferredCameraDevice: CameraDevice.rear,
      source: ImageSource.camera, imageQuality: 50
    );

    // Uint8List bytes = await image.readAsBytes();
    if(image == null)
      return;

    widget.onSelect(image);
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );
    if(image == null)
      return;
      
    widget.onSelect(image);
  }

  Future<void> _imgsFromGallery() async {
    List<Asset> images = List<Asset>();


    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      String error = e.toString();
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    images.forEach((image) async  { 
      ByteData data = await image.getByteData();
      final buffer = data.buffer;

      File file = await File(await getFilePath()).create(recursive: true).then((file)async => await file.writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)));

      widget.onSelect(file);
    });
  }

  Future<String> getFilePath() async {

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/NewStateOfPlay/MultiSelected/${uuid.v1()}.png';

    return filePath;
  }


  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallerie'),
                  onTap: () {
                    widget.isMultiSelection?
                    _imgsFromGallery() : _imgFromGallery();
                    Navigator.of(context).pop();
                  }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Caméra'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {


    return Row(
      children: [
        Spacer(),
        Text(widget.imagesCount.toString() + '/5'),
        SizedBox(
          width: 16
        ),
        RaisedButton(
          color: Colors.grey[200],
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 8),
              Text('Ajouter une photo')
            ]
          ),
          onPressed: widget.imagesCount < 5 ? () => _showPicker(context) : null,
        ),
      ],
    );
  }
}