import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/Header.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomAddDecoration.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomAddElectricity.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomAddEquipment.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomDecoration.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomElectricity.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetailsRoomEquipment.dart';

class NewStateOfPlayDetailsRoom extends StatefulWidget {
  NewStateOfPlayDetailsRoom({ Key key, this.room }) : super(key: key);

  sop.Room room;

  @override
  _NewStateOfPlayDetailsRoomState createState() => new _NewStateOfPlayDetailsRoomState();
}

class _NewStateOfPlayDetailsRoomState extends State<NewStateOfPlayDetailsRoom> {

  void _showDialogDeleteDecoration(context, sop.Decoration decoration) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + decoration.type + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async {
              widget.room.decorations.remove(decoration);
              setState(() { });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
  
  void _showDialogDeleteElectricity(context, sop.Electricity electricity) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + electricity.type + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async {
              widget.room.electricities.remove(electricity);
              setState(() { });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
  
  void _showDialogDeleteEquipment(context, sop.Equipment equipment) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + equipment.type + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async {
              widget.room.equipments.remove(equipment);
              setState(() { });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    print('room.decorations: ' + widget.room.decorations.toString());
    print('room.electricities: ' + widget.room.electricities.toString());
    print('room.equipments: ' + widget.room.equipments.toString());

    // TODO: Flexible messed up layout (used because of an error)
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: CustomScrollView (
        slivers: [ 
          SliverList( 
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if(index == 0){
                  return  Header(
                    title: "Décorations",
                    onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddDecoration(
                      onSelect: (decorations) {
                        print('decorations: ' + decorations.toString());
                        for (var i = 0; i < decorations.length; i++) {
                          widget.room.decorations.add(sop.Decoration(
                            type: decorations[i],
                            state: "Neuf",
                            nature: "",
                            comments: "",
                            images: [],
                            newImages: [],
                            imageIndexes: [],
                          ));                         
                        }
                        setState(() { });
                      },
                    ))),
                  );
                }
                index -=1;
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text(widget.room.decorations[index].type),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _showDialogDeleteDecoration(context, widget.room.decorations[index]);
                            },
                          )
                        ]
                      ),
                      // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                      onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomDecoration(
                        decoration: widget.room.decorations[index],
                        roomName: widget.room.name,
                      )))
                    ),
                    index != widget.room.decorations.length -1? Divider(): SizedBox(height:6),
                  ],
                );
              },
              childCount: widget.room.decorations.length +1,
            ),
          ),          
          SliverList(            
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if(index == 0){
                  return  Column(
                    children: [
                      Divider(thickness: 2, height: 2,),
                      Header(
                        title: "Électricité / Chauffage",
                        onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddElectricity(
                          onSelect: (electricities) {
                            print('electricities: ' + electricities.toString());
                            for (var i = 0; i < electricities.length; i++) {
                              widget.room.electricities.add(sop.Electricity(
                                type: electricities[i],
                                state: "Neuf",
                                quantity: 1,
                                comments: "",
                                images: [],
                                newImages: [],
                                imageIndexes: [],
                              ));
                            }
                            setState(() { });
                          },
                        ))),
                      ),
                    ],
                  );
                }
                index -=1;
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text(widget.room.electricities[index].type),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _showDialogDeleteElectricity(context, widget.room.electricities[index]);
                            },
                          )
                        ]
                      ),
                      // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                      onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomElectricity(
                        electricity: widget.room.electricities[index],
                        roomName: widget.room.name,
                      )))
                    ),
                    index != widget.room.electricities.length -1 ? Divider(): SizedBox(height:6),
                  ],
                );
              },
              childCount: widget.room.electricities.length + 1,
            ),
          ),
          SliverList(             
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if(index == 0){
                  return  Column(
                    children: [
                      Divider(thickness: 2, height: 2,),
                      Header(
                        title: "Équipements",
                        onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddEquipment(
                          onSelect: (equipments) {
                            print('equipments: ' + equipments.toString());
                            for (var i = 0; i < equipments.length; i++) {
                              widget.room.equipments.add(sop.Equipment(
                                type: equipments[i],
                                brandOrObject: "",
                                state: "Neuf",
                                quantity: 1,
                                comments: "",
                                imageIndexes: [],
                              ));
                            }
                            setState(() { });
                          },
                        ))),
                      ),
                    ],
                  );
                }
                index -=1;
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text(widget.room.equipments[index].type),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _showDialogDeleteEquipment(context, widget.room.equipments[index]);
                            },
                          )
                        ]
                      ),
                      // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                      onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomEquipment(
                        equipment: widget.room.equipments[index],
                        roomName: widget.room.name,
                      )))
                    ),
                     index != widget.room.electricities.length -1 ? Divider(): SizedBox(height:6),
                  ],
                );
              },
              childCount: widget.room.equipments.length + 1,
            ),
          ),
        ],
      ),
      //  Column(
      //     children: [
      //       Header(
      //         title: "Décorations",
      //         onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddDecoration(
      //           onSelect: (decorations) {
      //             print('decorations: ' + decorations.toString());
      //             for (var i = 0; i < decorations.length; i++) {
      //               widget.room.decorations.add(sop.Decoration(
      //                 type: decorations[i],
      //                 state: "Neuf",
      //                 nature: "",
      //                 comments: "",
      //                 images: [],
      //                 newImages: []
      //               ));
                    
      //             }
      //             setState(() { });
      //           },
      //         ))),
      //       ),
      //       Flexible(
      //         flex: 1,
      //         child: ListView.separated(
      //           physics: const NeverScrollableScrollPhysics(),
      //           itemCount: widget.room.decorations.length,
      //           itemBuilder: (_, i) => ListTile(
      //             title: Row(
      //               children: [
      //                 Text(widget.room.decorations[i].type),
      //                 Spacer(),
      //                 IconButton(
      //                   icon: Icon(Icons.close),
      //                   onPressed: () {
      //                     _showDialogDeleteDecoration(context, widget.room.decorations[i]);
      //                   },
      //                 )
      //               ]
      //             ),
      //             // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
      //             onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomDecoration(
      //               decoration: widget.room.decorations[i],
      //               roomName: widget.room.name,
      //             )))
      //           ),
      //           separatorBuilder: (context, index) {
      //             return Divider();
      //           },
      //         ),
      //       ),
      //       Divider(),

      //       Header(
      //         title: "Électricité / Chauffage",
      //         onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddElectricity(
      //           onSelect: (electricities) {
      //             print('electricities: ' + electricities.toString());
      //             for (var i = 0; i < electricities.length; i++) {
      //               widget.room.electricities.add(sop.Electricity(
      //                 type: electricities[i],
      //                 state: "Neuf",
      //                 quantity: 1,
      //                 comments: "",
      //                 images: [],
      //                 newImages: []
      //               ));
                    
      //             }
      //             setState(() { });
      //           },
      //         ))),
      //       ),
      //       Flexible(
      //         flex: 1,
      //         child: ListView.separated(
      //           physics: const NeverScrollableScrollPhysics(),
      //           itemCount: widget.room.electricities.length,
      //           itemBuilder: (_, i) => ListTile(
      //             title: Row(
      //               children: [
      //                 Text(widget.room.electricities[i].type),
      //                 Spacer(),
      //                 IconButton(
      //                   icon: Icon(Icons.close),
      //                   onPressed: () {
      //                     _showDialogDeleteElectricity(context, widget.room.electricities[i]);
      //                   },
      //                 )
      //               ]
      //             ),
      //             // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
      //             onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomElectricity(
      //               electricity: widget.room.electricities[i],
      //               roomName: widget.room.name,
      //             )))
      //           ),
      //           separatorBuilder: (context, index) {
      //             return Divider();
      //           },
      //         ),
      //       ),
      //       Divider(),

            
      //       Header(
      //         title: "Équipement",
      //         onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomAddEquipment(
      //           onSelect: (equipments) {
      //             print('equipments: ' + equipments.toString());
      //             for (var i = 0; i < equipments.length; i++) {
      //               widget.room.equipments.add(sop.Equipment(
      //                 type: equipments[i],
      //                 brandOrObject: "",
      //                 state: "Neuf",
      //                 quantity: 1,
      //                 comments: "",
      //               ));
      //             }
      //             setState(() { });
      //           },
      //         ))),
      //       ),
      //       Flexible(
      //         flex: 1,

      //         child: ListView.separated(
      //           physics: const NeverScrollableScrollPhysics(),
      //           itemCount: widget.room.equipments.length,
      //           itemBuilder: (_, i) => ListTile(
      //             title: Row(
      //               children: [
      //                 Text(widget.room.equipments[i].type),
      //                 Spacer(),
      //                 IconButton(
      //                   icon: Icon(Icons.close),
      //                   onPressed: () {
      //                     _showDialogDeleteEquipment(context, widget.room.equipments[i]);
      //                   },
      //                 )
      //               ]
      //             ),
      //             // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
      //             onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayDetailsRoomEquipment(
      //               equipment: widget.room.equipments[i],
      //               roomName: widget.room.name,
      //             )))
      //           ),
      //           separatorBuilder: (context, index) {
      //             return Divider();
      //           },
      //         ),
      //       ),
      //     ]
      //   ),
    
    );
  }
}