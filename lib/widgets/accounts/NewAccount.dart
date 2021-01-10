import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/IconButtonLoading.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:graphql_flutter/graphql_flutter.dart';

import 'dart:convert';


class NewAccount extends StatefulWidget {
  NewAccount({ Key key, this.accounts }) : super(key: key);

  final List<dynamic> accounts;

  @override
  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final _formKey = GlobalKey<FormState>();

  String _firstName;
  String _lastName;

  void _onSave(RunMutation runMutation) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      widget.accounts.add(Map<String, dynamic>.from({
        "id": widget.accounts.length + 1,
        "firstName": _firstName,
        "lastName": _lastName
      }));

      MultiSourceResult result = runMutation({
        "data": {
          "accounts": jsonEncode(widget.accounts)
        }
      });

      await result.networkResult;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text('Nouveau profil'),
            actions: [
              IconButtonLoading(
                loading: mutationResult.loading,
                icon: Icon(Icons.check),
                onPressed: () => _onSave(runMutation)
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextFormField(
                    initialValue: '',
                    decoration: InputDecoration(labelText: 'Prénom'),
                    textCapitalization: TextCapitalization.sentences,
                    onSaved: (value) => _firstName = value,
                    maxLength: 24,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  MyTextFormField(
                    initialValue: '',
                    decoration: InputDecoration(labelText: 'Nom'),
                    textCapitalization: TextCapitalization.sentences,
                    onSaved: (value) => _lastName = value,
                    maxLength: 24,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RaisedButtonLoading(
                    color: Colors.grey[100],
                    loading: mutationResult.loading,
                    child: Text('Sauvegarder'),
                    onPressed: () => _onSave(runMutation)
                  )             
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}