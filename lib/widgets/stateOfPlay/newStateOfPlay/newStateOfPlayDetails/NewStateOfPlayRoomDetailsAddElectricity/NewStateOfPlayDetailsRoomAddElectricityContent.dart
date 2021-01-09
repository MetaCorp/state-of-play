import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(String);
typedef DeleteCallback = void Function(Map);


class NewStateOfPlayDetailsRoomAddElectricityContent extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddElectricityContent({ Key key, this.onSelect, this.onDelete, this.electricities, this.selectedElectricities }) : super(key: key);

  final SelectCallback onSelect;
  final DeleteCallback onDelete;

  List<Map> electricities;
  List<String> selectedElectricities;


  @override
  _NewStateOfPlayDetailsRoomAddElectricityContentState createState() => _NewStateOfPlayDetailsRoomAddElectricityContentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddElectricityContentState extends State<NewStateOfPlayDetailsRoomAddElectricityContent> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      itemCount: widget.electricities.length,
      itemBuilder: (_, i) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(widget.electricities[i]["type"]),
          selected: widget.selectedElectricities.contains(widget.electricities[i]["id"]),
          onTap: () {
             widget.onSelect(widget.electricities[i]["id"]);
            // setState(() {
            //   if (!_selectedElectricities.contains(widget.electricities[i]["id"]))
            //     _selectedElectricities.add(widget.electricities[i]["id"]);
            //   else
            //     _selectedElectricities.remove(widget.electricities[i]["id"]);
            // });
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Supprimer',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => widget.onDelete(widget.electricities[i]),
          )
        ]
      ),
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}