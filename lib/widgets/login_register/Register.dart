import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _firstNameController = TextEditingController(text: '');
  TextEditingController _lastNameController = TextEditingController(text: '');

  // TextEditingController _emailController = TextEditingController(text: 'bob1@bob.com');
  // TextEditingController _passwordController = TextEditingController(text: 'test123');
  // TextEditingController _firstNameController = TextEditingController(text: 'bob1');
  // TextEditingController _lastNameController = TextEditingController(text: 'Name');


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

   _trimText(){
    _emailController.text = _emailController.text.trim();
    //_passwordController.text = _passwordController.text.trim();
    _firstNameController.text = _firstNameController.text.trim();
    _lastNameController.text = _lastNameController.text.trim();
  }

  _register(RunMutation runMutation) async {
                      
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", null);

    _trimText();

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
      debugPrint('queryResult data: ' + networkResult.data.toString());
      if (networkResult.data != null) {
        if (networkResult.data["register"] == null) {
          // TODO: show error
        }
        else if (networkResult.data["register"] != null && networkResult.data["register"]["token"] != null) {
          await _prefs.setString("token", networkResult.data["register"]["token"]);
          await _prefs.setString("user", jsonEncode(networkResult.data["register"]["user"]));
          Navigator.pushNamed(context, '/verify');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation Register(\$data: RegisterInput!) {
            register(data: \$data) {
              token
              admin
              user {
                firstName
                lastName
                email
                credits
                stateOfPlays {
                  id
                }
              }
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

        debugPrint('register hasException: ' + result.hasException.toString());
        debugPrint('register loading: ' + result.loading.toString());
        if(result.hasException && result.exception.graphqlErrors.length > 0) debugPrint('register graphqlErrors: ' + result.exception.graphqlErrors[0].toString());
        else if(result.hasException) debugPrint('register clientException: ' + result.exception.clientException.message);

        if (result.hasException) {
          debugPrint('hasException: ' + result.exception.toString());

          if (result.exception.graphqlErrors != null &&
              result.exception.graphqlErrors.length > 0 &&
              result.exception.graphqlErrors[0] != null &&
              result.exception.graphqlErrors[0].extensions != null &&
              result.exception.graphqlErrors[0].extensions["exception"] != null &&
              result.exception.graphqlErrors[0].extensions["exception"]["validationErrors"] != null &&
              result.exception.graphqlErrors[0].extensions["exception"]["validationErrors"].length > 0 &&
              result.exception.graphqlErrors[0].extensions["exception"]["validationErrors"][0] != null &&
              result.exception.graphqlErrors[0].extensions["exception"]["validationErrors"][0]["constraints"] != null &&
              result.exception.graphqlErrors[0].extensions["exception"]["validationErrors"][0]["constraints"]["IsEmailAlreadyExistConstraint"] != null)
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Email déjà utilisé.")));
          else
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Impossible de s'inscrire.")));

        }


        debugPrint('');

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Inscription'),
            automaticallyImplyLeading: true,
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { Navigator.popAndPushNamed(context, '/login'); },),
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email'
                    ),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Prénom'
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Nom'
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password'
                    ),
                    obscureText: true,
                    onEditingComplete: () => _register(runMutation),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButtonLoading(
                    child: Text('S\'inscrire'),
                    color: Theme.of(context).primaryColor,
                    loading: result.loading,
                    onPressed: () => _register(runMutation)
                  ),
                  SizedBox( height: 18,),
                  FlatButton(
                    child: Text('Se connecter'),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          )
        );
      }
    );
  }
}