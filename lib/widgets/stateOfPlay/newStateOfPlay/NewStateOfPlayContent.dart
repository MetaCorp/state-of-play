import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:flutter_tests/GeneratePdf.dart';
import 'package:flutter_tests/widgets/shop/Shop.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetails.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMisc.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature/NewStateOfPlaySignature.dart';

typedef SaveCallback = void Function();
typedef DeleteCallback = void Function();

class NewStateOfPlayContent extends StatefulWidget {
  NewStateOfPlayContent({ Key key, this.stateOfPlay, this.onSave, this.title, this.onDelete, this.saveLoading, this.user }) : super(key: key);
  
  final String title;
  final sop.StateOfPlay stateOfPlay;
  final SaveCallback onSave;
  final DeleteCallback onDelete;
  final bool saveLoading;
  final sop.User user;

  @override
  _NewStateOfPlayContentState createState() => new _NewStateOfPlayContentState();
}

class _NewStateOfPlayContentState extends State<NewStateOfPlayContent> {
  final _formKey = GlobalKey<FormState>();
  
  int _selectedIndex = 0;
  bool _isPdfLoading = false;

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
  
  void _showDialogCompleteInterlocutors(context) async {
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
  
  Future<bool> _showDialogPay (context) async {// TODO: comment faire poour qu'un modale return un bool
    return await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Pour générer le pdf d'état des lieux, il vous faut 1 crédit que vous pouvez acheter dans notre boutique."),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context, false);
            }
          ),
          new FlatButton(
            child: Text('BOUTIQUE'),
            onPressed: () async {
              bool ret = await Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => Shop(isPopup: true,)));
              Navigator.pop(context, ret);
            }
          )
        ],
      )
    );
  }

  _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool ret = false;
      if (widget.user.credits == 0) {// TODO : abonnement
        ret = await _showDialogPay(context);
      }

      if (ret || widget.user.credits > 0) {

        setState(() { _isPdfLoading = true; });
        
        for (var i = 0; i < widget.stateOfPlay.rooms.length; i++) {
          
          for (var j = 0; j < widget.stateOfPlay.rooms[i].decorations.length; j++) {
            
            for (var k = 0; k < widget.stateOfPlay.rooms[i].decorations[j].images.length; k++) {
              
              widget.stateOfPlay.rooms[i].decorations[j].imageIndexes.add(widget.stateOfPlay.images.length);

              widget.stateOfPlay.images.add({
                "type": "network",
                "image": widget.stateOfPlay.rooms[i].decorations[j].images[k]
              });

            }

            for (var k = 0; k < widget.stateOfPlay.rooms[i].decorations[j].newImages.length; k++) {
              
              widget.stateOfPlay.rooms[i].decorations[j].imageIndexes.add(widget.stateOfPlay.images.length);

              widget.stateOfPlay.images.add({
                "type": "file",
                "image": widget.stateOfPlay.rooms[i].decorations[j].newImages[k]
              });

            }
          }
        }

        for (var i = 0; i < widget.stateOfPlay.meters.length; i++) {
          
          for (var j = 0; j < widget.stateOfPlay.meters[i].images.length; j++) {
            
            widget.stateOfPlay.meters[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "network",
              "image": widget.stateOfPlay.meters[i].images[j]
            });
          }

          for (var j = 0; j < widget.stateOfPlay.meters[i].newImages.length; j++) {
            
            widget.stateOfPlay.meters[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "file",
              "image": widget.stateOfPlay.meters[i].newImages[j]
            });
          }
        }

        for (var i = 0; i < widget.stateOfPlay.keys.length; i++) {
          
          for (var j = 0; j < widget.stateOfPlay.keys[i].images.length; j++) {
            
            widget.stateOfPlay.keys[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "network",
              "image": widget.stateOfPlay.keys[i].images[j]
            });
          }

          for (var j = 0; j < widget.stateOfPlay.keys[i].newImages.length; j++) {
            
            widget.stateOfPlay.keys[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "file",
              "image": widget.stateOfPlay.keys[i].newImages[j]
            });
          }
        }

        widget.stateOfPlay.newPdf = await generatePdf(widget.stateOfPlay);
        print('generatedPdf: ' + widget.stateOfPlay.newPdf.toString());
        widget.onSave();
        OpenFile.open(widget.stateOfPlay.newPdf.path);
        setState(() { _isPdfLoading = false; });
      }

    }
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
        onSave: _onSave,
        formKey: _formKey,
        isPdfLoading: _isPdfLoading,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _selectedIndex == _tabsContent.length - 1 ? (widget.saveLoading || _isPdfLoading) ? IconButton(// TODO: _isPdfLoading doesnt work
            icon: CircularProgressIndicator(),
            onPressed: null,
          ) : IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _onSave(),
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