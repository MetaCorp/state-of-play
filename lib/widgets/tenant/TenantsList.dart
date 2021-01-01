import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_slidable/flutter_slidable.dart';

typedef DeleteCallback = Function(sop.Tenant);
typedef TapCallback = Function(sop.Tenant);

class TenantsList extends StatelessWidget {
  const TenantsList({ Key key, this.tenants, this.onTap, this.onDelete }) : super(key: key);

  final List<sop.Tenant> tenants;
  final TapCallback onTap;
  final DeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemCount: tenants.length,
        itemBuilder: (_, i) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            title: Text(tenants[i].firstName + ' ' + tenants[i].lastName),
            onTap: () => onTap(tenants[i]),
            contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: 'Supprimer',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onDelete(tenants[i]),
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