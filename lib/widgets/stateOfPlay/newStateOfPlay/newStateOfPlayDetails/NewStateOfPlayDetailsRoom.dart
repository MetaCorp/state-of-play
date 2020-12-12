import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomAddDecoration.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomDecoration.dart';

class NewStateOfPlayDetailsRoom extends StatefulWidget {
  NewStateOfPlayDetailsRoom({ Key key, this.room }) : super(key: key);

  sop.Room room;

  @override
  _NewStateOfPlayDetailsRoomState createState() => new _NewStateOfPlayDetailsRoomState();
}

class _NewStateOfPlayDetailsRoomState extends State<NewStateOfPlayDetailsRoom> {

  void _showDialogDeleteDecoration (context, sop.Decoration decoration) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + decoration.type + "' ?"),
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
              widget.room.decorations.remove(decoration);
              setState(() { });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    print('room.decorations: ' + widget.room.decorations.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name)
      ),
      body: Column(
        children: [
          Row(
          children: [
            Text("Décorations"),
            RaisedButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddDecoration(
                onSelect: (decorations) {
                  print('decorations: ' + decorations.toString());
                  for (var i = 0; i < decorations.length; i++) {
                    widget.room.decorations.add(sop.Decoration(
                      type: decorations[i],
                    ));
                    
                  }
                  setState(() { });
                },
              ))),
            )
          ]
        ),
          Flexible(
            child: ListView.separated(
              itemCount: widget.room.decorations.length,
              itemBuilder: (_, i) => ListTile(
                title: Row(
                  children: [
                    Text(widget.room.decorations[i].type),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _showDialogDeleteDecoration(context, widget.room.decorations[i]);
                      },
                    )
                  ]
                ),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomDecoration(
                  decoration: widget.room.decorations[i],
                  roomName: widget.room.name,
                )))
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          )
        ]
      ),
    );
  }
}