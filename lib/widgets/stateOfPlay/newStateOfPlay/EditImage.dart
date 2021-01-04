import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:painter2/painter2.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class EditImage extends StatefulWidget {
  EditImage({ Key key, this.image, this.type }) : super(key: key);

  String type;
  dynamic image;

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {

  PainterController _controller;

  @override
  void initState() {
    super.initState();
    debugPrint("Init Controller !!!");
    _controller = PainterController();
    _controller.thickness = 5.0;
    _controller.drawColor = Colors.red;
    _controller.backgroundColor = Colors.black;
    _controller.backgroundImage = widget.type == 'file'? Image.file(widget.image,fit: BoxFit.fill,) : Image.network(widget.image.toString(),fit: BoxFit.fill);    
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {
            if (_controller.canUndo) _controller.undo();
          },
        ),
        IconButton(
          icon: Icon(Icons.redo),
          tooltip: 'Redo',
          onPressed: () {
            if (_controller.canRedo) _controller.redo();
          },
        ),
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              Uint8List bytes = await _controller.exportAsPNGBytes();
              Navigator.pop(context, bytes);
            }),
      ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Édition'),
        actions: actions,
        bottom: PreferredSize(
          child: DrawBar(_controller),
          preferredSize: Size(MediaQuery.of(context).size.width, 20.0),
        ),    
      ),
      body: Container(
        color: Colors.black87,
        child: Painter(_controller)),
    );
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Slider(
                value: _controller.thickness,
                onChanged: (value) => setState(() {
                      _controller.thickness = value;
                    }),
                min: 1.0,
                max: 20.0,
                activeColor: Colors.white,
              ),
            );
        })),
        ColorPickerButton(_controller),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;

  ColorPickerButton(this._controller);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.brush, color: widget._controller.drawColor),
      tooltip: 'Change draw color',
      onPressed: () => _pickColor(),
    );
  }

  void _pickColor() {
    Color pickerColor = widget._controller.drawColor;
    Navigator.of(context)
        .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Pick color'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        widget._controller.drawColor = pickerColor;
      });
    });
  }
}