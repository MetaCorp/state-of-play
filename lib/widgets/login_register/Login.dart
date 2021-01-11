import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flip_panel/flip_panel.dart';
// import 'dart:math';

import 'dart:convert';

typedef LoginCallback = Function(sop.User);

class Login extends StatefulWidget {
  Login({ Key key, this.onLogin }) : super(key: key);

  final LoginCallback onLogin;

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  // TextEditingController _emailController = TextEditingController(text: 'bob49@bob.com');
  // TextEditingController _passwordController = TextEditingController(text: 'test123');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  _login(RunMutation runMutation) async {
                      
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", null);
    
    MultiSourceResult result = runMutation({
      "email": _emailController.text,
      "password": _passwordController.text
    });

    QueryResult networkResult = await result.networkResult;

    if (networkResult.hasException) {
    
    }
    else {
      debugPrint('queryResult data: ' + networkResult.data.toString());
      if (networkResult.data != null) {
        if (networkResult.data["login"] == null) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Mauvaise combinaison email/password.')));
        }
        else if (networkResult.data["login"] != null && networkResult.data["login"]["token"] != null) {
          await _prefs.setString("token", networkResult.data["login"]["token"]);// TODO: admin
          await _prefs.setString("user", jsonEncode(networkResult.data["login"]["user"]));
          widget.onLogin(sop.User.fromJSON(networkResult.data["login"]["user"]));
          Navigator.popAndPushNamed(context, '/state-of-plays');
        }
      }
    }
  }
    
  @override
  Widget build(BuildContext context) {
    
    // final imageWidth = 128.0;
    // final imageHeight = 129.0;
    // final toleranceFactor = 0.033;
    // final widthFactor = 0.125;
    // final heightFactor = 0.5;

    // final random = Random();

    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation Login(\$email: String!, \$password: String!) {
            login(email: \$email, password: \$password) {
              token
              admin
              user {
                id
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

        debugPrint('queryResult hasException: ' + result.hasException.toString());
        debugPrint('queryResult loading: ' + result.loading.toString());
        if(result.hasException && result.exception.graphqlErrors.length > 0) debugPrint('queryResult graphqlErrors: ' + result.exception.graphqlErrors[0].toString());
        else if(result.hasException) debugPrint('queryResult clientException: ' + result.exception.clientException.message);

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Connexion'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
              child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox( height: 28,),
                  Center(
                    child: Container(
                      child: Image.asset('assets/Logo/1/logo.png'),
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [0, 1, 2, 3, 4, 5, 6, 7].map((count) => FlipPanel.stream(
                        //         itemStream: Stream.fromFuture(Future.delayed(
                        //           Duration(milliseconds: random.nextInt(20) * 100), () => 1)),
                        //         itemBuilder: (_, value) => value <= 0 ? Container(
                        //           // color: Colors.white,
                        //           width: widthFactor * imageWidth,
                        //           height: heightFactor * imageHeight,
                        //         ) : ClipRect(
                        //           child: Align(
                        //             alignment: Alignment(
                        //               -1.0 + count * 2 * 0.125 + count * toleranceFactor,
                        //               -1.0),
                        //             widthFactor: widthFactor,
                        //             heightFactor: heightFactor,
                        //             child: Image.asset(
                        //               'assets/Logo/1/logo.png',
                        //               width: imageWidth,
                        //               height: imageHeight,
                        //             )
                        //           )
                        //         ),
                        //         initValue: 0,
                        //         spacing: 0.0,
                        //         direction: FlipDirection.up,
                        //       )).toList(),
                        //     ),
                        //     Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [0, 1, 2, 3, 4, 5, 6, 7].map((count) => FlipPanel.stream(
                        //         itemStream: Stream.fromFuture(Future.delayed(
                        //           Duration(milliseconds: random.nextInt(20) * 100), () => 1)),
                        //         itemBuilder: (_, value) => value <= 0 ? Container(
                        //           // color: Colors.white,
                        //           width: widthFactor * imageWidth,
                        //           height: heightFactor * imageHeight,
                        //         ) : ClipRect(
                        //           child: Align(
                        //             alignment: Alignment(
                        //               -1.0 + count * 2 * 0.125 + count * toleranceFactor,
                        //               1.0),
                        //             widthFactor: widthFactor,
                        //             heightFactor: heightFactor,
                        //             child: Container(
                        //               child: Image.asset(
                        //                 'assets/Logo/1/logo.png',
                        //                 width: imageWidth,
                        //                 height: imageHeight,
                        //               ),
                        //             )
                        //           )
                        //         ),
                        //         initValue: 0,
                        //         spacing: 0.0,
                        //         direction: FlipDirection.down,
                        //       )).toList(),
                        //     )
                        //   ],
                        // ),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(24),
                      //     topRight: Radius.circular(24),
                      //     bottomLeft: Radius.circular(24),
                      //     bottomRight: Radius.circular(24)
                      //   ),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       spreadRadius: 3,
                      //       blurRadius: 4,
                      //       offset: Offset(0, 3), // changes position of shadow
                      //     ),
                      //   ],
                      // ),
                    )
                  ),
                  SizedBox( height: 28,),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email'
                    ),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox( height: 28,),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password'
                    ),
                    obscureText: true,
                    onEditingComplete: () => _login(runMutation),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  RaisedButtonLoading(
                    child: Text('Se connecter'),
                    color: Theme.of(context).primaryColor,
                    loading: result.loading,
                    onPressed: () => _login(runMutation),
                  ),
                  SizedBox( height: 18,),
                  FlatButton(
                    child: Text('S\'inscrire'),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/register');
                    },
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}