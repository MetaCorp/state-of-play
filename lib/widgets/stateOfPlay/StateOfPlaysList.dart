import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart';

typedef DeleteCallback = Function(sop.StateOfPlay);
typedef TapCallback = Function(sop.StateOfPlay);

class StateOfPlaysList extends StatelessWidget {
  const StateOfPlaysList({ Key key, this.stateOfPlays, this.onDelete, this.onTap }) : super(key: key);

  final List<sop.StateOfPlay> stateOfPlays;
  final TapCallback onTap;
  final DeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemCount: stateOfPlays.length,
        itemBuilder: (_, i)  {
          String tenantsString = "";

          for (var j = 0; j < stateOfPlays[i].tenants.length; j++) {
            tenantsString += stateOfPlays[i].tenants[j].firstName + ' ' + stateOfPlays[i].tenants[j].lastName;
            if (j < stateOfPlays[i].tenants.length - 1)
              tenantsString += ', ';
          }

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Propriétaire: " + stateOfPlays[i].owner.firstName + " " + stateOfPlays[i].owner.lastName),
                  IconButton(
                    icon: Icon(Icons.text_snippet),
                    color: Colors.grey[700],
                    onPressed: () async {
                      if (stateOfPlays[i].pdf != null) {
                        Directory tempDir = await getTemporaryDirectory();
                        String tempPath = tempDir.path;

                        String fileName = stateOfPlays[i].pdf.substring(stateOfPlays[i].pdf.lastIndexOf('/') + 1);
                        File pdf = File(tempPath + '/' + fileName);

                        var request = await get(stateOfPlays[i].pdf);
                        var bytes = await request.bodyBytes;
                        await pdf.writeAsBytes(bytes);

                        OpenFile.open(pdf.path);
                      }

                    }
                  )
                ]
              ),
              subtitle: Text("Locataire" + (stateOfPlays[i].tenants.length > 1 ? "s" : "") + ": " + tenantsString),
              onTap: () => onTap(stateOfPlays[i]),
            ),
            secondaryActions: [
              IconSlideAction(
                caption: 'Supprimer',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => onDelete(stateOfPlays[i]),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      );
  }
}