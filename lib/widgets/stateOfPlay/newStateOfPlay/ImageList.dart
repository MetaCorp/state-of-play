import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';


class ImageList extends StatefulWidget {
  ImageList({ Key key, this.images, this.type }) : super(key: key);

  List<dynamic> images;
  String type;

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation multiUpload(\$files: [Upload!]!) {
            multiUpload(files: \$files)
          }
        '''),
        update: (Cache cache, QueryResult result) {
          return cache;
        },
        onCompleted: (dynamic resultData) {
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        // print('NewStateOfPlay: ' + widget.stateOfPlayId);
        return Column(
          children: [
            RaisedButton(
              child: Text("Upload"),
              onPressed: () async {
                List<MultipartFile> multipartFiles = widget.images.map((image) {
                  var byteData = image.readAsBytesSync();

                  return MultipartFile.fromBytes(
                    'photo',
                    byteData,
                    filename: '${DateTime.now().microsecond}.jpg',
                    contentType: MediaType("image", "jpg"),
                  );

                }).toList();


                MultiSourceResult result = runMutation(<String, dynamic>{
                  "files": multipartFiles,
                });

                QueryResult queryResult = await result.networkResult;

                print('upload: ' + queryResult.exception.graphqlErrors[0].toString());
              },
            ),
            Wrap(
              runSpacing: 0.1,
              spacing: 0.1,
              children: widget.images.map((image) {
                if (widget.type == "file")
                  return Image.file(
                    image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.fitHeight,
                  );
                else
                  return Image.network(
                    image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.fitHeight,
                  );
              }).toList(),
            )
          ]
        );
      }
    );
  }
}