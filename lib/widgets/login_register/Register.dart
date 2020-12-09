import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _emailController = TextEditingController(text: 'bob1@bob.com');
  TextEditingController _passwordController = TextEditingController(text: 'test123');
  TextEditingController _firstNameController = TextEditingController(text: 'bob1');
  TextEditingController _lastNameController = TextEditingController(text: 'Name');


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
          mutation Register(\$data: RegisterInput!) {
            register(data: \$data) {
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
            if (result.data["register"] == null) {
              // TODO: show error
            }
            else if (result.data["register"] != null) {
              prefs.setString("token", result.data["register"]);
              Navigator.popAndPushNamed(context, '/state-of-plays');
            }
          }
        }

        print('');

        return Scaffold(
          appBar: AppBar(
            title: Text('Inscription'),
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
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Prénom'
                ),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Nom'
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password'
                ),
              ),
              RaisedButton(
                child: Text('S\'inscrire'),
                onPressed: () {
                  runMutation({
                    "data": {
                      "email": _emailController.text,
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                      "password": _passwordController.text
                    }
                  });
                }
              ),
              RaisedButton(
                child: Text('Se connecter'),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/login');
                },
              )
            ],
          )
        );
      }
    );
  }
}