import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(String);
typedef DeleteCallback = void Function(Map);

class NewStateOfPlayDetailsRoomAddEquipmentContent extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddEquipmentContent({ Key key, this.onSelect, this.onDelete,this.equipments, this.selectedEquipments }) : super(key: key);

  final SelectCallback onSelect;
  final DeleteCallback onDelete;

  List<Map> equipments;
  List<String> selectedEquipments;

  @override
  _NewStateOfPlayDetailsRoomAddEquipmentContentState createState() => _NewStateOfPlayDetailsRoomAddEquipmentContentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddEquipmentContentState extends State<NewStateOfPlayDetailsRoomAddEquipmentContent> {

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      itemCount: widget.equipments.length,
      itemBuilder: (_, i) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(widget.equipments[i]["type"]),
          selected: widget.selectedEquipments.contains(widget.equipments[i]["id"]),
          onTap: () {
            widget.onSelect(widget.equipments[i]["id"]);
            // setState(() {
            //   if (!widget.selectedEquipments.contains(widget.equipments[i]["id"]))
            //     widget.selectedEquipments.add(widget.equipments[i]["id"]);
            //   else
            //     widget.selectedEquipments.remove(widget.equipments[i]["id"]);
            // });
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Supprimer',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => widget.onDelete(widget.equipments[i]),
          )
        ]
      ),
      separatorBuilder: (context, index) {
        return Divider();
      },
    );             
  }
}