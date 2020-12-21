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
          mutation Login(\$email: String!, \$password: String!) {
            login(email: \$email, password: \$password)
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

        return Scaffold(
          appBar: AppBar(
            title: Text('Connexion'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'
                  ),
                ),
                SizedBox( height: 32,),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password'
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 80,
                ),
                RaisedButton(
                  child: Text('Se connecter'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    MultiSourceResult result = runMutation({
                      "email": _emailController.text,
                      "password": _passwordController.text
                    });

                    QueryResult networkResult = await result.networkResult;

                    if (networkResult.hasException) {
                    
                    }
                    else {
                      print('queryResult data: ' + networkResult.data.toString());
                      if (networkResult.data != null) {
                        if (networkResult.data["login"] == null) {
                          // TODO: show error
                        }
                        else if (networkResult.data["login"] != null) {
                          _prefs.setString("token", networkResult.data["login"]);
                          Navigator.popAndPushNamed(context, '/state-of-plays');
                        }
                      }
                    }
                  }
                ),
                SizedBox( height: 32,),
                FlatButton(
                  child: Text('S\'inscrire'),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/register');
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