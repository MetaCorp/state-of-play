
import 'package:flutter/material.dart';
import 'package:flutter_tests/GeneratePdf.dart';

import 'package:flutter_tests/providers/NewStateOfPlayProvider.dart';

import 'package:provider/provider.dart';

class NewStateOfPlaySignature extends StatefulWidget {
  NewStateOfPlaySignature({Key key}) : super(key: key);

  @override
  _NewStateOfPlaySignatureState createState() => new _NewStateOfPlaySignatureState();
}

class _NewStateOfPlaySignatureState extends State<NewStateOfPlaySignature> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstnameController= new TextEditingController();
  TextEditingController _lastnameController= new TextEditingController();
  TextEditingController _companyController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  //List<sop.Signature>  itemList;
  //sop.Signature currentSignature;

  @override
  void initState() {
    //itemList = new List<sop.Signature>();
    _getDropDownMenuItems();
    //currentSignature = new sop.Signature();
    
    super.initState();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();

    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {

    double sizedBoxWidth = MediaQuery.of(context).size.width / 9;
    double sizedBoxHeight = MediaQuery.of(context).size.height / 22;    
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    Color textColor = new Color(0xFFFAFAFA).withOpacity(0.5);

    return SingleChildScrollView(
      reverse: true,
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [  
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),             
              width: MediaQuery.of(context).size.width /2,
              child: Column(
                children: [
                  Text("Entête document"),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ), 
                    child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        "text de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settings"),
                    ),
                  ),
                  Text("Mention en Fin de document"),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ), 
                    child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        "text de Mention en Fin de document à récupérer dans les settings",
                      ),
                    ),
                  ),
                  Text("Nouvelle adresse des locataires"),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Nr° et Nom voie",
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Code Postal",
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Ville",
                      ),
                    ),
                  ),
                ],
              ),
            ),           
            Container(
              width: MediaQuery.of(context).size.width /2,
              child: Column( 
                children: [
                  SizedBox(height: sizedBoxHeight,),             
                  Text("Signatures"),
                  SizedBox(height: sizedBoxHeight,),             
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "CLiquez sur les cadres pour procéder au signatures correspondantes.",
                    ),
                  ),
                  SizedBox(height: sizedBoxHeight,), 
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width /3,
                    color: Colors.blue,
                    child: Text("Visualiser l'état des lieux"),
                    onPressed: ()=> generatePdf(context.read<NewStateOfPlayProvider>().value),
                  ),            
                ],
              ),
            ),
          ],      
        ),
      ),
    );
  }
  
  bool _submit(BuildContext context){
    bool done = false;
    if (_formKey.currentState.validate() ) {
      _formKey.currentState.save();
/*       currentSignature.address = _addressController.text;
      currentSignature.postalCode = _postalCodeController.text;
      currentSignature.city = _cityController.text; */
      done = true;
    }
    
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

    return done;  
  }
 //TODO Get Signatures List
  void _getDropDownMenuItems() {
    setState(() {

    });
  }

  void _showSelectKnownSignatureDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Signature's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Signature",
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
                      var Signature = itemList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentSignature = Signature;
                            _addressController.text = currentSignature.address;
                            _postalCodeController.text = currentSignature.postalCode;
                            _cityController.text = currentSignature.city;
                          });
                        },
                        title: Text(Signature.reference+" "+Signature.address),
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
}