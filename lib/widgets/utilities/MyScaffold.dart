import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/SearchStateOfPlays.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlay.dart';
import 'package:flutter_tests/widgets/utilities/MyDrawer.dart';

import 'package:flutter_tests/Icons/e_d_l_icons_icons.dart';

import 'package:feature_discovery/feature_discovery.dart';

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
        
  sop.User user;

  @override
  void initState() {
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
          new FlatButton(
            child: Text('FERMER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
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

  _onFabPress() {
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
      print('open BottomSheet');          
      setState(() { 
        _bottomSheetOpen = true;
        print("VALUE:"+_bottomSheetOpen.toString()); 
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
                              print("onSelect");
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
                              print("onSelect");
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
        print('THEN close BottomSheet');
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

        // print('userResult: ' + result.loading.toString());
        // print('userResult hasException: ' + result.hasException.toString());
        // print('userResult data: ' + result.data.toString());
        // if (result.hasException) {
        //   if (result.exception.graphqlErrors.length > 0) { 
        //     print("userResult exception: " + result.exception.graphqlErrors[0].toString());
        //     print("userResult exception: " + result.exception.graphqlErrors[0].extensions.toString());
        //   }
        //   else
        //     print("userResult clientException: " + result.exception.clientException.message);
        // }
        // print('');

        if (result.data != null && result.data["user"] != null && !result.loading) {
          user = sop.User.fromJSON(result.data["user"]);
          print('user: ' + user.firstName.toString());
        }
        
        return Scaffold(
          key: globalKey,
          appBar: widget.appBar,
          body: widget.body,
          drawer: MyDrawer(user: user),
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
              onPressed: _onFabPress,
            )
          )
        );
      }
    );
  }
}