
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
//import 'package:pdf/widgets.dart';

import 'package:provider/provider.dart';
import 'package:flutter_tests/providers/NewStateOfPlayProvider.dart';

class NewStateOfPlayRoomDetail extends StatefulWidget {
  NewStateOfPlayRoomDetail({Key key}) : super(key: key);

  @override
  _NewStateOfPlayRoomDetailState createState() => new _NewStateOfPlayRoomDetailState();
}

class _NewStateOfPlayRoomDetailState extends State<NewStateOfPlayRoomDetail> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //List<sop.RoomDetail>  itemList;
  //sop.RoomDetail currentRoomDetail;

  List<sop.Room> _roomList;
  List<sop.Decoration> _roomDecorationList;
  
  bool isSwitched = false;
  
  @override
  void initState() {
    _roomList = new List<sop.Room>();
    _roomDecorationList= new List<sop.Decoration>();  
    _getRoomListItems();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {

    double sizedBoxWidth = MediaQuery.of(context).size.width / 9;
    double sizedBoxHeight = MediaQuery.of(context).size.height / 22;    
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: Container(
              color: Colors.blueGrey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _roomList.length+1,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == 0){
                        return Row(
                          children: [
                            SizedBox(width: sizedBoxWidth/8),
                            Text("Liste des pièces", textScaleFactor: 2,),
                            SizedBox(width: sizedBoxWidth/8),
                            MaterialButton(
                              minWidth: sizedBoxWidth/7,
                              color: Colors.red,
                              child: Icon(Icons.add),
                              onPressed: (){
                                print("pressed");
                              },
                            ),
                          ],
                        );
                      }
                      index -=1;
                      var room = _roomList[index];
                      return ListTile(
                        title: Text(room.name),
                        trailing: Switch(
                          value: isSwitched,
                          onChanged: (bool value) { 
                            setState(() {
                              print("pressed");
                              isSwitched = value;
                            });
                          }, 
                        ),
                        onTap: (){
                          setState(() {

                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ), 
          ),
          Expanded(
            flex: 30,
            child: Container(
              color: Colors.grey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height -MediaQuery.of(context).size.height/10 -4.8,
                    child: Theme(
                      data: ThemeData(
                        canvasColor: Colors.transparent
                      ),
                      child:  ReorderableListView(
                      scrollController: ScrollController(initialScrollOffset: 0),
                      header: Row(
                        children: [
                          SizedBox(width: sizedBoxWidth/8),
                          Text("Liste des pièces", textScaleFactor: 2,),
                          SizedBox(width: sizedBoxWidth/8),
                          MaterialButton(
                            minWidth: sizedBoxWidth/7,
                            color: Colors.red,
                            child: Icon(Icons.add),
                            onPressed: (){
                              _showSelectKnownRoomDetailDialog(context);
                            },
                          ),
                        ],
                      ), 
                      children: <Widget>[
                        for(var room in _roomList)
                          Card(
                            color: Colors.blueGrey,
                            key: ValueKey(room),
                            elevation: 2.0,
                            child: ListTile(
                              title: Text(room.name),
                              leading: Icon(Icons.move_to_inbox),
                              trailing: Switch(
                                value: isSwitched,
                                onChanged: (bool value) { 
                                  setState(() {
                                    print("pressed");
                                    isSwitched = value;
                                  });
                                }, 
                              ), 
                              onTap: (){
                                setState(() {

                                });
                              },                            
                            ),
                          ), 
                      ],
                      onReorder: reorderData,
                      ),
                    ),
                  ),
                  ],
                ),
              ), 
            ),
            Expanded(
              flex: 60,
              child: Container(
                color: Colors.white
              ), 
            ),
          ],
        ),
      );
    }

    bool _submit(BuildContext context){
      bool done = false;
      if (_formKey.currentState.validate() ) {
        _formKey.currentState.save();
    /*       currentRoomDetail.address = _addressController.text;
        currentRoomDetail.postalCode = _postalCodeController.text;
        currentRoomDetail.city = _cityController.text; */
        done = true;
      }
      
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

      return done;  
    }
    //TODO Get RoomDetails List
    void _getRoomListItems() {
      setState(() {
        _roomList.add(new sop.Room(name: "room"));
        _roomList.add(new sop.Room(name: "room2"));
        _roomList.add(new sop.Room(name: "room3"));
        _roomList.add(new sop.Room(name: "room"));
        _roomList.add(new sop.Room(name: "room2"));
        _roomList.add(new sop.Room(name: "room3"));
      });
    }

    void _showSelectKnownRoomDetailDialog(context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("RoomDetail's List"),
            content: Container(
              height: MediaQuery.of(context).size.height /1.5,
              width: MediaQuery.of(context).size.width /3,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Search for RoomDetail",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    ),
                  ),                
                  /* SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var RoomDetail = itemList[index];
                        return ListTile(
                          onTap: (){
                            setState(() {
                              currentRoomDetail = RoomDetail;
                              _addressController.text = currentRoomDetail.address;
                              _postalCodeController.text = currentRoomDetail.postalCode;
                              _cityController.text = currentRoomDetail.city;
                            });
                          },
                          title: Text(RoomDetail.reference+" "+RoomDetail.address),
                        );
                      },
                    ),
                  ), */
                ],
              ),
            ),
          );
        }
      );
    } 

  void reorderData(int oldIndex, int newIndex) {
    print("test");
    setState(() {
      if(newIndex>oldIndex){
        newIndex-=1;
      }
      final room =_roomList.removeAt(oldIndex);
      _roomList.insert(newIndex, room);
    });
  }
}