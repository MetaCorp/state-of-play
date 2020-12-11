import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomDecoration.dart';

class NewStateOfPlayDetailsRoom extends StatefulWidget {
  NewStateOfPlayDetailsRoom({ Key key, this.room }) : super(key: key);

  sop.Room room;

  @override
  _NewStateOfPlayDetailsRoomState createState() => new _NewStateOfPlayDetailsRoomState();
}

class _NewStateOfPlayDetailsRoomState extends State<NewStateOfPlayDetailsRoom> {

  @override
  Widget build(BuildContext context) {

    print('room.decorations: ' + widget.room.decorations.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Détails d'une pièce")
      ),
      body: Column(
        children: [
          Text("Décorations"),
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
                        // TODO show confirmation popup
                        widget.room.decorations.removeAt(i);
                        setState(() { });
                      },
                    )
                  ]
                ),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomDecoration(
                  decoration: widget.room.decorations[i],
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