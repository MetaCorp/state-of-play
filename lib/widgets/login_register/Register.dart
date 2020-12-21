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

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation Register(\$data: RegisterInput!) {
            register(data: \$data)
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
        if(result.hasException && result.exception.graphqlErrors.length > 0) print('queryResult graphqlErrors: ' + result.exception.graphqlErrors[0].toString());
        else if(result.hasException) print('queryResult clientException: ' + result.exception.clientException.message);

        print('');

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Inscription'),
          ),
          body: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Prénom'
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom'
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password'
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  child: Text('S\'inscrire'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    MultiSourceResult result = runMutation({
                      "data": {
                        "email": _emailController.text,
                        "firstName": _firstNameController.text,
                        "lastName": _lastNameController.text,
                        "password": _passwordController.text
                      }
                    });

                    QueryResult networkResult =  await result.networkResult;

                    if (networkResult.hasException) {
                      // TODO display snackbar (email already in use)
                    } else {
                      print('queryResult data: ' + networkResult.data.toString());
                      if (networkResult.data != null) {
                        if (networkResult.data["register"] == null) {
                          // TODO: show error
                        }
                        else if (networkResult.data["register"] != null) {
                          _prefs.setString("token", networkResult.data["register"]);
                          Navigator.popAndPushNamed(context, '/state-of-plays');
                        }
                      }
                    }
                  }
                ),
                FlatButton(
                  child: Text('Se connecter'),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/login');
                  },
                )
              ],
            ),
          )
        );
      }
    );
  }
}