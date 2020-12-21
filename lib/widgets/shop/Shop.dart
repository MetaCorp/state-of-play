import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/shop/ListTileShop.dart';
import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Shop extends StatefulWidget {
  Shop({Key key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Boutique'),
        actions: [
          Text('20 crédits')
        ],
      ),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation pay {
              pay
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
                  title: 'Acheter 10 crédits (0.49€/u)',
                  loading: loadings[0],
                  price: 4.99,
                  onPress: () async {
                    MultiSourceResult result = runMutation({});
              
                    setState(() { loadings[0] = true; });
                    QueryResult queryResult = await result.networkResult;
                    setState(() { loadings[0] = false; });
                  }
                ),
                Divider(),
                ListTileShop(
                  title: 'Acheter 10 crédits (0.49€/u)',
                  loading: loadings[1],
                  price: 4.99,
                  onPress: () async {
                    MultiSourceResult result = runMutation({});
              
                    setState(() { loadings[1] = true; });
                    QueryResult queryResult = await result.networkResult;
                    setState(() { loadings[1] = false; });
                  }
                ),
                Divider(),
                ListTileShop(
                  title: 'Acheter 10 crédits (0.49€/u)',
                  loading: loadings[2],
                  price: 4.99,
                  onPress: () async {
                    MultiSourceResult result = runMutation({});
              
                    setState(() { loadings[2] = true; });
                    QueryResult queryResult = await result.networkResult;
                    setState(() { loadings[2] = false; });
                  }
                )
              ],
            ),
          );
        }
      )
    );
  }
}
