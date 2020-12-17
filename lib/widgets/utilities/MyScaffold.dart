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
  TextStyle _smallTextStyle = new TextStyle( fontSize: 10);
  TextStyle _titleTextStyle = new TextStyle( fontSize: 18,fontWeight: FontWeight.bold, color: Colors.grey[700]);

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
        backgroundColor: Theme.of(context).primaryColor,
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
                color: Colors.grey[200],
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children :[
                        Row(
                          children: [
                            Center(child:Text("Entrée",style: _titleTextStyle, textAlign: TextAlign.center,),),
                          ],
                        ),
                        Row(
                          children: [
                            FlatButton(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 42,
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
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 42,
                                      color: Colors.grey[700],
                                    ),
                                    //add space
                                    Text("A partir \n d'une sortie",style: _smallTextStyle, textAlign: TextAlign.center,),
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
                              padding: EdgeInsets.all(4),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 42,
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
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 42,
                                      color: Colors.grey[700],
                                    ),
                                    //add space
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
      ),
    );
  }
}