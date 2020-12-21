
import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/EditImage.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomDecoration.dart';


typedef DeleteCallback = Function(dynamic);

class ImageList extends StatefulWidget {
  ImageList({ Key key, this.imagesType, this.onDelete }) : super(key: key);

  List<dynamic> imagesType;
  DeleteCallback onDelete;

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
            runSpacing: 4,
            spacing: 8,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: widget.imagesType.map((imageType) {
              Widget image;

              if (imageType.type == "file")
                image = Image.file(
                  imageType.image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                );
              else
                image = Image.network(
                  imageType.image,
                  width: 150,
                  height: 150,
                  // fit: BoxFit.fitHeight,
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
                  },
                );

              return GestureDetector(
                child: Container(
                  width: 150,
                  height: 150,
                  child: Stack(
                    children: [
                      image,
                      Align(
                        alignment: Alignment.topRight,
                          child: ButtonTheme(    
                          minWidth: 26.0,
                          height: 60,
                          child: FlatButton(   
                            padding: EdgeInsets.fromLTRB(0, 0, 7.5, 0),   
                            shape: CircleBorder(),
                            child: Icon(Icons.close, size: 22),
                            onPressed: () { 
                              setState(() {
                                showDeleteImage(imageType);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => EditImage(
                    image: imageType.image,
                    type: imageType.type,
                  )));
                }
              );
            }).toList(),
          )
        ]
      ),
    );
  }

  showDeleteImage(imageType) async  {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer l'image ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async { 
              widget.onDelete({
                "type": imageType.type,
                "image": imageType.image
              });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }  

}