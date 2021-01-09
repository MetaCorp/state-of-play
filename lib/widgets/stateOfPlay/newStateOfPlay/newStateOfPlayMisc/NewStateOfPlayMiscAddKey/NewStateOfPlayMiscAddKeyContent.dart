import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(String);
typedef DeleteCallback = void Function(Map);

class NewStateOfPlayMiscAddKeyContent extends StatefulWidget {
  NewStateOfPlayMiscAddKeyContent({ Key key, this.onSelect, this.onDelete, this.keys, this.selectedKeys }) : super(key: key);

  final SelectCallback onSelect;
  final DeleteCallback onDelete;
  
  List<Map> keys;
  List<String> selectedKeys = [];

  @override
  _NewStateOfPlayMiscAddKeyContentState createState() => _NewStateOfPlayMiscAddKeyContentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayMiscAddKeyContentState extends State<NewStateOfPlayMiscAddKeyContent> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      itemCount: widget.keys.length,
      itemBuilder: (_, i) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(widget.keys[i]["type"]),
          selected: widget.selectedKeys.contains(widget.keys[i]["id"]),
          onTap: () {
            widget.onSelect(widget.keys[i]["id"]);
            // setState(() {
            //   if (!widget._selectedKeys.contains(keys[i]["id"]))
            //     widget._selectedKeys.add(keys[i]["id"]);
            //   else
            //     widget._selectedKeys.remove(keys[i]["id"]);
            // });
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Supprimer',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => widget.onDelete(widget.keys[i]),
          )
        ]
      ),
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }            
}