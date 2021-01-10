import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(String);
typedef DeleteCallback = void Function(Map);

class NewStateOfPlayDetailsRoomAddDecorationContent extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddDecorationContent({ Key key, this.onSelect, this.onDelete, this.decorations, this.selectedDecorations }) : super(key: key);

  final SelectCallback onSelect;
  final DeleteCallback onDelete;

  List<Map> decorations;
  List<String> selectedDecorations;

  @override
  _NewStateOfPlayDetailsRoomAddDecorationContentState createState() => _NewStateOfPlayDetailsRoomAddDecorationContentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddDecorationContentState extends State<NewStateOfPlayDetailsRoomAddDecorationContent> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      itemCount: widget.decorations.length,
      itemBuilder: (_, i) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(widget.decorations[i]["type"]),
          selected: widget.selectedDecorations.contains(widget.decorations[i]["id"]),
          onTap: () {
            widget.onSelect(widget.decorations[i]["id"]);
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Supprimer',
            color: Colors.red,
            icon: Icons.delete,
            //TODO as 1 callback
            onTap: () => widget.onDelete(widget.decorations[i]),
          )
        ]
      ),
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}