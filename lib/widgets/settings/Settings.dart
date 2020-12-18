import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Settings extends StatefulWidget {
  Settings({ Key key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();

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
              company
              documentHeader
              documentEnd
              address
              postalCode
              city
            }
          }
        ''')
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        print('userResult: ' + result.loading.toString());
        print('userResult hasException: ' + result.hasException.toString());
        print('userResult data: ' + result.data.toString());
        print('');

        sop.User user;
        if (result.data != null && !result.loading) {
          user = sop.User.fromJSON(result.data["user"]);
          print('user: ' + user.firstName.toString());
        }
        
        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation updateUser(\$data: UpdateUserInput!) {
                updateUser(data: \$data)
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
            
            return Scaffold(
              appBar: AppBar(
                title: Text('Settings'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        MultiSourceResult result = runMutation({
                          "data": {
                            "firstName": user.firstName,
                            "lastName": user.lastName,
                            "address": user.address,
                            "postalCode": user.postalCode,
                            "city": user.city,
                            "company": user.company,
                            "documentHeader": user.documentHeader,
                            "documentEnd": user.documentEnd,
                          }
                        });

                        await result.networkResult;
                        setState(() { });
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
              body: user == null ? Center(child: CircularProgressIndicator()) : Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: user.firstName,
                            decoration: InputDecoration(labelText: 'Prénom'),
                            onSaved: (value) => user.firstName = value,
                            validator: (value) {
                              if (value == null || value == "")
                                return "Ce champs est obligatoire.";
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.lastName,
                            decoration: InputDecoration(labelText: 'Nom'),
                            onSaved: (value) => user.lastName = value,
                            validator: (value) {
                              if (value == null || value == "")
                                return "Ce champs est obligatoire.";
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.company,
                            decoration: InputDecoration(labelText: 'Société'),
                            onSaved: (value) => user.company = value,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.address,
                            decoration: InputDecoration(labelText: 'Adresse'),
                            onSaved: (value) => user.address = value,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.postalCode,
                            decoration: InputDecoration(labelText: 'Code postal'),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => user.postalCode = value,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.city,
                            decoration: InputDecoration(labelText: 'Ville'),
                            onSaved: (value) => user.city = value,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.documentHeader,
                            decoration: InputDecoration(labelText: "En tête de l'EDL"),
                            onSaved: (value) => user.documentHeader = value,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: user.documentEnd,
                            decoration: InputDecoration(labelText: "Mention en fin de l'EDL"),
                            onSaved: (value) => user.documentEnd = value,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          RaisedButton(
                            child: Text('Sauvegarder'),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                MultiSourceResult result = runMutation({
                                  "data": {
                                    "firstName": user.firstName,
                                    "lastName": user.lastName,
                                    "address": user.address,
                                    "postalCode": user.postalCode,
                                    "city": user.city,
                                    "company": user.company,
                                    "documentHeader": user.documentHeader,
                                    "documentEnd": user.documentEnd,
                                  }
                                });

                                QueryResult queryResult = await result.networkResult;
                                setState(() { });

                                print("networkResult hasException: " + queryResult.hasException.toString());
                                if (queryResult.hasException) {
                                  if (queryResult.exception.graphqlErrors.length > 0) { 
                                    print("queryResult exception: " + queryResult.exception.graphqlErrors[0].toString());
                                    print("queryResult exception: " + queryResult.exception.graphqlErrors[0].extensions.toString());
                                  }
                                  else
                                    print("queryResult clientException: " + queryResult.exception.clientException.message);
                                  return;//TODO: show error
                                }
                                print("");

                                Navigator.pop(context);
                              }
                            }
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      color: Colors.red[700],
                      child: Text('Déconnexion'),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setStringList("token", null);
                        Navigator.popAndPushNamed(context, '/login');
                      },
                    ),
                  ]
                )
              )
            );
          }
        );
      }
    );
  }
}