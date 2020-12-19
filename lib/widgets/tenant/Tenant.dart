import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class Tenant extends StatefulWidget {
  Tenant({ Key key, this.tenantId }) : super(key: key);

  final String tenantId;

  @override
  _TenantState createState() => _TenantState();
}

// adb reverse tcp:9002 tcp:9002

class _TenantState extends State<Tenant> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/tenants');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Locataire'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/edit-tenant', arguments: { "tenantId": widget.tenantId }),
            )
          ],
        ),
        body: 
          Query(
            options: QueryOptions(
              documentNode: gql('''
                query tenant(\$data: TenantInput!) {
                  tenant(data: \$data) {
                    id
                    firstName
                    lastName
                  }
                }
              '''),
              variables: {
                "data": {
                  "tenantId": widget.tenantId
                }
              }
            ),
            builder: (
              QueryResult result, {
              Refetch refetch,
              FetchMore fetchMore,
            }) {
              print('loading: ' + result.loading.toString());
              print('exception: ' + result.exception.toString());
              print('data: ' + result.data.toString());
              print('');

              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading || result.data == null) {
                return CircularProgressIndicator();
              }

              sop.Tenant tenant = sop.Tenant.fromJSON(result.data["tenant"]);

              print('parsed data: ' + tenant.toString());

              return Text(tenant.id);
            }
          )
      ),
    );
  }
}