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

class ChangePassword extends StatefulWidget {
  ChangePassword({ Key key }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid(); 

  String _password = "";

  _changePassword(runMutation) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      MultiSourceResult result = runMutation({
        "data": {
          "password": _password,
        }
      });

      QueryResult queryResult = await result.networkResult;
      setState(() { });

      debugPrint("changePassword hasException: " + queryResult.hasException.toString());
      if (queryResult.hasException) {
        if (queryResult.exception.graphqlErrors.length > 0) { 
          debugPrint("changePassword exception: " + queryResult.exception.graphqlErrors[0].toString());
          debugPrint("changePassword exception: " + queryResult.exception.graphqlErrors[0].extensions.toString());
        }
        else
          debugPrint("changePassword clientException: " + queryResult.exception.clientException.message);
        return;//TODO: show error
      }
      else {
        Navigator.pop(context);
      }
      debugPrint("");

    }
  }

  @override
  Widget build(BuildContext context) {

    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation changePassword(\$data: ChangePasswordInput!) {
            changePassword(data: \$data)
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
            title: Text('Changer de mot de passe'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MyTextFormField(
                          initialValue: "",
                          decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                          obscureText: true,
                          onSaved: (value) => _password = value,
                          validator: (value) {
                            if (value == null || value == "")
                              return "Ce champ est obligatoire.";
                            return null;
                          },
                          maxLength: 24,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        RaisedButtonLoading(
                          loading: mutationResult.loading,
                          color: Theme.of(context).primaryColor,
                          child: Text('Changer'),
                          onPressed: () => _changePassword(runMutation)
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
}