import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(Map);
typedef DeleteCallback = void Function(Map);


class NewStateOfPlayMiscAddMeterContent extends StatefulWidget {
  NewStateOfPlayMiscAddMeterContent({ Key key, this.onSelect, this.onDelete, this.meters, this.selectedMeters }) : super(key: key);

  final SelectCallback onSelect;
  final DeleteCallback onDelete;

  List<Map> meters;
  List<Map> selectedMeters = [];

  @override
  _NewStateOfPlayMiscAddMeterContentState createState() => _NewStateOfPlayMiscAddMeterContentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayMiscAddMeterContentState extends State<NewStateOfPlayMiscAddMeterContent> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      itemCount: widget.meters.length,
      itemBuilder: (_, i) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: Text(widget.meters[i]["type"]),
          selected: widget.selectedMeters.any((meter) => meter["id"] == widget.meters[i]["id"]),
          onTap: () {
            widget.onSelect(widget.meters[i]);
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Supprimer',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => widget.onDelete(widget.meters[i]),
          )
        ]
      ),
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }       
}