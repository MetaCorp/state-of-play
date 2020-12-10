import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Properties extends StatefulWidget {
  Properties({Key key}) : super(key: key);

  @override
  _PropertiesState createState() => _PropertiesState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertiesState extends State<Properties> {
  
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriétés'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-properties'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-property'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query properties(\$pagination: PropertyPaginationInput!) {
              properties (pagination: \$pagination) {
                cursor {
                  afterCursor
                  beforeCursor
                }
                data {
                  id
                  address
                  postalCode
                  city
                }
              }
            }
            '''),
            variables: {
              "pagination": {
                "afterCursor": "",
                "beforeCursor": "",
                "limit": 20
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

            _scrollController
              ..addListener(() {
                if (_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
                  if (!result.loading && result.data["properties"]["cursor"]["afterCursor"] != null) {
                    print('fetchMore: ' + result.data["properties"]["cursor"]["afterCursor"]);
                    FetchMoreOptions opts = FetchMoreOptions(
                      variables: {
                        "afterCursor": result.data["properties"]["cursor"]["afterCursor"],
                        "beforeCursor": "",
                        "limit": 20
                      },
                      updateQuery: (previousResultData, fetchMoreResultData) {
                        // final List<dynamic> newProperties = fetchMoreResultData["properties"]["data"] as List;

                        // fetchMoreResultData["properties"]["cursor"] = fetchMoreResultData["properties"]["cursor"];
                        // fetchMoreResultData["properties"]["data"] = newProperties;

                        return fetchMoreResultData;
                      },
                    );
                    fetchMore(opts);
                  }
                }
              });

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading || result.data == null) {
              return CircularProgressIndicator();
            }

            List<sop.Property> properties = (result.data["properties"]["data"] as List).map((property) => sop.Property.fromJSON(property)).toList();

            print('parsed data: ' + properties.toString());

            if (properties.length == 0) {
              return Text("no properties");
            }

            return ListView.separated(
              controller: _scrollController,
              itemCount: properties.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(properties[i].address + ', ' + properties[i].postalCode + ' ' + properties[i].city),
                onTap: () => Navigator.pushNamed(context, '/property', arguments: { "propertyId": properties[i].id }),
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          }
        )
    );
  }
}