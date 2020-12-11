import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoom.dart';

class NewStateOfPlayDetails extends StatefulWidget {
  NewStateOfPlayDetails({ Key key, this.rooms }) : super(key: key);

  List<sop.Room> rooms;

  @override
  _NewStateOfPlayDetailsState createState() => new _NewStateOfPlayDetailsState();
}

class _NewStateOfPlayDetailsState extends State<NewStateOfPlayDetails> {
  List<bool> _isSwitch;

  @override
  void initState() { 
    super.initState();

    _isSwitch = widget.rooms.map((room) => true).toList();
  }

  @override
  Widget build(BuildContext context) {

    print('rooms: ' + widget.rooms.toString());

    return ReorderableListView(
      header: Text("Liste des pièces"),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex)
            newIndex -= 1;

          final room = widget.rooms.removeAt(oldIndex);
          widget.rooms.insert(newIndex, room);
        });
      },
      children: widget.rooms.asMap().entries.map((entry) => ListTile(// TODO: Add divider
        key: ValueKey(entry.value.name),
        title: Row(
          children: [
            Text(entry.value.name),
            Spacer(),
            Switch(
              value: _isSwitch[entry.key],
              onChanged: (value) {
                setState(() {
                  _isSwitch[entry.key] = value;
                });
              },
            )
          ]
        ),
        onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoom(
          room: entry.value,
        )))
      )).toList()
    );
  }
}