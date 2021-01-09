import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/SearchStateOfPlays.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlay.dart';
import 'package:flutter_tests/widgets/utilities/MyDrawer.dart';

import 'package:flutter_tests/Icons/e_d_l_icons_icons.dart';

import 'package:feature_discovery/feature_discovery.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyScaffold extends StatefulWidget {
  MyScaffold({ Key key, this.body, this.appBar }) : super(key: key);

  final Widget body;
  final Widget appBar;

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {

  bool _bottomSheetOpen;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  TextStyle _smallTextStyle = new TextStyle( fontSize: 7 );
  TextStyle _titleTextStyle = new TextStyle( fontSize: 18,fontWeight: FontWeight.bold, color: Colors.grey[700]);
        
  sop.User _user;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sop.User user = sop.User.fromJSON(jsonDecode(prefs.getString("user")));
    debugPrint('user.stateOfPlays.length: ' + user.stateOfPlays.length.toString());
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    getSharedPrefs();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      Future.delayed(const Duration(seconds: 1), () => FeatureDiscovery.discoverFeatures(
        context,
        const <String>{ // Feature ids for every feature that you want to showcase in order.
          'add_sop',
        },
      ));
    });
    super.initState();
    _bottomSheetOpen = false;
  }

  
  void _showDialogPaidOnce(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Ajouter plus d'un état des lieux demande d'avoir payé une fois."),
        actions: [
          FlatButton(
            child: Text('FERMER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          FlatButton(
            child: Text('BOUTIQUE'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/shop');
            }
          )
        ],
      )
    );
  }
  
  void _showDialogLimitBeta(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("La création d'état des lieux est limité à 5 pendant la béta. Veuillez nous contacter pour toutes demandes."),
        actions: [
          FlatButton(
            child: Text('FERMER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          FlatButton(
            child: Text('CONTACTER'),
            onPressed: () async {
              final Email email = Email(
                // body: 'Email body',
                // subject: 'Email subject',
                recipients: ['housely.contact@gmail.com'],
                // cc: ['cc@example.com'],
                // bcc: ['bcc@example.com'],
                // attachmentPaths: ['/path/to/attachment.zip'],
                isHTML: false,
              );

              FlutterEmailSender.send(email);
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  _onFabPress() {

    if (_user == null)
      return;

    if (_user.stateOfPlays.length >= 5) {
      _showDialogLimitBeta(context);
      return;
    }

    if (_bottomSheetOpen) {
      Navigator.pop(context);
      return;
    }

    // if (user == null)
    //   return;

    // if ((user.paidOnce == null || !user.paidOnce) && user.stateOfPlays.length >= 1) {
    //   _showDialogPaidOnce(context);
    //   return;
    // }

    if (_bottomSheetOpen == false) {
      debugPrint('open BottomSheet');          
      setState(() { 
        _bottomSheetOpen = true;
        debugPrint("VALUE:"+_bottomSheetOpen.toString()); 
      });
      globalKey.currentState.showBottomSheet((context) {            
        return Container(
          color: Colors.grey[200],
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Center(child:Text("Entrée",style: _titleTextStyle, textAlign: TextAlign.center,),),
                    ],
                  ),
                  Row(
                    children: [
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                        minWidth: 0,
                        height: 0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 36,
                                color: Colors.grey[700],
                              ),
                              //add space
                              Text("Nouvel\nEDL d'entrée",style: _smallTextStyle, textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(out: false)));
                        },
                      ),
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                        minWidth: 0,
                        height: 0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EDLIcons.edlRight,
                                size: 30,
                                color: Colors.grey[700],
                              ),
                              //add space
                              SizedBox(height: 6,),
                              Text("A partir\n d'une sortie",style: _smallTextStyle, textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => SearchStateOfPlays(
                            out: true,
                            sIn: false,
                            onSelect: (stateOfPlayId) {
                              debugPrint("onSelect");
                              Navigator.pop(globalKey.currentContext);
                              Navigator.push(globalKey.currentContext, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(stateOfPlayId: stateOfPlayId, out: false)));
                            }
                          ),),);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              VerticalDivider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children :[
                  Row(
                    children: [
                      Center(child:Text("Sortie",style: _titleTextStyle, textAlign: TextAlign.center,)),
                    ],
                  ),
                  Row(
                    children: [
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                        minWidth: 0,
                        height: 0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 36,
                                color: Colors.grey[700],
                              ),
                              //add space
                              Text("Nouvel\nEDL de sortie",style: _smallTextStyle, textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(out: true)));
                        },
                      ),
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                        minWidth: 0,
                        height: 0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EDLIcons.edlLeft,
                                size: 30,
                                color: Colors.grey[700],
                              ),
                              //add space
                              SizedBox(height: 6,),
                              Text("A partir  \n d'une entrée",style: _smallTextStyle, textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => SearchStateOfPlays(
                            out: false,
                            sIn: true,
                            onSelect: (stateOfPlayId) {
                              debugPrint("onSelect");
                              Navigator.pop(globalKey.currentContext);
                              Navigator.push(globalKey.currentContext, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(stateOfPlayId: stateOfPlayId, out: true)));
                            }))
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }).closed.then((value) {
        debugPrint('THEN close BottomSheet');
        setState(() { _bottomSheetOpen = false; });
      });
    } else {
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
              email
              paidOnce
              stateOfPlays {
                id
              }
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

        debugPrint('userResult: ' + result.loading.toString());
        debugPrint('userResult hasException: ' + result.hasException.toString());
        debugPrint('userResult data: ' + result.data.toString());
        if (result.hasException) {
          if (result.exception.graphqlErrors.length > 0) { 
            debugPrint("userResult exception: " + result.exception.graphqlErrors[0].toString());
            debugPrint("userResult exception: " + result.exception.graphqlErrors[0].extensions.toString());
          }
          else
            debugPrint("userResult clientException: " + result.exception.clientException.message);
        }
        debugPrint('');

        if (result.data != null && result.data["user"] != null && !result.loading) {
          _user = sop.User.fromJSON(result.data["user"]);
          debugPrint('user: ' + _user.firstName.toString());
        }
        
        // return
        return Scaffold(
          key: globalKey,
          appBar: widget.appBar,
          body: widget.body,
          drawer: MyDrawer(user: _user),
          floatingActionButton: DescribedFeatureOverlay(
            featureId: 'add_sop',
            tapTarget: Icon(Icons.add),
            title: Text('Réaliser un nouvel état des lieux'),
            description: Text("Pour réaliser un état des lieux, cliquez sur le bouton + en bas de l'app. Puis choisissez entre état des lieux de sortie ou d'entrée."),
            onComplete: () async {
              _onFabPress();
              return true;
            },
            child: FloatingActionButton(
              // Put animation Icon rotation
              // https://stackoverflow.com/questions/57585755/how-do-i-configure-flutters-showmodalbottomsheet-opening-closing-animation
              backgroundColor: Theme.of(context).primaryColor,
              child: _bottomSheetOpen == false ? Icon(
                Icons.add,
                color: Colors.black,  
              ) : Icon(
                Icons.close,
                color: Colors.black
              ),
              onPressed: () => _onFabPress(),
            )
          )
        );
      }
    );
  }
}