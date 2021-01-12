import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:feature_discovery/feature_discovery.dart';

typedef SelectCallback = void Function(String);
typedef DeleteCallback = void Function(Map);

class NewStateOfPlayDetailsAddRoomContent extends StatefulWidget {
  NewStateOfPlayDetailsAddRoomContent({ Key key, this.onSelect, this.onDelete, this.selectedRooms, this.rooms}) : super(key: key);

  final SelectCallback onSelect;
  final DeleteCallback onDelete;
  
  List<String> selectedRooms = [];
  List<Map> rooms;

  @override
  _NewStateOfPlayDetailsAddRoomContentState createState() => _NewStateOfPlayDetailsAddRoomContentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsAddRoomContentState extends State<NewStateOfPlayDetailsAddRoomContent> {

  @override
  Widget build(BuildContext context) {
    
    return ListView.separated(
      itemCount: widget.rooms.length,
      itemBuilder: (_, i) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(widget.rooms[i]["name"]),
          selected: widget.selectedRooms.contains(widget.rooms[i]["id"]),
          onTap: () {
            widget.onSelect(widget.rooms[i]["id"]);
            // setState(() {
            //   if (!selectedRooms.contains(rooms[i]["id"]))
            //     _selectedRooms.add(rooms[i]["id"]);
            //   else
            //     _selectedRooms.remove(rooms[i]["id"]);
            // });
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Supprimer',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => widget.onDelete(widget.rooms[i]),
          )
        ]
      ),
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

}

