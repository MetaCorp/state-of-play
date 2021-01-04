import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';

class NewStateOfPlayMiscComments extends StatefulWidget {
  NewStateOfPlayMiscComments({ Key key, this.stateOfPlay }) : super(key: key);

  sop.StateOfPlay stateOfPlay;

  @override
  _NewStateOfPlayMiscCommentsState createState() => _NewStateOfPlayMiscCommentsState();
}

class _NewStateOfPlayMiscCommentsState extends State<NewStateOfPlayMiscComments> {
  final _formKey = GlobalKey<FormState>();

  _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Commentaires'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _onSave,
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                MyTextFormField(
                  initialValue: widget.stateOfPlay.comments,
                  decoration: InputDecoration(labelText: 'Commentaires'),
                  onSaved: (value) => widget.stateOfPlay.comments = value,
                  maxLength: 256,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  initialValue: widget.stateOfPlay.reserve,
                  decoration: InputDecoration(labelText: 'Réserve'),
                  onSaved: (value) => widget.stateOfPlay.reserve = value,
                  maxLength: 256,
                  maxLines: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}