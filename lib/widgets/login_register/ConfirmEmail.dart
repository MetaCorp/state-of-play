import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConfirmEmail extends StatefulWidget {
  ConfirmEmail({Key key}) : super(key: key);

  @override
  ConfirmEmailState createState() => new ConfirmEmailState();
}

class ConfirmEmailState extends State<ConfirmEmail> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _codeController = TextEditingController(text: '');

  SharedPreferences _prefs;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
    });
  }

  @override
  void initState() {
    getSharedPrefs();
    
    super.initState();
  }

  _confirmEmail(RunMutation runMutation) async {

    MultiSourceResult result = runMutation({
      "data": {
        "code": _codeController.text,
      }
    });

    QueryResult networkResult =  await result.networkResult;

    _codeController.text = "";

    if (networkResult.data["verify"]["isVerified"]) {
      Navigator.popAndPushNamed(context, '/state-of-plays');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation sendVerificationEmail() {
            sendVerificationEmail()
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
        RunMutation runSendVerificationEmailMutation,
        QueryResult resultSendVerificationEmail,
      ) {

        debugPrint('sendVerificationEmail hasException: ' + resultSendVerificationEmail.hasException.toString());
        debugPrint('sendVerificationEmail loading: ' + resultSendVerificationEmail.loading.toString());
        if(resultSendVerificationEmail.hasException && resultSendVerificationEmail.exception.graphqlErrors.length > 0) debugPrint('sendVerificationEmail graphqlErrors: ' + resultSendVerificationEmail.exception.graphqlErrors[0].toString());
        else if(resultSendVerificationEmail.hasException) debugPrint('sendVerificationEmail clientException: ' + resultSendVerificationEmail.exception.clientException.message);


        debugPrint('');

        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation verify(\$data: VerifyInput!) {
                verify(data: \$data) {
                  isVerified
                  error
                }
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
            QueryResult result,
          ) {

            debugPrint('verify hasException: ' + result.hasException.toString());
            debugPrint('verify loading: ' + result.loading.toString());
            if(result.hasException && result.exception.graphqlErrors.length > 0) debugPrint('verify graphqlErrors: ' + result.exception.graphqlErrors[0].toString());
            else if(result.hasException) debugPrint('verify clientException: ' + result.exception.clientException.message);

            if (result.data != null && result.data["verify"] != null && result.data["verify"]["error"] != null) {
              debugPrint('verify error: ' + result.data["verify"].toString());

              if (result.data["verify"]["error"] == "Email already verified")
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Email déjà vérifié.")));
              else if (result.data["verify"]["error"] == "Code expired")
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Code expiré")));
              else if (result.data["verify"]["error"] == "Wrong code")
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Mauvais code")));

            }


            debugPrint('');

            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                title: Text('Confirmation email'),
                automaticallyImplyLeading: true,
              ),
              body: SingleChildScrollView(
                  child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Code'
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        onChanged: (value) => setState(() { }),
                        maxLength: 6,
                      ),
                      SizedBox( height: 18,),
                      RaisedButtonLoading(
                        loading: result.loading,
                        child: Text('Confirmer'),
                        color: Theme.of(context).primaryColor,
                        onPressed: _codeController.text.length == 6 ? () => _confirmEmail(runMutation) : null,
                      ),
                      FlatButtonLoading(
                        loading: resultSendVerificationEmail.loading,
                        child: Text('Envoyer le code de confirmation'),
                        onPressed: () => runSendVerificationEmailMutation({}),
                      )
                    ],
                  ),
                ),
              )
            );
          }
        );
      }
    );
  }
}