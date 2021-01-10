import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/IconButtonLoading.dart';
import 'package:flutter_tests/widgets/utilities/NewInterlocutor/NewInterlocutorContent.dart';

typedef SaveCallback = Function(dynamic);
typedef DeleteCallback = Function();

class NewInterlocutor extends StatefulWidget {
  NewInterlocutor({ Key key, this.title, this.interlocutor, this.onSave, this.onDelete, this.saveLoading = false }) : super(key: key);

  final String title;
  final dynamic interlocutor;
  final SaveCallback onSave;
  final DeleteCallback onDelete;
  final bool saveLoading;

  @override
  _NewInterlocutorState createState() => new _NewInterlocutorState();
}

class _NewInterlocutorState extends State<NewInterlocutor> {

  final _formKey = GlobalKey<FormState>();
 
  void _showDialogDelete(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Supprimer '" + widget.interlocutor.firstName + ' ' + widget.interlocutor.lastName + "' ?"),
            widget.interlocutor.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + widget.interlocutor.stateOfPlays.length.toString() + "' état" + (widget.interlocutor.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
          ]
        ),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButtonLoading(
            loading: widget.saveLoading,
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSave(widget.interlocutor);
              }
            }
          ),
          widget.onDelete != null ? PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Supprimer"),
                value: "delete",
              )
            ],
            onSelected: (result) {
              debugPrint("onSelected: " + result);
              if (result == "delete")
                _showDialogDelete(context);
            }
          ) : Container(),
        ],
      ),
      body: NewInterlocutorContent( 
        key: _formKey,
        title: widget.title,
        interlocutor: widget.interlocutor,
        //TODO delete??
        onSave: (interlocuteur) => widget.onSave(interlocuteur), 
      ),
    );
  }
}