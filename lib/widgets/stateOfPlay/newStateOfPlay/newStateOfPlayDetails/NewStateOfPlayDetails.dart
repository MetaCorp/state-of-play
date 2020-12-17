import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/Header.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsAddRoom.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoom.dart';

class NewStateOfPlayDetails extends StatefulWidget {
  NewStateOfPlayDetails({ Key key, this.rooms }) : super(key: key);

  List<sop.Room> rooms;

  @override
  _NewStateOfPlayDetailsState createState() => new _NewStateOfPlayDetailsState();
}

class _NewStateOfPlayDetailsState extends State<NewStateOfPlayDetails> {

  void _showDialogDeleteRoom (context, sop.Room room) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + room.name + "' ?"),
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
              widget.rooms.remove(room);
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

    print('rooms: ' + widget.rooms.toString());

    return SingleChildScrollView(
      child: Column(
        children: [
          Header(
            title: "Liste des pièces",
            onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsAddRoom(
              onSelect: (rooms) {
                print('rooms: ' + rooms.toString());
                for (var i = 0; i < rooms.length; i++) {
                  widget.rooms.add(sop.Room(
                    name: rooms[i],
                    decorations: [],
                    equipments: [],
                    electricities: [],
                    generalAspect: sop.GeneralAspect()
                  ));
                  
                }
                setState(() { });
              },
            ))),
          ),
          Flexible(
            child: ListView.separated(
              itemCount: widget.rooms.length,
              itemBuilder: (_, i) => ListTile(
                title: Row(
                  children: [
                    Text(widget.rooms[i].name),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _showDialogDeleteRoom(context, widget.rooms[i]);
                      },
                    )
                  ]
                ),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoom(
                  room: widget.rooms[i],
                )))
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}