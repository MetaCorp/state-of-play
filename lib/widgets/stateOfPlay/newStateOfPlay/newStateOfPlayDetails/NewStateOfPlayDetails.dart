import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsAddRoom.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoom.dart';

class NewStateOfPlayDetails extends StatefulWidget {
  NewStateOfPlayDetails({ Key key, this.rooms }) : super(key: key);

  List<sop.Room> rooms;

  @override
  _NewStateOfPlayDetailsState createState() => new _NewStateOfPlayDetailsState();
}

class _NewStateOfPlayDetailsState extends State<NewStateOfPlayDetails> {
  @override
  Widget build(BuildContext context) {

    print('rooms: ' + widget.rooms.toString());

    return Column(
      children: [
        Row(
          children: [
            Text("Liste des pièces"),
            RaisedButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsAddRoom(
                onSelect: (rooms) {
                  print('rooms: ' + rooms.toString());
                  for (var i = 0; i < rooms.length; i++) {
                    print('roomAdd: ' + rooms[i]);
                    widget.rooms.add(sop.Room(
                      name: rooms[i],
                      decorations: [],
                      equipments: [],
                      generalAspect: sop.GeneralAspect()
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
            itemCount: widget.rooms.length,
            itemBuilder: (_, i) => ListTile(
              title: Row(
                children: [
                  Text(widget.rooms[i].name),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // TODO show confirmation popup
                      widget.rooms.removeAt(i);
                      setState(() { });
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
    );
  }
}