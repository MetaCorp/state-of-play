import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_slidable/flutter_slidable.dart';

typedef DeleteCallback = Function(sop.Owner);
typedef TapCallback = Function(sop.Owner);

class OwnersList extends StatelessWidget {
  const OwnersList({ Key key, this.owners, this.onTap, this.onDelete }) : super(key: key);

  final List<sop.Owner> owners;
  final TapCallback onTap;
  final DeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemCount: owners.length,
        itemBuilder: (_, i) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            title: Text(owners[i].firstName + ' ' + owners[i].lastName),
            onTap: () => onTap(owners[i]),
            contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: 'Supprimer',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onDelete(owners[i]),
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