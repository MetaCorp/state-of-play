import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tests/widgets/utilities/IconButtonLoading.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart';

typedef DeleteCallback = Function(sop.StateOfPlay);
typedef TapCallback = Function(sop.StateOfPlay);

class StateOfPlaysList extends StatefulWidget {
  const StateOfPlaysList({ Key key, this.stateOfPlays, this.onDelete, this.onTap }) : super(key: key);

  final List<sop.StateOfPlay> stateOfPlays;
  final TapCallback onTap;
  final DeleteCallback onDelete;

  @override
  _StateOfPlaysListState createState() => _StateOfPlaysListState();
}

class _StateOfPlaysListState extends State<StateOfPlaysList> {

  List<bool> _pdfLoadings;

  @override
  void initState() { 
    _pdfLoadings = List<bool>(widget.stateOfPlays.length);
    _pdfLoadings = _pdfLoadings.map((pdfLoading) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemCount: widget.stateOfPlays.length,
        itemBuilder: (_, i)  {
          String tenantsString = "";

          for (var j = 0; j < widget.stateOfPlays[i].tenants.length; j++) {
            tenantsString += widget.stateOfPlays[i].tenants[j].firstName + ' ' + widget.stateOfPlays[i].tenants[j].lastName;
            if (j < widget.stateOfPlays[i].tenants.length - 1)
              tenantsString += ', ';
          }

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Propriétaire: " + widget.stateOfPlays[i].owner.firstName + " " + widget.stateOfPlays[i].owner.lastName,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  IconButtonLoading(
                    loading: _pdfLoadings[i],
                    icon: Icon(Icons.text_snippet),
                    color: Colors.grey[700],
                    onPressed: () async {
                      if (widget.stateOfPlays[i].pdf != null) {
                        setState(() { _pdfLoadings[i] = true; });
                        Directory tempDir = await getTemporaryDirectory();
                        String tempPath = tempDir.path;

                        String fileName = widget.stateOfPlays[i].pdf.substring(widget.stateOfPlays[i].pdf.lastIndexOf('/') + 1);
                        File pdf = File(tempPath + '/' + fileName);

                        var request = await get(widget.stateOfPlays[i].pdf);
                        var bytes = await request.bodyBytes;
                        await pdf.writeAsBytes(bytes);
                        OpenFile.open(pdf.path);

                        setState(() { _pdfLoadings[i] = false; });
                      }

                    }
                  )
                ]
              ),
              subtitle: Text("Locataire" + (widget.stateOfPlays[i].tenants.length > 1 ? "s" : "") + ": " + tenantsString),
              onTap: () => widget.onTap(widget.stateOfPlays[i]),
            ),
            secondaryActions: [
              IconSlideAction(
                caption: 'Supprimer',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => widget.onDelete(widget.stateOfPlays[i]),
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