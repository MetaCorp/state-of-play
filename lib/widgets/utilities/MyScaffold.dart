import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/SearchStateOfPlays.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlay.dart';

import 'package:flutter_tests/widgets/utilities/MyDrawer.dart';

class MyScaffold extends StatefulWidget {
  MyScaffold({ Key key, this.body, this.appBar }) : super(key: key);

  final Widget body;
  final Widget appBar;

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

    bool _bottomSheetOpen = false;
    
    return Scaffold(
      key: globalKey,
      appBar: widget.appBar,
      body: widget.body,
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(_bottomSheetOpen == false ? Icons.add : Icons.close),
        onPressed: () {
          if (_bottomSheetOpen == false) {
            print('open BottomSheet');

            globalKey.currentState.showBottomSheet((context) {
              return Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          FlatButton(
                            child: Text("Créer un nouvel état des lieux d'entrée"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(out: false)));
                            },
                          ),
                          FlatButton(
                            child: Text("À partir d'une sortie"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => SearchStateOfPlays(
                                out: true,
                                sIn: false,
                                onSelect: (stateOfPlayId) {
                                  print("onSelect");
                                  Navigator.pop(globalKey.currentContext);
                                  Navigator.push(globalKey.currentContext, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(stateOfPlayId: stateOfPlayId, out: false)));
                                }))
                              );
                            },
                          ),
                          FlatButton(
                            child: Text("Créer un nouvel état des lieux de sortie"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(out: true)));
                            },
                          ),
                          FlatButton(
                            child: Text("À partir d'une entrée"),
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
                          )
                        ],
                      ),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              );
            });

            // setState(() { _bottomSheetOpen = true; }); // TODO : if setState() bottomSheet doesnt open
          }
          else {
            print('close BottomSheet');
            setState(() { _bottomSheetOpen = false; });
            Navigator.pop(context);
          }
        }
      ),
    );
  }
}