import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_slidable/flutter_slidable.dart';

typedef DeleteCallback = Function(sop.Property);
typedef TapCallback = Function(sop.Property);

class PropertiesList extends StatelessWidget {
  const PropertiesList({ Key key, this.properties, this.onTap, this.onDelete }) : super(key: key);

  final List<sop.Property> properties;
  final TapCallback onTap;
  final DeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemCount: properties.length,
        itemBuilder: (_, i) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            title: Text(properties[i].address + ', ' + properties[i].postalCode + ' ' + properties[i].city),
            onTap: () => onTap(properties[i]),
            contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: 'Supprimer',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onDelete(properties[i]),
            ),
          ],
        ),
        separatorBuilder: (context, index) {
          return Divider(
            height: 0.0,
          );
        },
      ),
    );
  }
}