
import 'package:flutter/material.dart';


class ImageList extends StatefulWidget {
  ImageList({ Key key, this.imagesType }) : super(key: key);

  List<dynamic> imagesType;

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Wrap(
            runSpacing: 0.1,
            spacing: 0.1,
            children: widget.imagesType.map((imageType) {
              if (imageType.type == "file")
                return Image.file(
                  imageType.image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.fitHeight,
                );
              else
                return Image.network(
                  imageType.image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.fitHeight,
                );
            }).toList(),
          )
        ]
      ),
    );
  }
}