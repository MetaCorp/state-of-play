import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_slidable/flutter_slidable.dart';

typedef DeleteCallback = Function(sop.Representative);
typedef TapCallback = Function(sop.Representative);

class RepresentativesList extends StatelessWidget {
  const RepresentativesList({ Key key, this.representatives, this.onTap, this.onDelete }) : super(key: key);

  final List<sop.Representative> representatives;
  final TapCallback onTap;
  final DeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemCount: representatives.length,
        itemBuilder: (_, i) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            title: Text(representatives[i].firstName + ' ' + representatives[i].lastName),
            onTap: () => onTap(representatives[i]),
            contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: 'Supprimer',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onDelete(representatives[i]),
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