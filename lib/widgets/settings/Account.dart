import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/settings/LogoPicker.dart';
import 'package:flutter_tests/widgets/utilities/IconButtonLoading.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Account extends StatefulWidget {
  Account({ Key key }) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid(); 

  sop.User user;

  _save(runMutation) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      MultipartFile newLogo;
      if (user.newLogo != null) {
        newLogo = MultipartFile.fromBytes(
          'photo',
          user.newLogo.readAsBytesSync(),
          filename: '${uuid.v1()}.jpg',
          contentType: MediaType("image", "jpg"),
        );
      }

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
          "newLogo": newLogo
        }
      });

      QueryResult queryResult = await result.networkResult;
      setState(() { });

      debugPrint("networkResult hasException: " + queryResult.hasException.toString());
      if (queryResult.hasException) {
        if (queryResult.exception.graphqlErrors.length > 0) { 
          debugPrint("queryResult exception: " + queryResult.exception.graphqlErrors[0].toString());
          debugPrint("queryResult exception: " + queryResult.exception.graphqlErrors[0].extensions.toString());
        }
        else
          debugPrint("queryResult clientException: " + queryResult.exception.clientException.message);
        return;//TODO: show error
      }
      debugPrint("");

      Navigator.pop(context);
    }
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
              company
              documentHeader
              documentEnd
              address
              postalCode
              city
              logo
            }
          }
        ''')
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        // debugPrint('userResult: ' + result.loading.toString());
        // debugPrint('userResult hasException: ' + result.hasException.toString());
        // debugPrint('userResult data: ' + result.data.toString());
        // if (result.hasException) {
        //   if (result.exception.graphqlErrors.length > 0) { 
        //     debugPrint("userResult exception: " + result.exception.graphqlErrors[0].toString());
        //     debugPrint("userResult exception: " + result.exception.graphqlErrors[0].extensions.toString());
        //   }
        //   else
        //     debugPrint("userResult clientException: " + result.exception.clientException.message);
        // }
        // debugPrint('');

        if (result.data != null && result.data["user"] != null && !result.loading && user == null) {
          user = sop.User.fromJSON(result.data["user"]);
          debugPrint('user: ' + user.firstName.toString());
        }

        // debugPrint('Account user.newLogo: ' + user.newLogo.toString());
        
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
              // debugPrint('onCompleted: ' + resultData.hasException);
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult mutationResult,
          ) {
            
            return Scaffold(
              appBar: AppBar(
                title: Text('Mon compte'),
                actions: [
                  IconButtonLoading(
                    loading: mutationResult.loading,
                    icon: Icon(Icons.check),
                    onPressed: () => _save(runMutation)
                  )
                ],
              ),
              body: user == null ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            MyTextFormField(
                              initialValue: user.firstName,
                              decoration: InputDecoration(labelText: 'Prénom'),
                              onSaved: (value) => user.firstName = value,
                              validator: (value) {
                                if (value == null || value == "")
                                  return "Ce champ est obligatoire.";
                                return null;
                              },
                              maxLength: 24,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.lastName,
                              decoration: InputDecoration(labelText: 'Nom'),
                              onSaved: (value) => user.lastName = value,
                              validator: (value) {
                                if (value == null || value == "")
                                  return "Ce champ est obligatoire.";
                                return null;
                              },
                              maxLength: 24,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.company,
                              decoration: InputDecoration(labelText: 'Société'),
                              onSaved: (value) => user.company = value,
                              maxLength: 24,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            LogoPicker(
                              logo: user.logo,
                              newLogo: user.newLogo,
                              onSelect: (newLogo) {
                                user.newLogo = newLogo;
                                setState(() { });
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.address,
                              decoration: InputDecoration(labelText: 'Adresse'),
                              onSaved: (value) => user.address = value,
                              maxLength: 48,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.postalCode,
                              decoration: InputDecoration(labelText: 'Code postal'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => user.postalCode = value,
                              maxLength: 12,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.city,
                              decoration: InputDecoration(labelText: 'Ville'),
                              onSaved: (value) => user.city = value,
                              maxLength: 24,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.documentHeader,
                              decoration: InputDecoration(labelText: "En tête de l'EDL"),
                              onSaved: (value) => user.documentHeader = value,
                              keyboardType: TextInputType.multiline,
                              maxLength: 256,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextFormField(
                              initialValue: user.documentEnd,
                              decoration: InputDecoration(labelText: "Mention en fin de l'EDL"),
                              onSaved: (value) => user.documentEnd = value,
                              keyboardType: TextInputType.multiline,
                              maxLength: 1024,
                              maxLines: 4,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            RaisedButtonLoading(
                              loading: mutationResult.loading,
                              color: Colors.grey[100],
                              child: Text('Sauvegarder'),
                              onPressed: () => _save(runMutation)
                            )
                          ],
                        ),
                      ),
                    ]
                  )
                ),
              )
            );
          }
        );
      }
    );
  }
}