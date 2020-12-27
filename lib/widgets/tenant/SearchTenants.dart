import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class SearchTenants extends StatefulWidget {
  SearchTenants({Key key}) : super(key: key);

  @override
  _SearchTenantsState createState() => _SearchTenantsState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchTenantsState extends State<SearchTenants> {

  TextEditingController _searchController = TextEditingController(text: "");

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query tenants(\$filter: TenantsFilterInput!) {
            tenants (filter: \$filter) {
              id
              firstName
              lastName
            }
          }
        '''),
        variables: {
          "filter": {
            "search": _searchController.text
          }
        } 
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        Widget body;
        
        print('loading: ' + result.loading.toString());
        print('exception: ' + result.exception.toString());
        print('data: ' + result.data.toString());
        print('');

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          List<sop.Tenant> tenants = (result.data["tenants"] as List).map((tenant) => sop.Tenant.fromJSON(tenant)).toList();
          print('stateOfPlays length: ' + tenants.length.toString());

          if (tenants.length == 0) {
            body = Text("no tenants");
          }
          else {
            body = Container(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 8),
                itemCount: tenants.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(tenants[i].firstName + ' ' + tenants[i].lastName),
                  // subtitle: Text(DateFormat('dd/MM/yyyy').format(tenants[i].date)) ,
                  onTap: () => Navigator.pushNamed(context, '/edit-tenant', arguments: { "tenantId": tenants[i].id }),
                ),
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            );
          }

        }

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Entrez votre recherche'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: { "filter": { "search": value } },
                  updateQuery: (existing, newTenants) => ({
                    "tenants": newTenants["tenants"]
                  }),
                ));
              }
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
              ),
            ],
            backgroundColor: Colors.grey,
          ),
          body: body
        );
      }
    );
  }
}