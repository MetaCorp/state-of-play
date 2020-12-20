import 'package:flutter/material.dart';

class EditImage extends StatefulWidget {
  EditImage({ Key key, this.image, this.type }) : super(key: key);

  String type;
  dynamic image;

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Éditer une image'),
        actions: [
          IconButton(
            icon: Icon(Icons.check)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: widget.type == 'file' ? Image.file(
                widget.image,
                height: MediaQuery.of(context).size.height - 64 - 16 - (24 + 8) * 2,
                width: MediaQuery.of(context).size.width - (24 + 8) * 2,
                fit: BoxFit.fill,
              ) : Image.network(
                widget.image,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    ),
                  );
                }
              )
            )
            
          ],
        ),
      )
    );
  }
}