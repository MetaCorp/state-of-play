import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

typedef SaveCallback = void Function();


class NewStateOfPlaySignatureSignature extends StatefulWidget {
  NewStateOfPlaySignatureSignature({ Key key, this.onSave}) : super(key: key);

  final SaveCallback onSave;

  @override
  _NewStateOfPlaySignatureSignatureState createState() => new _NewStateOfPlaySignatureSignatureState();
}

// TODO Get liste interlocuteurs pour les signatures et locataires pour misa à jour adresse
class _NewStateOfPlaySignatureSignatureState extends State<NewStateOfPlaySignatureSignature> {

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {

    double sizedBoxHeight = 20;  
    const double margin = 8;  

    return Scaffold(
      appBar: AppBar(
        // TODO center title not working
        title:  Center(child: Text("@interlo1")),
      ),    
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: sizedBoxHeight),             
          Text("Signature :"),
          Container(
            margin: const EdgeInsets.all(margin),
            padding: const EdgeInsets.all(margin),      
            decoration: BoxDecoration(
              border: Border.all(),
            ), 
            child: Signature(
                controller: _controller,
                backgroundColor: Colors.lightBlueAccent,
                height: 300,
                width: MediaQuery.of(context).size.width -(margin*4+2),
              ),
          ),
        ],
      ),
    );
  }
}