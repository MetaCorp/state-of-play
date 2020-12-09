import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController(text: 'bob1@bob.com');
  TextEditingController _passwordController = TextEditingController(text: 'test123');

  var prefs;

  @override
  void initState() async {
    prefs = await SharedPreferences.getInstance();
    
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation Login(\$email: String!, \$password: String!) {
            login(email: \$email, password: \$password) {
              id
              firstName
              lastName
              email
              name
            }
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
        QueryResult result,
      ) {

        print('queryResult hasException: ' + result.hasException.toString());
        print('queryResult loading: ' + result.loading.toString());
        if(result.hasException) print('queryResult exception: ' + result.exception.graphqlErrors[0].toString());

        if (!result.hasException) {
          print('queryResult data: ' + result.data.toString());
          if (result.data != null) {
            if (result.data["login"] == null) {
              // TODO: show error
            }
            else if (result.data["login"] != null) {
              prefs.setString("token", result.data["login"]);
              Navigator.popAndPushNamed(context, '/state-of-plays');
            }
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Connexion'),
          ),
          body: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email'
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password'
                ),
              ),
              RaisedButton(
                child: Text('Se connecter'),
                onPressed: () {
                  runMutation({
                    "email": _emailController.text,
                    "password": _passwordController.text
                  });
                }
              ),
              RaisedButton(
                child: Text('S\'inscrire'),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/register');
                },
              )
            ],
          )
        );
      }
    );
  }
}