import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

typedef SaveCallback = void Function();


class NewStateOfPlaySignatureSignature extends StatefulWidget {

  NewStateOfPlaySignatureSignature({ Key key, this.onSave, this.interlocutor}) : super(key: key);

  final SaveCallback onSave;
  final dynamic interlocutor;

  @override
  _NewStateOfPlaySignatureSignatureState createState() => new _NewStateOfPlaySignatureSignatureState();
}

// TODO Get liste interlocuteurs pour les signatures et locataires pour mise à jour adresse
class _NewStateOfPlaySignatureSignatureState extends State<NewStateOfPlaySignatureSignature> {

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => debugPrint("Value changed"));
  }

  @override
  Widget build(BuildContext context) {

    double sizedBoxHeight = 20;  
    const double margin = 8;  

    return Scaffold(
      appBar: AppBar(
        // TODO center title not working
        centerTitle: true,
        title: Text(widget.interlocutor.firstName + ' ' + widget.interlocutor.lastName),
        actions : [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              Uint8List data = await _controller.toPngBytes();
              Navigator.pop(context, data);
            },
          ),
        ],
      ),    
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: sizedBoxHeight),             
            Text("Signature :"),
            SizedBox(height: sizedBoxHeight),             
            Container(
              margin: const EdgeInsets.all(margin),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
              ), 
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.white70,
                height: 300,
                width: MediaQuery.of(context).size.width -(margin*2+2*2),
              ),
            ),
            SizedBox(height: sizedBoxHeight),             
            RaisedButton(
              shape: CircleBorder(),
              color:  Colors.red,
              child: Icon(Icons.close),
              onPressed: () { 
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}