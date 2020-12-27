import 'package:flutter/material.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetails.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMisc.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutors.dart';
// import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayProperty.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature/NewStateOfPlaySignature.dart';

typedef SaveCallback = void Function();
typedef DeleteCallback = void Function();

class NewStateOfPlayContent extends StatefulWidget {
  NewStateOfPlayContent({ Key key, this.stateOfPlay, this.onSave, this.title, this.onDelete }) : super(key: key);
  
  final String title;
  final sop.StateOfPlay stateOfPlay;
  final SaveCallback onSave;
  final DeleteCallback onDelete;

  @override
  _NewStateOfPlayContentState createState() => new _NewStateOfPlayContentState();
}

class _NewStateOfPlayContentState extends State<NewStateOfPlayContent> {
  final _formKey = GlobalKey<FormState>();
  
  int _selectedIndex = 0;

  void onNext() {
    print('property: ' + widget.stateOfPlay.property.address);
    setState(() {
      _selectedIndex = _selectedIndex + 1;
    });
  }

  void _showDialogDelete(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + widget.stateOfPlay.property.address + ', ' + widget.stateOfPlay.property.postalCode + ' ' + widget.stateOfPlay.property.city + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () {
              widget.onDelete();
            }
          )
        ],
      )
    );
  }
  
  void _showDialogCompleteInterlocutors (context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Pour accéder à la page 'Signatures', veuillez compléter les champs Propriétaire, Mandataire, Locataires et Propriété de la page 'Interlocuteurs'."),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('COMPLÉTER'),
            onPressed: () async {
              Navigator.pop(context);
              setState(() { _selectedIndex = 0; });
            }
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _tabsContent = [
      NewStateOfPlayInterlocutors(
        stateOfPlay: widget.stateOfPlay,
      ),
      // NewStateOfPlayProperty(
      //   property: widget.stateOfPlay.property,
      //   onNext: onNext,
      // ),
      NewStateOfPlayDetails(
        rooms: widget.stateOfPlay.rooms,
      ),
      NewStateOfPlayMisc(
        stateOfPlay: widget.stateOfPlay,
      ),
      NewStateOfPlaySignature(
        stateOfPlay: widget.stateOfPlay,
        onSave: widget.onSave,
        formKey: _formKey,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _selectedIndex == _tabsContent.length - 1 ? IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSave();
              }
            },
          ) : Container(),
          widget.onDelete != null ? PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Supprimer"),
                value: "delete",
              )
            ],
            onSelected: (result) {
              print("onSelected: " + result);
              if (result == "delete")
                _showDialogDelete(context);
            }
          ) : Container(),
        ]
      ),
      body: _tabsContent[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Interlocuteurs',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.house),
          //   label: 'Propriété',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Pièces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Divers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Signatures',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.grey,
        onTap: (index) {
          if (index == 3 && ((widget.stateOfPlay.owner == null || widget.stateOfPlay.owner.lastName == null)
            || (widget.stateOfPlay.representative == null || widget.stateOfPlay.representative.lastName == null)
            || (widget.stateOfPlay.property == null || widget.stateOfPlay.property.address == null)
            || (widget.stateOfPlay.tenants.length == 0))) {
            _showDialogCompleteInterlocutors(context);
            return;
          }

          setState(() { _selectedIndex = index; });
        },
      )
    );
  }
}