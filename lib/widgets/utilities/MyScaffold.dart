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

  bool _bottomSheetOpen;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomSheetOpen = false;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: globalKey,
      appBar: widget.appBar,
      body: widget.body,
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        // Put animation Icon rotation
        // https://stackoverflow.com/questions/57585755/how-do-i-configure-flutters-showmodalbottomsheet-opening-closing-animation
        child: _bottomSheetOpen == false ? Icon(Icons.add) : Icon(Icons.close),
        onPressed: () {
          if (_bottomSheetOpen == false) {
            print('open BottomSheet');          
            setState(() { 
              _bottomSheetOpen = true;
              print("VALUE:"+_bottomSheetOpen.toString()); 
            });
            globalKey.currentState.showBottomSheet((context) {            
              return Container(
                color: Colors.grey,
                height: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children :[
                        Row(
                          children: [
                            Center(child:Text("Entrée",style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                          ],
                        ),
                        Divider(thickness: 2, height: 2, color: Colors.black,),
                        Row(
                          children: [
                            FlatButton(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_left_rounded),
                                    //add space
                                    Text("A partir \n d'une sortie",style: TextStyle( fontSize: 10), textAlign: TextAlign.center,),
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
                            FlatButton(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    //add space
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(out: false)));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children :[
                        Row(
                          children: [
                            Center(child:Text("Sortie",style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                          ],
                        ),
                        Divider(thickness: 2, height: 2, color: Colors.black,),
                        Row(
                          children: [
                            FlatButton(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_right_rounded),
                                    //add space
                                    Text("A partir  \n d'une entrée",style: TextStyle( fontSize: 10), textAlign: TextAlign.center,),
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
                            FlatButton(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    //add space
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(out: true)));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).closed.then((value)  {
              print('THEN close BottomSheet');
              setState(() { _bottomSheetOpen = false; });
            });
          } else {
            Navigator.pop(context);
          }
        }
      ),
    );
  }
}