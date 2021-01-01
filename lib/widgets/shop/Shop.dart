import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/shop/ListTileShop.dart';
import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Shop extends StatefulWidget {
  Shop({ Key key, this.isPopup = false }) : super(key: key);

  final bool isPopup;

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<bool> loadings = List(3);

  @override
  void initState() {
    super.initState();

    loadings = loadings.map((value) => false).toList();
  }

  _onWillPop(sop.User user) {
    if (user == null)
      Navigator.pop(context, false);

    Navigator.pop(context, user.credits > 0);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query user {
            user {
              id
              firstName
              lastName
              credits
            }
          }
        '''),
        fetchPolicy: FetchPolicy.noCache,
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        sop.User user;
        if (result.data != null && result.data["user"] != null && !result.loading) {
          print('Shop user: ' + result.data["user"].toString());
          user = sop.User.fromJSON(result.data["user"]);
        }

        Widget body = Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation pay(\$data: PayInput!) {
                pay(data: \$data)
              }
            '''), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              // print('onCompleted: ' + resultData.hasException);
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult mutationResult,
          ) {
            
            return Container(
              child: ListView(
                children: [
                  ListTileShop(
                    title: '1 crédit',
                    loading: loadings[0],
                    price: 4.99,
                    onPress: () async {
                      MultiSourceResult result = runMutation({
                        "data": {
                          "amount": 1
                        }
                      });
                
                      setState(() { loadings[0] = true; });
                      QueryResult queryResult = await result.networkResult;
                      setState(() { loadings[0] = false; });
                    }
                  ),
                  Divider(),
                  ListTileShop(
                    title: '5 crédits',
                    loading: loadings[1],
                    price: 19.99,
                    onPress: () async {
                      MultiSourceResult result = runMutation({
                        "data": {
                          "amount": 5
                        }
                      });
                
                      setState(() { loadings[1] = true; });
                      QueryResult queryResult = await result.networkResult;
                      setState(() { loadings[1] = false; });
                    }
                  ),
                  Divider(),
                  ListTileShop(
                    title: '10 crédits',
                    loading: loadings[2],
                    price: 34.99,
                    onPress: () async {
                      MultiSourceResult result = runMutation({
                        "data": {
                          "amount": 10
                        }
                      });
                
                      setState(() { loadings[2] = true; });
                      QueryResult queryResult = await result.networkResult;
                      setState(() { loadings[2] = false; });
                    }
                  )
                ],
              ),
            );
          }
        );

        Widget appBar = AppBar(
          title: Text('Boutique'),
          actions: [// TODO : result.loading doesnt work
            user == null || result.loading || result.data == null ? Container(
              child: IconButton(
                  icon: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator()
                ),
              )
            ) : Container(
              margin: EdgeInsets.only(top: 16, right: 16),
              child: Text(
                user.credits.toString() + ' crédits',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              )
            )
          ],
        );


        return WillPopScope(
          onWillPop: () async => _onWillPop(user),
          child: widget.isPopup ? Scaffold(
            appBar: appBar,
            body: body
          ) : MyScaffold(
            appBar: appBar,
            body: body
          ),
        );
      }
    );
  }
}
